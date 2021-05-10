# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# créer une organisation TEST 
organisation = Organisation.create( nom: 'ASSO CANTINE TEST', 
                                    email: 'asso-cantine-test@gmail.com', 
                                    zone: 'A')

organisation.structures.create(nom: 'Cantine')
organisation.structures.first.classrooms.create(nom: 'CP')
organisation.comptes.create(nom: 'MARTIN')
organisation.facture_chronos.create(index: 1)
organisation.tarif_types.create(nom: 'Général')
organisation.prestation_types.create(nom: 'Repas')
organisation.tarif_types.first.tarifs.create(prestation_type: organisation.prestation_types.first, prix: 1.00)
