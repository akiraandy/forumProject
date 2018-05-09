class AddModFlagToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :mod_flag, :boolean
  end
end
