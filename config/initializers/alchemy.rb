require_relative '../../lib/alchemyapi'

ALCHEMY = AlchemyAPI.new()


def sentiment(text)
  ALCHEMY.sentiment('text', text)
end

def targeted_sentiment (text, target)
  ALCHEMY.sentiment_targeted("text", text,target)  
end

def extract_entities (text)
  ALCHEMY.entities('text', text, { 'sentiment'=>1 })
end

def extract_keywords (text)
 ALCHEMY.keywords('text', text, { 'sentiment' => 1 })
end

def extract_relations(text)
  ALCHEMY.relations('text', text, {'sentiment' => 1})
end
