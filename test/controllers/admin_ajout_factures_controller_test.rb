require "test_helper"

class AdminAjoutFacturesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @compte       = comptes(:dupont)
    @enfant       = enfants(:thomas)
    @repas        = prestation_types(:repas)

    [Date.new(2024, 1, 15), Date.new(2024, 2, 15), Date.new(2024, 3, 15)].each do |date|
      @enfant.prestations.create!(prestation_type: @repas, date: date, qté: 1)
    end
    @prestation_hors_période =
      @enfant.prestations.create!(prestation_type: @repas, date: Date.new(2024, 4, 15), qté: 1)

    sign_in @user_001
  end

  # Période éloignée de Date.today, que les fixtures occupent déjà par une prestation et une absence
  DATE_DÉBUT = Date.new(2024, 1, 1)
  DATE_FIN   = Date.new(2024, 3, 31)

  test "le formulaire propose le mois précédent par défaut" do
    get admin_ajout_factures_url

    mois_dernier = Date.today.prev_month
    assert_select "input[name=date_début][value=?]", mois_dernier.beginning_of_month.to_s
    assert_select "input[name=date_fin][value=?]",   mois_dernier.end_of_month.to_s
  end

  test "une période de plusieurs mois produit une seule facture par compte" do
    assert_difference -> { @compte.factures.count }, +1 do
      facturer(date_début: DATE_DÉBUT, date_fin: DATE_FIN, enregistrer: '1')
    end

    facture = dernière_facture_du_compte

    assert_equal 3, facture.facture_lignes.count
    assert_equal 3, facture.prestations.count
    assert_nil @prestation_hors_période.reload.facture_id
    assert_equal "Période du #{I18n.l DATE_DÉBUT} au #{I18n.l DATE_FIN}", facture.mémo
    assert_equal 3, facture.montant
  end

  test "les bornes de la période sont incluses" do
    prestations_aux_bornes = [DATE_DÉBUT, DATE_FIN].map do |date|
      @enfant.prestations.create!(prestation_type: @repas, date: date, qté: 1)
    end

    facturer(date_début: DATE_DÉBUT, date_fin: DATE_FIN, enregistrer: '1')

    prestations_aux_bornes.each { |prestation| assert_not_nil prestation.reload.facture_id }
  end

  test "sans enregistrement aucune facture n'est créée" do
    assert_no_difference -> { Facture.count } do
      facturer(date_début: DATE_DÉBUT, date_fin: DATE_FIN, enregistrer: '0')
    end

    assert_response :success
    assert_select "pre",
                  text: /du #{Regexp.escape(I18n.l(DATE_DÉBUT))} au #{Regexp.escape(I18n.l(DATE_FIN))}/
  end

  test "une prestation déjà facturée n'est pas refacturée" do
    facturer(date_début: DATE_DÉBUT, date_fin: DATE_FIN, enregistrer: '1')

    assert_no_difference -> { FactureLigne.count } do
      facturer(date_début: DATE_DÉBUT, date_fin: DATE_FIN, enregistrer: '1')
    end
  end

  test "une période aux bornes inversées est refusée, pas remise à l'endroit" do
    assert_no_difference -> { Facture.count } do
      facturer(date_début: DATE_FIN, date_fin: DATE_DÉBUT, enregistrer: '1')
    end

    assert_response :unprocessable_entity
    assert_match(/date de fin/, flash[:alert])
  end

  test "une date de début vide est refusée" do
    assert_no_difference -> { Facture.count } do
      facturer(date_début: "", date_fin: DATE_FIN, enregistrer: '1')
    end

    assert_response :unprocessable_entity
    assert_match(/date de début/, flash[:alert])
  end

  test "une date de fin vide est refusée" do
    assert_no_difference -> { Facture.count } do
      facturer(date_début: DATE_DÉBUT, date_fin: "", enregistrer: '1')
    end

    assert_response :unprocessable_entity
    assert_match(/date de fin/, flash[:alert])
  end

  test "une date impossible est refusée" do
    assert_no_difference -> { Facture.count } do
      facturer(date_début: "2024-02-31", date_fin: DATE_FIN, enregistrer: '1')
    end

    assert_response :unprocessable_entity
    assert_match(/Période invalide/, flash[:alert])
  end

  test "une date au format français est refusée plutôt que réinterprétée" do
    assert_no_difference -> { Facture.count } do
      facturer(date_début: "01/06/2024", date_fin: DATE_FIN, enregistrer: '1')
    end

    assert_response :unprocessable_entity
    assert_match(/Période invalide/, flash[:alert])
  end

  test "une saisie refusée est réaffichée avec son compte et son message" do
    facturer(date_début: DATE_FIN, date_fin: DATE_DÉBUT, enregistrer: '1')

    assert_select "input[name=date_début][value=?]", DATE_FIN.to_s
    assert_select "input[name=date_fin][value=?]",   DATE_DÉBUT.to_s
    assert_select "select[name=compte_id] option[selected][value=?]", @compte.id.to_s
    assert_select ".alert", /Période invalide/
  end

  private

  def facturer(date_début:, date_fin:, enregistrer:)
    post admin_ajout_factures_do_url, params: {
      date_début: date_début, date_fin: date_fin,
      enregistrer: enregistrer, compte_id: @compte.id
    }
  end

  # unscoped : le default_scope de Facture trie par réf DESC et prendrait le pas sur order(:id),
  # renvoyant la facture de fixture (réf 1234) déjà rattachée à ce compte
  def dernière_facture_du_compte
    Facture.unscoped.where(compte: @compte).order(:id).last
  end
end
