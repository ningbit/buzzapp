class CreateBuzzs < ActiveRecord::Migration
  def change
    create_table :buzzs do |t|



      t.timestamps
    end
  end
end
