class AddAlmostToAttemptScore < ActiveRecord::Migration[7.2]
  def up
    execute "ALTER TYPE attempt_score ADD VALUE IF NOT EXISTS 'almost' BEFORE 'full_credit'"
  end
end
