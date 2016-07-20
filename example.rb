require_relative 'nyt_api'
require_relative 'env'



nyt_api = NYTAPI.new(:key => NYT_API_KEY, :debug_enabled => true)

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





