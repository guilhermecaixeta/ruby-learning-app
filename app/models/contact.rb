class Contact < ApplicationRecord
  belongs_to :kind
  has_one :address, class_name: "Address", dependent: :destroy
  has_many :phones, class_name: "Phone", inverse_of: :contact, dependent: :destroy

  accepts_nested_attributes_for :address, allow_destroy: true
  accepts_nested_attributes_for :phones, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :email, presence: true
end
