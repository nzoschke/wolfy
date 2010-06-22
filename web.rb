require 'sinatra'
require 'sinatra/base'
require 'sequel'

module Sinatra
  module Indexer
    def self.route_added(verb, path, block)
      uncompiled_paths << path unless uncompiled_paths.include?(path)
    end

    def uncompiled_paths
      @uncompiled_paths ||= []
    end
  end
  
  register Indexer
end

configure do
  DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://wolfy.db')

  DB.create_table :user do
    primary_key :id
    String      :username
    String      :password
  end unless DB.table_exists? :user
end

get '/' do
  index = "curl -I http://localhost:9292/<br />"
  index += uncompiled_paths.map { |p| "<a href=\"#{p}\">#{p}</a>" }.join("<br />")
end

get '/env' do
  ENV.map { |(k,v)| "#{k}=#{v}" }.join("<br />")
end

get '/200' do
  '200'
end

get '/404/:thunk' do
  'GET /404 to get a 404...'
end

get '/500' do
  halt 500
end

get '/debugging' do
  puts          "puts debugging"
  STDOUT.write  "STDOUT debugging\n"
  STDERR.write  "STDERR debugging\n"
  'Extra debugging info on STDOUT/STDERR'
end

get '/raise' do
  raise 'Throwing a RuntimeError...'
end
  
get '/cached' do
end

get '/auth' do
end

get '/db' do
  DB.tables.inspect
end

post '/thumb' do
end