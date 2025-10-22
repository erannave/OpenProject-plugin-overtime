class UserOvertimeQuota < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :weekly_hours_quota, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :user_id, uniqueness: { scope: :start_date }

  scope :active, -> { where(active: true) }
  scope :for_user, ->(user) { where(user_id: user.id) }
  scope :current, -> { where("start_date <= ?", Date.current).order(start_date: :desc) }

  # Get the current active quota for a user
  def self.current_for_user(user)
    for_user(user).active.current.first
  end

  # Calculate overtime for a specific period
  def calculate_overtime(from_date, to_date)
    # Get all time entries for this user in the period
    time_entries = TimeEntry.where(user_id: user_id)
                            .where("spent_on >= ? AND spent_on <= ?", from_date, to_date)

    # Group by week and calculate overtime
    weekly_overtime = {}
    time_entries.group_by { |entry| entry.spent_on.beginning_of_week }.each do |week_start, entries|
      total_hours = entries.sum(&:hours)
      overtime = total_hours - weekly_hours_quota
      weekly_overtime[week_start] = {
        total_hours: total_hours,
        quota: weekly_hours_quota,
        overtime: overtime
      }
    end

    weekly_overtime
  end

  # Calculate total overtime from start_date to now
  def total_overtime
    return 0 if start_date > Date.current

    calculate_overtime(start_date, Date.current)
      .values
      .sum { |week| week[:overtime] }
  end

  # Get overtime summary
  def overtime_summary
    weeks_data = calculate_overtime(start_date, Date.current)
    total = weeks_data.values.sum { |week| week[:overtime] }

    {
      total_overtime: total,
      weeks_count: weeks_data.count,
      average_weekly_hours: weeks_data.values.sum { |week| week[:total_hours] } / [weeks_data.count, 1].max,
      weekly_quota: weekly_hours_quota,
      start_date: start_date,
      weeks_detail: weeks_data
    }
  end
end
