module Overtime
  class AdminController < ApplicationController
    before_action :require_admin
    before_action :set_user, only: [:edit, :update, :destroy]
    before_action :set_quota, only: [:edit, :update, :destroy]

    layout "admin"

    def index
      @users = User.active.order(:lastname, :firstname)
      @quotas = UserOvertimeQuota.active.includes(:user).index_by(&:user_id)
      @overtime_data = OvertimeCalculationService.calculate_for_all_users
    end

    def new
      @user = User.find(params[:user_id]) if params[:user_id]
      @quota = UserOvertimeQuota.new(
        user: @user,
        start_date: Date.current,
        weekly_hours_quota: 40.0
      )
    end

    def create
      @quota = UserOvertimeQuota.new(quota_params)

      if @quota.save
        flash[:notice] = I18n.t("overtime.quota_created")
        redirect_to action: :index
      else
        @user = @quota.user
        flash[:error] = @quota.errors.full_messages.join(", ")
        render :new
      end
    end

    def edit
    end

    def update
      if @quota.update(quota_params)
        flash[:notice] = I18n.t("overtime.quota_updated")
        redirect_to action: :index
      else
        flash[:error] = @quota.errors.full_messages.join(", ")
        render :edit
      end
    end

    def destroy
      @quota.destroy
      flash[:notice] = I18n.t("overtime.quota_deleted")
      redirect_to action: :index
    end

    private

    def set_user
      @user = User.find(params[:user_id] || params[:id])
    end

    def set_quota
      @quota = UserOvertimeQuota.find(params[:id])
    end

    def quota_params
      params.require(:user_overtime_quota).permit(
        :user_id,
        :weekly_hours_quota,
        :start_date,
        :active
      )
    end
  end
end
