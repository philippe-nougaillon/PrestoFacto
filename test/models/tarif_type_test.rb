require 'test_helper'

class TarifTypeTest < ActiveSupport::TestCase

	test "un type de tarif a un champs obligatoire" do
		tarif_type = TarifType.new

		assert tarif_type.invalid?
		assert tarif_type.errors[:nom].any?
	end

	test "un type de tarif de même nom doit être unique à chaque organisation" do
		tarif_type = tarif_types(:general).dup
		tarif_type.valid?
		assert_equal ["n'est pas disponible"], tarif_type.errors[:nom]
	end

	test "le type de tarif doit être créé s'il a des attributs valides" do
		tarif_type = tarif_types(:general)
		assert tarif_type.valid?
	end
    
end