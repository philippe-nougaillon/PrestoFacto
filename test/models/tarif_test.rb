require 'test_helper'

class TarifTest < ActiveSupport::TestCase

	test "un tarif a quelques champs obligatoires" do
		tarif = Tarif.new

		assert tarif.invalid?
		assert tarif.errors[:tarif_type_id].any?
		assert tarif.errors[:prestation_type_id].any?
		assert tarif.errors[:prix].any?
	end

	test "un tarif doit couter au moins 0.01 €" do
		tarif = Tarif.new

		tarif.prix = 0
		assert tarif.invalid?
		assert_equal ["doit être supérieur ou égal à 0.01"], tarif.errors[:prix]
	end

	test "un type de tarif de même nom doit être unique à chaque organisation" do
		tarif = tarifs(:one).dup
		tarif.valid?
		assert_equal ["n'est pas disponible"], tarif.errors[:tarif_type_id]
	end

	test "le tarif doit être créé s'il a des attributs valides" do
		tarif = tarifs(:one)
		assert tarif.valid?
	end

end