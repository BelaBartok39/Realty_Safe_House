class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.string :title
      t.text :description
      t.string :address
      t.integer :realtor_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
