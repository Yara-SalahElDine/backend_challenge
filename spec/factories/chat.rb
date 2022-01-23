FactoryBot.define do
  factory :chat do
    name { Faker::App.name }
    after(:build) do |chat|
      application = FactoryBot.create(:application)
      chat.app_token = application.token
      chat.chat_number = 1
    end
  end
end