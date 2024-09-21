require 'Open3'

class GeneratePuzzleJob < ApplicationJob
  PUZZLE_DIR_ENV_KEY = 'conceptual_puzzles_generator_home'

  def run(attempt_id:)
    Attempt.transaction do
      attempt = Attempt.find(attempt_id)
      raise "Cannot generate attempt when state is #{attempt.state}" unless attempt.queued?

      Tempfile.create do |problem_file|
        Tempfile.create do |solution_file|
          puzzle_dir = Pathname.new(
            ENV[PUZZLE_DIR_ENV_KEY] || raise("Env var missing: #{PUZZLE_DIR_ENV_KEY}"))
          
          output = system_cmd(
            (puzzle_dir + "bin/puzzle").to_s,
            "gen", attempt.puzzle_type.name,
            "--html", problem_file.path,
            "--solution-html", solution_file.path
          )
          output += system_cmd(
            "git", "--git-dir", (puzzle_dir + ".git").to_s, "log", "-1"
          )

          attempt.problem_html = File.read(problem_file)
          attempt.solution_html = File.read(solution_file)
          attempt.generator_log = output
        end
      end

      attempt.state = AttemptState.available
      attempt.save!
    end
  end

  def system_cmd(*cmd_line)
    output, status = Open3.capture2e(*cmd_line)
    p output
    unless status.success?
      raise "Command failed: #{cmd_line.inspect}\n\n#{output}\n"
    end
    output
  end

  def log_level(elapsed)
    :info
  end
end
