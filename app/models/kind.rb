class Kind < ApplicationRecord
  has_many :contacts, class_name: "Contact"
end
