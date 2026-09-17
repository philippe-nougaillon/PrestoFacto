require "test_helper"
require_relative "../support/archive_zip"

class FacturesToZipTest < ActiveSupport::TestCase
  include ArchiveZip

  test "l'archive contient un PDF par facture sélectionnée" do
    factures = Facture.where(id: [factures(:facture_dupont).id, factures(:facture_martin).id])

    assert_equal 2, entrées_de_l_archive(FacturesToZip.new(factures).call).size
  end

  test "chaque entrée de l'archive est nommée d'après la référence de sa facture" do
    factures = Facture.where(id: [factures(:facture_dupont).id, factures(:facture_martin).id])

    assert_equal ["Facture_1-2026_1.pdf", "Facture_1-2026_2.pdf"],
                 entrées_de_l_archive(FacturesToZip.new(factures).call).keys.sort
  end

  test "deux factures de comptes différents portant la même référence produisent deux entrées distinctes" do
    factures = Facture.where(id: [factures(:facture_dupont).id,
                                  factures(:facture_martin_même_référence_que_dupont).id])

    noms = entrées_de_l_archive(FacturesToZip.new(factures).call).keys

    assert_equal 2, noms.uniq.size
    assert_includes noms, "Facture_1-2026_1.pdf"
    assert_includes noms, "Facture_1-2026_1_2.pdf"
  end

  test "chaque entrée de l'archive est un PDF d'une seule page" do
    factures = Facture.where(id: [factures(:facture_dupont).id, factures(:facture_martin).id])

    entrées_de_l_archive(FacturesToZip.new(factures).call).each_value do |contenu|
      assert contenu.start_with?("%PDF-"), "l'entrée n'est pas un PDF"
      assert_equal 1, contenu.scan("/Type /Page\n").size
    end
  end

  test "le PDF d'une facture porte sa propre référence et pas celle des autres" do
    factures = Facture.where(id: [factures(:facture_dupont).id, factures(:facture_martin).id])

    pdf_dupont = entrées_de_l_archive(FacturesToZip.new(factures).call)["Facture_1-2026_1.pdf"]

    assert_includes texte(pdf_dupont), "1-2026/1"
    assert_not_includes texte(pdf_dupont), "1-2026/2"
  end

  test "une sélection vide produit une archive sans aucune entrée" do
    assert_empty entrées_de_l_archive(FacturesToZip.new(Facture.none).call)
  end

  private

    # Le texte d'un PDF Prawn, qui l'encode en hexadécimal : [<46616374757265>] TJ
    def texte(pdf)
      pdf.scan(/<([0-9a-f]+)>/).flatten.map { |hexa| [hexa].pack("H*") }.join
    end
end
