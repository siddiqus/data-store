class TweetsController < ApplicationController
#  before_filter :authenticate_user!, :validate_authorization!
  skip_authorization_check 

  autocomplete :tweet, :text
  
  def index
    @tweets = Tweet.all
    respond_to do |f|
      f.html
      f.csv {render text: @tweets.to_csv(col_sep: "|")}    
    end
  end

  def search
    #debugger
    if params[:search] != nil
      @tweets = Tweet.where(eval(params[:search]))
    end
    
  end

end 
