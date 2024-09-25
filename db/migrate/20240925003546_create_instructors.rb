class CreateInstructors < ActiveRecord::Migration[7.2]
  def change
    create_table :instructors do |t|
      t.string :email, null: false, index: { unique: true }

      t.timestamps
    end

    add_index :students, :email, unique: true
  end
end
