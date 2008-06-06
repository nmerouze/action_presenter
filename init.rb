Dependencies.load_paths << Rails.root + '/app/presenters'

config.after_initialize do
  Rails.plugins.each do |plugin|
    path = Rails.root + "/vendor/plugins/#{plugin.name}/app/presenters"
  
    if File.directory?(path)
      Dependencies.load_paths << path
      ActionPresenter.view_paths << path
    end
  end
end if defined? :Engines