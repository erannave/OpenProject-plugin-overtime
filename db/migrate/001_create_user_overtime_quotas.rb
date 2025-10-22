class CreateUserOvertimeQuotas < ActiveRecord::Migration[7.0]
  def change
    create_table :user_overtime_quotas do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.decimal :weekly_hours_quota, precision: 8, scale: 2, null: false, default: 40.0
      t.date :start_date, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :user_overtime_quotas, [:user_id, :start_date], unique: true
  end
end
