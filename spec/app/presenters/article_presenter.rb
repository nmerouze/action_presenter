class ArticlePresenter < ActionPresenter::Base
  def title
    h @source.title
  end
  
  def body
    render :body
  end
end