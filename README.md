# OpenProject Overtime Plugin

A comprehensive OpenProject plugin that extends the built-in time tracking feature to allow setting weekly quotas for each user and calculating and displaying total overtime based on the difference between the quota and actual tracked time.

## Features

- **Weekly Quota Management**: Set individual weekly working hour quotas for each user
- **Start Date Configuration**: Define when overtime calculation should begin for each user
- **Automatic Overtime Calculation**: Calculate overtime automatically based on tracked time vs. quota
- **Admin Interface**: Comprehensive admin panel to manage user quotas
- **User Dashboard**: Dedicated page for users to view their overtime statistics
- **Weekly Breakdown**: Detailed week-by-week view of hours worked and overtime
- **CSV Export**: Export overtime data to CSV format for further analysis
- **Multi-language Support**: Includes English and German translations

## Requirements

- OpenProject 13.x or later (tested with latest version)
- Ruby on Rails 7.0+
- PostgreSQL or MySQL database

## Installation

### Method 1: Manual Installation (Development)

1. Clone or copy this plugin into your OpenProject plugins directory:

```bash
cd /path/to/openproject
mkdir -p plugins
cd plugins
git clone <this-repository> openproject-overtime
```

2. Add the plugin to your `Gemfile.plugins`:

```ruby
gem "openproject-overtime", path: "plugins/openproject-overtime"
```

3. Install dependencies and run migrations:

```bash
bundle install
bundle exec rake db:migrate
```

4. Restart your OpenProject instance:

```bash
# For development
bundle exec rails server

# For production (passenger/systemd)
sudo systemctl restart openproject
```

### Method 2: Production Installation (Package)

1. Copy the plugin to your OpenProject installation:

```bash
# For packaged installation
sudo cp -r openproject-overtime /opt/openproject/vendor/bundle/ruby/*/bundler/gems/
```

2. Add to `Gemfile.plugins` in your OpenProject directory:

```ruby
gem "openproject-overtime", path: "/path/to/openproject-overtime"
```

3. Run migrations:

```bash
cd /opt/openproject
sudo openproject run bundle exec rake db:migrate
```

4. Restart OpenProject:

```bash
sudo systemctl restart openproject
```

## Configuration

### Setting Up User Quotas

1. Log in as an administrator
2. Navigate to **Administration** → **Overtime Settings**
3. Click **New Quota** to create a quota for a user
4. Fill in the form:
   - **User**: Select the user
   - **Weekly Hours Quota**: Enter expected weekly hours (e.g., 40)
   - **Start Date**: Choose when tracking should begin
   - **Active**: Check to activate the quota
5. Click **Save**

### Managing Quotas

From the Overtime Settings page, you can:
- View all configured quotas
- See real-time overtime calculations
- Edit existing quotas
- Delete quotas
- View all users and their quota status

## Usage

### For Users

1. Click on your **avatar** in the top right
2. Select **My Overtime** from the account menu
3. View your overtime statistics:
   - Weekly quota
   - Start date
   - Total weeks tracked
   - Average weekly hours
   - **Total overtime** (highlighted in red if positive, green if negative)
   - Weekly breakdown table

### Exporting Data

Users can export their overtime data:
1. Go to **My Overtime**
2. Click **Export to CSV**
3. The CSV file includes:
   - Week-by-week breakdown
   - Total hours per week
   - Quota
   - Overtime per week
   - Total overtime summary

## How Overtime is Calculated

The plugin calculates overtime using the following logic:

1. **Weekly Basis**: Time entries are grouped by week (Monday to Sunday)
2. **Quota Comparison**: For each week, total hours are compared against the weekly quota
3. **Overtime Calculation**:
   - Overtime = Total Hours - Weekly Quota
   - Positive values indicate extra hours worked
   - Negative values indicate hours under quota
4. **Total Overtime**: Sum of all weekly overtime since the start date

### Example

User quota: 40 hours/week, Start date: January 1, 2025

| Week Starting | Hours Worked | Quota | Overtime |
|--------------|--------------|-------|----------|
| Jan 1, 2025  | 45.0         | 40.0  | +5.0     |
| Jan 8, 2025  | 38.5         | 40.0  | -1.5     |
| Jan 15, 2025 | 42.0         | 40.0  | +2.0     |
| **Total**    | **125.5**    | **120.0** | **+5.5** |

## Database Schema

The plugin adds one main table:

### `user_overtime_quotas`

| Column              | Type    | Description                           |
|--------------------|---------|---------------------------------------|
| id                 | integer | Primary key                           |
| user_id            | integer | Foreign key to users table            |
| weekly_hours_quota | decimal | Weekly working hours quota            |
| start_date         | date    | When tracking begins                  |
| active             | boolean | Whether quota is active               |
| created_at         | datetime| Record creation timestamp             |
| updated_at         | datetime| Record update timestamp               |

## API and Services

### OvertimeCalculationService

Main service for calculating overtime:

```ruby
# Calculate for a specific user
result = OvertimeCalculationService.calculate_for_user(user)

# Calculate for all users
results = OvertimeCalculationService.calculate_for_all_users
```

### UserOvertimeQuota Model

```ruby
# Get current quota for a user
quota = UserOvertimeQuota.current_for_user(user)

# Calculate total overtime
total = quota.total_overtime

# Get detailed summary
summary = quota.overtime_summary
```

## Development

### Running Tests

```bash
bundle exec rake spec
```

### Code Structure

```
openproject-overtime/
├── app/
│   ├── controllers/
│   │   └── overtime/
│   │       ├── admin_controller.rb
│   │       └── user_overtime_controller.rb
│   ├── models/
│   │   └── user_overtime_quota.rb
│   ├── services/
│   │   └── overtime_calculation_service.rb
│   └── views/
│       └── overtime/
│           ├── admin/
│           └── user_overtime/
├── config/
│   ├── locales/
│   │   ├── en.yml
│   │   └── de.yml
│   └── routes.rb
├── db/
│   └── migrate/
│       └── 001_create_user_overtime_quotas.rb
├── lib/
│   ├── openproject-overtime.rb
│   └── openproject/
│       └── overtime/
│           ├── engine.rb
│           └── hooks.rb
├── openproject-overtime.gemspec
└── README.md
```

## Troubleshooting

### Plugin not appearing in menu

1. Ensure migrations have run: `bundle exec rake db:migrate`
2. Restart the OpenProject server
3. Clear browser cache
4. Check that you're logged in as an admin (for admin menu)

### Overtime calculations seem incorrect

1. Verify the start date is correct
2. Check that time entries have the correct `spent_on` dates
3. Ensure weekly quota is set correctly
4. Remember: weeks start on Monday

### Permission errors

The plugin requires:
- Admin permissions to access Overtime Settings
- Users must be logged in to view their overtime

## License

GPLv3 - See OpenProject licensing

## Support

For issues and feature requests, please use the GitHub issue tracker.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Changelog

### Version 1.0.0
- Initial release
- Weekly quota management
- Overtime calculation
- Admin interface
- User dashboard
- CSV export
- English and German translations

## Roadmap

Future enhancements may include:
- Monthly and yearly overtime views
- Overtime approval workflow
- Email notifications for excessive overtime
- Integration with holiday/absence tracking
- Customizable overtime policies (e.g., different quotas per day)
- REST API endpoints
- Dashboard widgets
- Graphical charts and visualizations

## Credits

Developed for OpenProject community
