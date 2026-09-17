require "test_helper"

# Ne couvre pour l'instant que l'action dashboard d'AdminController.
class AdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "un administrateur obtient le tableau de bord" do
    sign_in users(:user_001)

    get admin_dashboard_url

    assert_response :success
  end

  test "un utilisateur visiteur est renvoyé vers son compte" do
    sign_in users(:user_visiteur)

    get admin_dashboard_url

    assert_redirected_to moncompte_index_path
  end

  test "sans période demandée le tableau de bord part de la création de l'organisation" do
    sign_in users(:admin_asso_créée_en_2024)

    get admin_dashboard_url

    assert_select "p", text: %r{Période du 01/01/2024 au #{Date.today.strftime("%d/%m/%Y")}}
  end

  test "une date de période illisible ramène à la période par défaut" do
    sign_in users(:admin_asso_créée_en_2024)

    get admin_dashboard_url, params: { date_début: "pas-une-date", date_fin: "" }

    assert_select "p", text: %r{Période du 01/01/2024 au #{Date.today.strftime("%d/%m/%Y")}}
  end

  test "des bornes de période inversées sont remises dans l'ordre" do
    sign_in users(:user_001)

    get admin_dashboard_url, params: { date_début: "2024-03-31", date_fin: "2024-03-01" }

    assert_select "p", text: %r{Période du 01/03/2024 au 31/03/2024}
    assert_select "p", text: /Nombre de Prestations\s*:\s*3\b/
  end

  test "seules les prestations, factures et paiements de la période sont comptés" do
    sign_in users(:user_001)

    get admin_dashboard_url, params: { date_début: "2024-03-01", date_fin: "2024-03-31" }

    assert_select "p", text: /Nombre de Prestations\s*:\s*3\b/
    assert_select "p", text: /Nombre de Factures\s*:\s*1\b/
    assert_select "p", text: /Total des Factures\s*:\s*10[.,]00/
    assert_select "p", text: /Total des Paiements\s*:\s*5[.,]00/
  end

  test "les effectifs de comptes, enfants et classes ignorent la période" do
    sign_in users(:user_001)
    asso_cantine = organisations(:asso_cantine)

    get admin_dashboard_url, params: { date_début: "2024-06-01", date_fin: "2024-06-30" }

    assert_select "p", text: /Nombre de Comptes\s*:\s*#{asso_cantine.comptes.count}\b/
    assert_select "p", text: /Nombre d'Enfants\s*:\s*#{asso_cantine.enfants.count}\b/
    assert_select "p", text: /Nombre de Classes\s*:\s*#{asso_cantine.classrooms.count}\b/
  end

  test "les prestations de la période sont ventilées par type" do
    sign_in users(:user_001)

    get admin_dashboard_url, params: { date_début: "2024-03-01", date_fin: "2024-03-31" }

    assert_select "li", text: /Repas\s*:\s*2\b/
    assert_select "li", text: /Garderie\s*:\s*1\b/
  end

  test "un type de prestation inutilisé sur la période est ventilé à zéro" do
    sign_in users(:user_001)

    get admin_dashboard_url, params: { date_début: "2024-03-11", date_fin: "2024-03-31" }

    assert_select "li", text: /Repas\s*:\s*1\b/
    assert_select "li", text: /Garderie\s*:\s*0\b/
  end

  test "le graphique de facturation comporte les mois de la période restés sans facture" do
    sign_in users(:user_001)

    get admin_dashboard_url, params: { date_début: "2024-03-01", date_fin: "2024-05-31" }

    mois, montants = séries_du_graphique
    assert_equal ["2024-03", "2024-04", "2024-05"], mois
    assert_equal [10.0, 0.0, 20.0], montants
  end

  test "les montants du graphique sont des nombres et non des chaînes" do
    sign_in users(:user_001)

    get admin_dashboard_url, params: { date_début: "2024-03-01", date_fin: "2024-03-31" }

    _mois, montants = séries_du_graphique
    montants.each { |montant| assert_kind_of Numeric, montant }
  end

private

  # Le graphique n'est pas rendu en HTML : le contrôleur expose ses deux séries en JSON
  # dans le <script> de la page, seul endroit observable faute de rails-controller-testing.
  def séries_du_graphique
    [JSON.parse(response.body[/labels: (\[.*?\]),/m, 1]),
     JSON.parse(response.body[/data: (\[.*?\]),/m, 1])]
  end
end
