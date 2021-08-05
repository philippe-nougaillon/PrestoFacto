class Blog < ApplicationRecord
    
    validates :titre, :corps, presence: true

    default_scope { order(Arel.sql('blogs.id DESC')) }

end
