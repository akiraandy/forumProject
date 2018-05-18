# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:questions) }
  it { should validate_length_of(:name).is_at_most(30) }
end
