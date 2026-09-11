require "test_helper"
require_relative "../support/archive_zip"

class FacturesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ArchiveZip

  setup do
    sign_in @user_001
    @facture_dupont = factures(:facture_dupont)
    @facture_martin = factures(:facture_martin)
  end

  test "demander le téléchargement groupé renvoie une archive zip" do
    télécharger_les_pdf(@facture_dupont)

    assert_response :success
    assert_equal "application/zip", response.media_type
  end

  test "l'archive téléchargée est nommée d'après la date du jour" do
    télécharger_les_pdf(@facture_dupont)

    assert_match "filename=\"Factures_#{Date.today}.zip\"", response.headers["Content-Disposition"]
  end

  test "l'archive téléchargée contient une facture par case cochée" do
    télécharger_les_pdf(@facture_dupont, @facture_martin)

    assert_equal ["Facture_1-2026_1.pdf", "Facture_1-2026_2.pdf"],
                 entrées_de_l_archive(response.body).keys.sort
  end

  test "une facture non cochée est absente de l'archive téléchargée" do
    télécharger_les_pdf(@facture_dupont)

    assert_not_includes entrées_de_l_archive(response.body).keys, "Facture_1-2026_2.pdf"
  end

  test "demander le téléchargement groupé ne modifie aucune facture" do
    état_avant = @facture_dupont.workflow_state

    télécharger_les_pdf(@facture_dupont)

    assert_equal état_avant, @facture_dupont.reload.workflow_state
    assert_nil @facture_dupont.envoyée_le
  end

  private

    # Reproduit la soumission du formulaire de la liste : les cases cochées et l'action choisie
    def télécharger_les_pdf(*factures)
      post action_factures_path, params: {
        factures_id: factures.to_h { |facture| [facture.id.to_s, "yes"] },
        action_name: "Télécharger les PDF"
      }
    end
end
