# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = "openproject-overtime"
  s.version     = "1.0.0"
  s.authors     = "OpenProject Plugin Developer"
  s.email       = "plugin@openproject.com"
  s.summary     = "OpenProject Overtime Plugin"
  s.description = "A plugin to track user overtime based on weekly quotas"
  s.license     = "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*", "README.md"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 7.0"
end
