class Paiement < ApplicationRecord
  belongs_to :compte

  has_one :organisation, through: :compte

  validates :date, presence: true

  validates :montant, numericality: { greater_than_or_equal_to: 0.01 }

  # self.per_page = 10

  def self.modes
     %w{Virement CB Chèque Espèces Autre}
  end

  def self.banques
    %w{AXA BNP\ Paribas Banque\ Populaire CIC Caisse\ d'épargne Crédit\ Agricole Crédit\ Mutuel La\ Banque\ POSTALE Société\ Générale Autre}
  end

end
