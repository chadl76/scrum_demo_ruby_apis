require_relative 'nyt_api'
require 'figaro'

# Load Figaro
Figaro.application = Figaro::Application.new(
  environment: 'development',
  path: File.expand_path('../config/application.yml', __FILE__)
)
Figaro.load


# Use API
nyt_api = NYTAPI.new(
  :key => ENV['NYT_API_KEY'],
  :debug_enabled => true
)

full = nyt_api.get({
  :q => 'apple',
  :page => 2,
  :sort => 'oldest'
}, false)


File.open('data/full.json', 'w') do |f|
  json = JSON.pretty_generate(full)
  f.write(json)
end


trimmed = nyt_api.get({
  :q => 'apple',
  :page => 2,
  :sort => 'oldest'
})


File.open('data/trimmed.json', 'w') do |f|
  json = JSON.pretty_generate(trimmed)
  f.write(json)
end





