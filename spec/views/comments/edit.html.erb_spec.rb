# frozen_string_literal: true

require "rails_helper"

describe "comments/edit.html.erb" do
  it "displays deleted comments correctly" do
    assign(:comment, create(:deleted_comment))

    render

    expect(rendered).to have_content("commentTestBody" * 5)
  end

  it "displays flagged comments correctly" do
    assign(:comment, create(:flagged_comment))

    render

    expect(rendered).to have_content("commentTestBody" * 5)
  end
end
