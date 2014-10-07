class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.belongs_to :topic
      t.string :title, :null => false
      t.string :answer
      t.string :author
      t.string :choice_a
      t.string :choice_b
      t.string :choice_c
      t.string :choice_d
      t.string :choice_e
      t.integer :points

      t.timestamps
    end
  end
end
