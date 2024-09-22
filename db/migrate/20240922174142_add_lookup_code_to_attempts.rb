class AddLookupCodeToAttempts < ActiveRecord::Migration[7.2]
  def change
    change_table :attempts do |t|
      t.string :lookup_code, index: { unique: true }
    end
  end
end
