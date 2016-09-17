class Contact < ActiveRecord::Base
  scope :last_name_alphabetical, -> { order(last_name: :asc) }
end
