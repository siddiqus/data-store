class HomeController < ApplicationController
#  before_filter :authenticate_user!, :validate_authorization!
  skip_authorization_check 
  before_action :allow_iframe

  def allow_iframe
    response.headers.delete('X-Frame-Options')

  end

  def index
    
  end

  def tweets
    @tweets = Tweet.all
    respond_to do |f|
      f.html
      f.csv {render text: @tweets.to_csv(col_sep: "|")}    
    end
  end

  def search_tweets
    qstr = "/^" + params[:query] + "/i"
    results = Tweet.where(text: eval(qstr))
  end

end
