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
require 'rails_helper'

RSpec.describe Application, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:chats_count) }
end
