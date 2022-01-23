# == Schema Information
#
# Table name: messages
#
#  id             :bigint           not null, primary key
#  body           :text(65535)      not null
#  message_number :integer          not null
#  chat_number    :integer          not null
#  app_token      :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:chat_number) }
  it { should validate_presence_of(:message_number) }
  it { should validate_presence_of(:app_token) }
end
