# == Schema Information
#
# Table name: chats
#
#  id             :bigint           not null, primary key
#  name           :string(255)      not null
#  chat_number    :integer          not null
#  messages_count :integer          default(0), not null
#  app_token      :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Chat, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:chat_number) }
  it { should validate_presence_of(:messages_count) }
  it { should validate_presence_of(:app_token) }
end
