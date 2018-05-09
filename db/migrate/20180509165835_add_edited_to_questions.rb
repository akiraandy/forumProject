class AddEditedToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :edited, :boolean
  end
end
