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
    @enfant_thomas = enfants(:thomas)
  end

  def login_user
    sleep(1)
    click_on "Tout accepter"
    visit new_user_session_path
    fill_in 'user_email', with: @user_001.email
    fill_in 'user_password', with: @user_001.password
    click_on 'Se connecter'
  end

  # Add more helper methods to be used by all tests here...
end
