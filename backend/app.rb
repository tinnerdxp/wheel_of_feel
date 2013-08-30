require 'bundler/setup'
require 'sinatra'
require 'json'

#TODO: If we want to improve this:
#1: Remove horrible @@ class variables and use persistence e.g. Mongo
#2. Make it a bit more RESTful - it's really just json over HTTP atm
#3. Improve the tests - they were just to make sure I didn't break stuff too bad during the 2 days
#4. Add some error handling
class WheelOfFeel < Sinatra::Base

  configure do
    set :bind, '10.215.92.52'
    set :port, 90
    @@results = {}
    @@current_act = ''
    @@current_phase = ''
    @@current_act_description = ''
    @@act_image = ''
    @@emotions = nil
    @@acts = {}
    enable :logging
  end

  before do
    response['Access-Control-Allow-Origin'] = '*'
    response['Access-Control-Allow-Headers'] = 'content-type'
    content_type 'application/json'
    @@emotions ||= {'love' => 0, 'joy' => 0, 'excitement' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'suprise' => 0, 'fear' => 0}
  end

  get '/*.jpg' do
    content_type 'image/jpeg'
  end

  get '/status' do
    {'status' => 'ok'}.to_json
  end

  get '/act' do
    {'act' => @@current_act, 'phase' => @@current_phase, 'description' => @@current_act_description,  'image' => @@act_image}.to_json
  end

  get '/acts' do
    @@acts.to_json
  end

  get '/delete' do
    @@results = {}
    @@current_act = ''
    @@current_phase = ''
    @@current_act_description = ''
    @@current_act_image = ''
    @@emotions = nil
  end

  post '/setemotions' do
    json_data = JSON.parse request.body.read
    @@emotions = json_data
  end

  post '/editorial' do
    json_data = JSON.parse request.body.read
    act = json_data['act']
    phase = json_data['phase']
    description = json_data['description']
    image = json_data['image']
    @@results[act] = {} unless @@results[act]
    @@results[act][phase] = {'love' => 0, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0} unless @@results[act][phase]
    @@current_act = act
    @@current_phase = phase
    @@current_act_description = description
    @@act_image = image
    @@acts[act] = {'description' => description, 'image' => image} unless @@acts[act]
    @@results.to_json
  end

  post '/vote' do
    json_data = JSON.parse request.body.read
    emotion = json_data['emotion']
    error = nil
    begin
      @@results[@@current_act][@@current_phase][emotion] += 1
    rescue => e
      error = {'error' => 'attempted to set invalid emotion for current act and phase'}.to_json
    end
    error || @@results.to_json
  end

  options '/*' do end #CORS - prefilighting

  get '/liveresults' do
    @@results.to_json
  end
end

WheelOfFeel.run! if __FILE__ == $0 #only run if invoked from command line - otherwise leave to Rack-Test
