# OpenProject Overtime Plugin Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-22

### Added
- Initial release of OpenProject Overtime Plugin
- Weekly quota management for users
- Configurable start date for overtime calculations
- Automatic overtime calculation based on tracked time vs. quota
- Admin interface for managing user quotas (CRUD operations)
- User dashboard showing overtime statistics and weekly breakdown
- CSV export functionality for overtime reports
- Multi-language support (English and German)
- Database migration for user_overtime_quotas table
- UserOvertimeQuota model with calculation logic
- OvertimeCalculationService for centralized overtime calculations
- Complete set of views with ERB templates
- Routes configuration
- Comprehensive documentation in README.md

### Features
- Week-by-week overtime breakdown
- Color-coded overtime display (red for positive, green for negative)
- Admin menu integration
- User account menu integration
- Active/inactive quota status
- Average weekly hours calculation
- Total overtime tracking from start date

[1.0.0]: https://github.com/openproject/openproject-overtime/releases/tag/v1.0.0
