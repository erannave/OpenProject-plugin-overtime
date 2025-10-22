class OvertimeCalculationService
  attr_reader :user, :quota

  def initialize(user)
    @user = user
    @quota = UserOvertimeQuota.current_for_user(user)
  end

  def calculate
    return default_result unless quota

    {
      user: user,
      quota: quota,
      has_quota: true,
      summary: quota.overtime_summary
    }
  end

  def self.calculate_for_all_users
    results = []

    User.active.each do |user|
      service = new(user)
      result = service.calculate
      results << result if result[:has_quota]
    end

    results
  end

  def self.calculate_for_user(user)
    new(user).calculate
  end

  private

  def default_result
    {
      user: user,
      quota: nil,
      has_quota: false,
      summary: {
        total_overtime: 0,
        weeks_count: 0,
        average_weekly_hours: 0,
        weekly_quota: 0,
        start_date: nil,
        weeks_detail: {}
      }
    }
  end
end
