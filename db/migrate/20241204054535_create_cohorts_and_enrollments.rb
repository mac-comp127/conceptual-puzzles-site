class CreateCohortsAndEnrollments < ActiveRecord::Migration[7.2]
  def change
    create_table :cohorts do |t|
      t.text :name, null: false
      t.date :start_date
      t.date :end_date
      t.belongs_to :instructor, null: false, foreign_key: true, index: true
      t.timestamps
    end

    add_reference :students, :cohort, index: true

    # Student emails are no longer unique
    remove_index :students, column: :email, name: "index_students_on_email", unique: true
    add_index :students, :email
  end
end
