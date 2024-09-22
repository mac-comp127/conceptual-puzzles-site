class AddErrorToAttemptStates < ActiveRecord::Migration[7.2]
  def change
    add_enum_value :attempt_state, "generator_failed"
  end
end
