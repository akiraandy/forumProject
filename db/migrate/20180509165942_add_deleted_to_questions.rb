class AddDeletedToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :deleted, :boolean
  end
end
