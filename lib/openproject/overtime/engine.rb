# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'active_support/dependencies'
require 'open_project/plugins'

module OpenProject
  module Overtime
    class Engine < ::Rails::Engine
      engine_name :openproject_overtime

      include OpenProject::Plugins::ActsAsOpEngine

      register(
        'openproject-overtime',
        author_url: 'https://github.com/openproject/openproject-overtime',
        bundled: false,
        requires_openproject: '>= 13.0.0'
      ) do
        menu :admin_menu,
             :overtime_settings,
             { controller: '/overtime/admin', action: 'index' },
             parent: :admin_general,
             caption: ->(*) { I18n.t('overtime.admin_menu_label') },
             icon: 'icon2 icon-time'

        menu :account_menu,
             :overtime,
             { controller: '/overtime/user_overtime', action: 'show' },
             caption: ->(*) { I18n.t('overtime.user_menu_label') },
             if: ->(*) { User.current.logged? },
             icon: 'icon2 icon-time'
      end

      config.before_configuration do |app|
        app.config.paths['db/migrate'].concat config.paths['db/migrate'].expanded
      end

      config.to_prepare do
        ::OpenProject::Overtime::Hooks
      end
    end
  end
end
