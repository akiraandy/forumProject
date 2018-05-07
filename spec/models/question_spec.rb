require 'rails_helper'

RSpec.describe Question, type: :model do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
    it { should have_many(:commenters) }
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(30) }
end
