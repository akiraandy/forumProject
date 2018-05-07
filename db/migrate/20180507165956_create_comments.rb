class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true
      t.boolean :edited
      t.boolean :deleted
      t.boolean :mod_flag

      t.timestamps
    end
  end
end
