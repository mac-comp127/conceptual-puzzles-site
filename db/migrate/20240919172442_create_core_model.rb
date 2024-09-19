class CreateCoreModel < ActiveRecord::Migration[7.2]
  def change
    create_table :puzzle_types do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description, null: false
      t.boolean :enabled, default: false, null: false

      t.timestamps
    end

    create_table :students do |t|
      t.string :email, null: false

      t.timestamps
    end

    create_enum :attempt_state, %w(queued available submitted graded)
    create_enum :attempt_score, %w(no_credit half_credit full_credit)

    create_table :attempts do |t|
      t.belongs_to :student, null: false, foreign_key: true
      t.belongs_to :puzzle_type, null: false, foreign_key: true
      t.enum :state, enum_type: "attempt_state", default: "queued", null: false
      t.text :content
      t.enum :score, enum_type: "attempt_score"

      t.timestamps
    end
  end
end
