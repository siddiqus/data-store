require "csv"
class Tweet
  include Mongoid::Document

  field :userid, type: String
  field :tweetid, type: String
  field :textid, type: String
  field :target, type: String
  field :text, type: String
  field :sentiment, type: String
  field :confidence, type: String
  field :tg_sent, type: Hash  
  field :entities, type: Array

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << attribute_names
      all.each do |tw|
        csv << tw.attributes.values_at(*attribute_names)
      end
    end
  end
  
end
