class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body, null: false
      t.integer :message_number, null: false
      t.integer :chat_number, null: false
      t.string :app_token, null: false

      t.timestamps
    end

    add_index :messages, [:app_token, :chat_number, :message_number], unique: true
  end
end
