class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.string :name, null: false
      t.integer :chat_number, null: false
      t.integer :messages_count, default: 0, null: false
      t.string :app_token, null: false

      t.timestamps
    end

    add_index :chats, [:app_token, :chat_number], unique: true
  end
end
