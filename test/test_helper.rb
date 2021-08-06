ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup do
    monoprix = organisations(:monoprix)
    @user_001 = monoprix.users.create(email: 'toto@gmail.com', role: 'admin', password: '12345ZEIMFJ67U', password_confirmation: '12345ZEIMFJ67U', confirmed_at: DateTime.now)
    tarif_general = tarif_types(:general)
    sainteclotilde = structures(:sainteclotilde)
    classe_cp = classrooms(:cp)
    compte_dupont = comptes(:dupont)
    maman_thomas = contacts(:maman)
    enfant_thomas = enfants(:thomas)
    prestation_type_repas = prestation_types(:repas)
    reservation_repas_thomas = reservations(:reservation_repas_thomas)
    absence_thomas = absences(:absence_thomas)
    facture_message_actif = facture_messages(:one)
    facture_dupont = factures(:one)
    jeanguile = vacances(:jeanguile)
  end

  def login_user
    visit new_user_session_path
    sleep(2)
    click_on "Tout accepter"
    fill_in 'user_email', with: @user_001.email
    fill_in 'user_password', with: @user_001.password
    click_on 'Se connecter'
  end

  # Add more helper methods to be used by all tests here...
end
