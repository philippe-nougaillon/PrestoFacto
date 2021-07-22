class AddSlugToOrganisation < ActiveRecord::Migration[6.1]
  def change
    add_column :organisations, :slug, :string
    add_index  :organisations, :slug
  end
  Organisation.find_each(&:save)
end
