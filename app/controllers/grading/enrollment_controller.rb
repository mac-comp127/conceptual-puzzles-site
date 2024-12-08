require 'ostruct'

class Grading::EnrollmentController < Grading::BaseController
  def update
    Student.transaction do
      unprocessed_emails = perform_enrollment_actions(params[:enrollments]&.values)

      @possible_enrollments =
        (unprocessed_emails + emails_from_text)
          .map { |email| find_enrollment_options(email) }

      if @possible_enrollments.empty?
        redirect_to grading_cohort_students_path(cohort)
      end
    end
  end

private

  attr_reader :possible_enrollments
  helper_method :possible_enrollments

  def emails_from_text
    (params[:emails_as_text] || "")
      .split(/[\r\n]+|,/)
      .reject(&:blank?)
      .map(&:strip)
  end

  def perform_enrollment_actions(enrollments)
    unprocessed = []
    (enrollments || []).each do |enrollment|
      email = enrollment[:email]
      case enrollment[:action]
        when nil
          unprocessed << email
        when "ignore"
          # noop
        when "create"
          Student.create!(email:, cohort:)
        when /move_(.*)/
          Student.find($1).update!(cohort:)
      end
    end
    return unprocessed
  end

  def find_enrollment_options(email)
    begin
      parsed = Mail::Address.new(email)
    rescue Mail::Field::ParseError => e
      return OpenStruct.new(email:, status: :error, error: e.reason)
    end
    if parsed.domain.blank?
      return OpenStruct.new(email:, status: :error, error: "No domain name")
    end
    email = parsed.address.downcase  # use normalized email from here on

    if student = cohort.students.detect { |student| student.email.downcase == email }
      return OpenStruct.new(email:, status: :already_enrolled, student:)
    end

    OpenStruct.new(
      email:,
      name: parsed.name,
      status: :can_add,
      existing_accounts: find_candidate_accounts(email)
    )
  end

  def find_candidate_accounts(email)
    Student.includes(:cohort)
      .where(email: email)
      .select { |s| s.cohort.nil? || !s.cohort.ended? }
  end

end
