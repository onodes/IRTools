#encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'arduino_ir_remote'
require './lib/aircon'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  configure do
    set :root, File.dirname(__FILE__) 
    enable :logging
    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end

  get '/' do
    haml :index
  end

  get '/aircon' do
    status = params[:status]
    begin
      aircon = Aircon.new
      aircon.send(status)
      @text = "エアコンの操作信号を送信しました。"
    rescue
      @text = "Arduinoの接続に問題があります。"
    end
    haml :done
  end

  get '/pi' do
    status = params[:status]
    begin
      if status == "dlna_restart"
        system("/etc/init.d/minidlna force-reload")
      end
      
      @text = "ラズベリーパイに操作をしました。"
    rescue
      @text = "ラズベリーパイの操作に問題があります。"
    end
    haml :done 
  end
end

