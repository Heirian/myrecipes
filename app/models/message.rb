class Message < ApplicationRecord
  validates :content, presence: true
  validade :chef_id, presence: true
  belongs_to :chef
end
