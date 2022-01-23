class CreateMessageWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'create_message'

  def perform(app_token, chat_number, message_number, body)
    Message.create(body: body, app_token: app_token, chat_number: chat_number, message_number: message_number)
  end
end
