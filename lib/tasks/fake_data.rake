namespace :db do
  namespace :fake do

    def ensure_dev_env!
      raise "Fake data only allow in dev" unless Rails.env.development?
    end

    task students: :environment do
      ensure_dev_env!
      Student.transaction do
        10.times.map do
          Student.create!(
            email: FFaker::Internet.email,
            name: (FFaker::Name.name unless rand(4) == 0),
          )
        end
      end
    end

    task attempts: :environment do
      ensure_dev_env!
      Attempt.transaction do
        puzzle_types = PuzzleType.all.to_a
        students = Student.all.order(created_at: :desc).limit(50)
        50.times do
          student = students.sample

          student.attempts.where.not(state: AttemptState.graded)
            .update!(state: AttemptState.graded, score: AttemptScore.all.sample)

          attempt = student.attempts.create!(
            state: AttemptState.queued,
            puzzle_type: puzzle_types.sample,
          )
          attempt.generate_lookup_code!
          attempt.update!(
            state: AttemptState.available,
            problem_html: FFaker::Lorem.paragraph,
            solution_html: FFaker::Lorem.paragraph,
          )
        end
      end
    end

    task all: [:students, :attempts]

  end
end
