require 'rubygems'
require 'spec'
require 'active_record'
require 'action_controller'

Dependencies.mechanism = :require

databases = YAML::load(IO.read(File.join(File.dirname(__FILE__), "db", "database.yml")))
ActiveRecord::Base.establish_connection(databases["test"])
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
load(File.join(File.dirname(__FILE__), "db", "schema.rb"))

module Rails
  class << self
    def root
      File.dirname(__FILE__)
    end
  end
end

require File.dirname(__FILE__) + '/../lib/action_presenter'
require 'app/models/article'
require 'app/presenters/article_presenter'