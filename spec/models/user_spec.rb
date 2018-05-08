# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:comments) }
  it { should have_many(:comments_in_thread) }
end
