# == Schema Information
#
# Table name: applications
#
#  id          :bigint           not null, primary key
#  name        :string(255)      not null
#  token       :string(255)      not null
#  chats_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Application < ApplicationRecord
  include Redis::Objects

  counter :chat_counter
  has_secure_token

  # Relations
  has_many :chats, foreign_key: 'app_token', primary_key: 'token'
  has_many :messages, foreign_key: 'app_token', primary_key: 'token'

  # Validations
  validates :name, :chats_count, presence: true

end
