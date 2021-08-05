require 'test_helper'

class PrestationTypeTest < ActiveSupport::TestCase

	test "un type de prestation a quelques champs obligatoires" do
		type_prestation = PrestationType.new

		assert type_prestation.invalid?
		assert type_prestation.errors[:organisation_id].any?
		assert type_prestation.errors[:nom].any?
	end

	test "un type de prestation de même nom doit être unique à chaque organisation" do
		prestation_type_repas = prestation_types(:repas).dup
		prestation_type_repas.valid?
		assert_equal ["n'est pas disponible"], prestation_type_repas.errors[:nom]
	end

	test "le type de prestation doit être créé s'il a des attributs valides" do
		prestation_type_repas = prestation_types(:repas)
		assert prestation_type_repas.valid?
	end

end