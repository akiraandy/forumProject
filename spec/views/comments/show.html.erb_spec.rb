# frozen_string_literal: true

require "rails_helper"

describe "questions/show.html.erb" do
  before(:each) do
    @current_user = create(:user)
  end
  it "displays deleted comments correctly" do
    assign(:question, create(:question_with_deleted_comment))

    render

    expect(rendered).to have_content("[Deleted]")
  end

  it "displays flagged comments correctly" do
    assign(:question, create(:question_with_flagged_comment))

    render
    expect(rendered).to have_content("Content has been flagged")
  end

  it "displays deleted questions correctly" do
    assign(:question, create(:deleted_question))

    render

    expect(rendered).to have_content("[Deleted]")
  end

  it "displays flagged questions correctly" do
    assign(:question, create(:flagged_question))

    render

    expect(rendered).to have_content("Content has been flagged")
  end

  it "won't show mod flag option if the question is owned by current user" do
    @current_user = create(:user_with_question)
    assign(:question, @current_user.questions.first)

    render

    expect(rendered).to_not have_content("Flag question")
  end

  it "won't show mod flag option if the comment is owned by current user" do

  end
end
