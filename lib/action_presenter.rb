module ActionPresenter
  @@view_paths = [Rails.root + '/app/presenters']
  mattr_accessor :view_paths
  
  class Base
    ActionView::Helpers.constants.each do |c|
      mod = ActionView::Helpers.const_get(c)
      include mod unless mod.is_a? Class
    end
    
    include ActionController::UrlWriter # named routes
    
    attr_reader :controller, :source, :name

    def initialize(controller, record)
      @controller, @source = controller, record
      @name = record.class.name.underscore.to_sym
    end
    
    protected
    
      def render(view, options = {})
        file = "#{name}/_#{view}"
        action_view = ActionView::Base.new([], {}, @controller)
        action_view.finder.view_paths = ActionPresenter.view_paths
        action_view.render_file(file, true, options.merge(@name => @source))
      end
  end
  
  module Helpers
    @@presenters = {}
    
    def present(record, name = nil)
      name = record.class.name if name.nil?
      @@presenters[name.underscore.to_sym] ||= "#{name.classify}Presenter".constantize.new(@controller, record)
    end

    alias :p :present
  end
end

ActionView::Base.__send__ :include, ActionPresenter::Helpers