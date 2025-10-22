# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'openproject/overtime/version'

Gem::Specification.new do |s|
  s.name        = "openproject-overtime"
  s.version     = OpenProject::Overtime::VERSION
  s.authors     = "OpenProject GmbH"
  s.email       = "info@openproject.org"
  s.homepage    = "https://github.com/openproject/openproject-overtime"
  s.summary     = "OpenProject Overtime Plugin"
  s.description = "A plugin to track user overtime based on weekly quotas and start dates"
  s.license     = "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)
end
