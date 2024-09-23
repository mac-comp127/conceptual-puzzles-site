require 'open3'

class GeneratePuzzleJob < ApplicationJob
  PUZZLE_DIR_ENV_KEY = 'conceptual_puzzles_generator_home'

  def run(attempt_id:)
    output = ""
    Attempt.transaction do
      attempt = Attempt.find(attempt_id)
      raise "Cannot generate attempt when state is #{attempt.state}" unless attempt.queued?

      Tempfile.create do |problem_file|
        Tempfile.create do |solution_file|
          puzzle_dir = Pathname.new(
            ENV[PUZZLE_DIR_ENV_KEY] || raise("Env var missing: #{PUZZLE_DIR_ENV_KEY}"))
          
          output += system_cmd(
            (puzzle_dir + "bin/puzzle").to_s,
            "gen", attempt.puzzle_type.name,
            "--html", problem_file.path,
            "--solution-html", solution_file.path
          )
          output += system_cmd(
            "git", "--git-dir", (puzzle_dir + ".git").to_s, "log", "-1"
          )

          if File.empty?(problem_file) || File.empty?(solution_file)
            raise "Puzzle generator did not produce output files"
          end

          attempt.problem_html = File.read(problem_file)
          attempt.solution_html = File.read(solution_file)
          attempt.generator_log = output
        end
      end

      attempt.state = AttemptState.available
      attempt.generate_lookup_code!
      attempt.save!

      destroy
    rescue => e
      raise unless attempt  # Failures get logged to attempt record only if available

      output += "\n#{e.inspect}\n#{e.backtrace.join("\n")}"
      attempt.state = AttemptState.generator_failed
      attempt.generator_log = output
      attempt.save!

      expire
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
