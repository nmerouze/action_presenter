require File.dirname(__FILE__) + '/spec_helper'

module BeforeSpec
  def load_env
    @controller = nil
    @article = Article.create(:title => 'Foobar', :body => 'Hello World!')
    @presenter = ArticlePresenter.new(@controller, @article)
  end
end

describe ActionPresenter::Helpers do
  
  include BeforeSpec
  include ActionPresenter::Helpers
  
  before { load_env }
  
  describe "present()" do

    describe "without block" do
      it "with just one record should return a presenter" do
        present(@article).should be_an_instance_of(ArticlePresenter)
      end

      it "with more than one record should return an array of presenters" do
        pending
      end
    end

    describe "with a block" do
      it "should execute the code inside the block" do
        pending
      end
    end
    
    it "should not re-instanciate the presenter to each call" do
      present(@article).should_not == present(Article.create)
      present(@article).should == present(@article)
    end

  end

  describe "source()" do

    it "should return an AR object" do
      source(@presenter).should == @article
    end
    
  end
  
end

describe ArticlePresenter do
  
  include BeforeSpec
  
  before { load_env }
  
  it "should have a source" do
    @presenter.source.should == @article
  end
  
  it "should have a controller" do
    @presenter.controller.should == @controller
  end
  
  it "should have a name" do
    @presenter.name.should == :article
  end
  
  it "should be able to render a existing file from a method" do
    lambda {
      @presenter.body
    }.should_not raise_error(ActionView::MissingTemplate)
  end
  
end