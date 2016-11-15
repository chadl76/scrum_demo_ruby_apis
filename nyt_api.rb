require 'httparty'
require 'uri'


class NYTAPI
  END_POINT = 'http://api.nytimes.com/svc/search/v2/articlesearch.json?'


  def initialize(options={})
    @key = options[:key]
    @debug_enabled = options[:debug_enabled].nil? ? options[:debug_enabled] : true
  end


  def get(params, trim=true)
    debug('')
    debug('Building URL')
    params = params.map { |k, v| [k, v.to_s] }.to_h
    url = build_url(params)
    debug("Requesting data from: #{url}")
    response = HTTParty.get(url)
    debug('Parsing response body to JSON')
    response = JSON.parse(response.body)
    debug('Got data, want some data?')
    trim_or_full(response, trim)
  end



  private
  def build_url(params)
    query_string = build_query_string(params)
    query_string += query_string.chars.last == '?' ? '' : '&'
    query_string += "api-key=#{@key}"
    "#{END_POINT}#{query_string}"
  end


  def build_query_string(params)
    params.map do |key, value|
      value = URI.encode(value)
      "#{key}=#{value}"
    end.join("&")
  end


  def extract_docs(response)
    res = response['response']
    if res.nil?
      {}
    else
      res['docs'].map do |doc|
        {
          :url => doc['web_url'],
          :lead => doc['lead_paragraph'],
          :abstract => doc['abstract'],
          :page => doc['print_page'],
          :source => doc['source'],
          :headline => doc['headline'],
          :keywords => doc['keywords'],
          :date => doc['pub_date'],
          :type => doc['document_type']
        }
      end
    end
  end


  def debug(message)
    puts message if @debug_enabled
  end


  def trim_or_full(response, trim)
    if trim
      debug('Trimming and returning response')
      extract_docs(response)
    else
      debug('Returning response')
      response
    end
  end
end













