class ChangeSignupStatusToInteger < ActiveRecord::Migration[7.1] # Or your Rails version
  def change
    # Change the column type to integer.
    # USING CAST(status AS integer) attempts to convert existing string values (like "0") to integers.
    # Add a default value of 0 (pending) for safety.
    change_column :signups, :status, :integer, using: 'CAST(status AS integer)', default: 0
  end
end
