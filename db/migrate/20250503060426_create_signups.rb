class CreateSignups < ActiveRecord::Migration[7.2]
  def change
    create_table :signups do |t|
      t.integer :user_id
      t.integer :property_id
      t.string :status
      t.string :license_front
      t.string :license_back
      t.string :selfie

      t.timestamps
    end
  end
end
