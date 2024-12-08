class Cohort < ApplicationRecord
  has_many :students
  belongs_to :instructor

  has_many :cohort_puzzle_types
  has_many :puzzle_types, -> { order(:created_at) }, through: :cohort_puzzle_types

  validates_presence_of :name, :start_date, :end_date, :instructor_id
  validates_comparison_of :end_date, greater_than: :start_date, message: "must come after start date"

  def name_and_instructor
    "#{name} - #{instructor&.username || "???"}"
  end

  def official_current_time
    @official_current_time ||= time_zone.now
  end

  def start_time
    start_date.in_time_zone(time_zone)
  end

  def end_time
    end_date.in_time_zone(time_zone) + 1.day  # ends at midnight the _next_ day, not midnight on the end date
  end

  def started?
    official_current_time >= start_time
  end

  def ended?
    official_current_time > end_time
  end

  def in_session?
    started? && !ended?
  end

private

  # Could be stored per cohort if, heaven forbid, this ever goes beyond Macalester
  def time_zone
    ActiveSupport::TimeZone['US/Central']
  end
end
