FactoryBot.define do
  factory :message do
    body { Faker::App.name }
    after(:build) do |message|
      chat = FactoryBot.create(:chat)
      message.app_token = chat.app_token
      message.chat_number = 1
      message.message_number = 1
    end
  end
end