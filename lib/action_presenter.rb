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
        file = "#{name}/#{view}"
        action_view = ActionView::Base.new([], {}, @controller)
        action_view.finder.view_paths = ActionPresenter.view_paths
        action_view.render_file(file, true, options.merge(@name => @source))
      end
  end
  
  module Helpers
    @@presenters = {}
    
    def present(records)
      presenters = []
      unless records.is_a? Array
        return_first = true 
        records = [records]
      end
      
      records.each do |record|
        @@presenters[record.to_s] = "#{record.class.name.classify}Presenter".constantize.new(@controller, record) unless @@presenters.has_key? record.to_s
        
        if block_given?
          yield @@presenters[record.to_s]
        else
          presenters << @@presenters[record.to_s]
          return presenters.first if return_first
        end
      end
      
      presenters
    end
    alias :p :present
    
    def source(record)
      record.source
    end
    alias :s :source
  end
end