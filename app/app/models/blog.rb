class Blog < ApplicationRecord

    default_scope { order(Arel.sql('blogs.id DESC')) }

end
