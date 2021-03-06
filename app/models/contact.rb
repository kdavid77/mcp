class Contact < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true, length: { maximum: 50 }
  validates :memo, length: { maximum: 50 }
end
