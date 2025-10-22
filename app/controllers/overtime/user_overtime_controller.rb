module Overtime
  class UserOvertimeController < ApplicationController
    before_action :require_login

    def show
      @user = User.current
      @result = OvertimeCalculationService.calculate_for_user(@user)
      @quota = @result[:quota]
      @summary = @result[:summary]
      @has_quota = @result[:has_quota]
    end

    def export
      @user = User.current
      @result = OvertimeCalculationService.calculate_for_user(@user)

      respond_to do |format|
        format.csv do
          send_data generate_csv(@result),
                    filename: "overtime_report_#{@user.login}_#{Date.current}.csv",
                    type: "text/csv"
        end
      end
    end

    private

    def generate_csv(result)
      require "csv"

      CSV.generate do |csv|
        csv << ["User", "Week Starting", "Total Hours", "Quota", "Overtime"]

        if result[:has_quota] && result[:summary][:weeks_detail]
          result[:summary][:weeks_detail].each do |week_start, data|
            csv << [
              result[:user].name,
              week_start.strftime("%Y-%m-%d"),
              data[:total_hours].round(2),
              data[:quota].round(2),
              data[:overtime].round(2)
            ]
          end

          csv << []
          csv << ["Total Overtime", "", "", "", result[:summary][:total_overtime].round(2)]
        end
      end
    end
  end
end
