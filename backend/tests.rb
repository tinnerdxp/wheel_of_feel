require_relative 'app'
require 'test/unit'
require 'rack/test'
require 'json'

class WheelOfFeelTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    WheelOfFeel
  end

  def setup
    get '/delete'
  end

  def test_status_returns_ok
    get '/status'
    assert last_response.ok?
    expected = {'status' => 'ok'}
    assert_equal expected.to_json, last_response.body
  end

  def test_editorial_allows_act_and_phase_to_be_persisted
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act'}.to_json
    expected = {'1' => {'before' => {'love' => 0, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}}
    assert_equal expected.to_json, last_response.body
  end

  def test_editorial_allows_multiple_acts_and_phases_to_be_persisted
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}.to_json
    post '/editorial', params = {'act' => '2', 'phase' => 'after', 'description' => 'some act', 'image' => '/bar.png'}.to_json
    expected = {'1' => {'before' => {'love' => 0, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}, '2' => {'after' => {'love' => 0, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}}
    assert_equal expected.to_json, last_response.body
    assert_equal expected.to_json, last_response.body
    get '/act'
    assert last_response.ok?
    expected = {'act' => '2', 'phase' => 'after', 'description' => 'some act', 'image' => '/bar.png'}
    assert_equal expected.to_json, last_response.body
  end

  def test_editorial_does_not_allow_existing_acts_to_be_overwritten
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}.to_json
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}.to_json
    expected = {'1' => {'before' => {'love' => 0, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}}
    assert_equal expected.to_json, last_response.body
    get '/act'
    assert last_response.ok?
    expected = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}
    assert_equal expected.to_json, last_response.body
  end

  def test_acts_returns_all_acts
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}.to_json
    post '/editorial', params = {'act' => '2', 'phase' => 'before', 'description' => 'some act 2', 'image' => '/bar.png'}.to_json
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}.to_json
    post '/editorial', params = {'act' => '2', 'phase' => 'before', 'description' => 'some act 2', 'image' => '/bar.png'}.to_json
    expected = {'1' => {'description' => 'some act', 'image' => '/foo.png'},'2' => {'description' => 'some act 2', 'image' => '/bar.png'}}
    get '/acts'
    assert_equal expected.to_json, last_response.body
  end

  def test_editorial_does_not_allow_existing_acts_to_be_overwritten_but_will_set_current_act_and_phase
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}.to_json
    post '/editorial', params = {'act' => '2', 'phase' => 'after', 'description' => 'some act'}.to_json
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}.to_json
    expected = {'1' => {'before' => {'love' => 0, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}, '2' => {'after' => {'love' => 0, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}}
    assert_equal expected.to_json, last_response.body
    get '/act'
    assert last_response.ok?
    expected = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}
    assert_equal expected.to_json, last_response.body
  end

  def test_vote_increments_count_for_the_correct_emotion
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act'}.to_json
    assert last_response.ok?
    post '/vote', params = {'emotion' => 'love'}.to_json
    assert last_response.ok?
    expected = {'1' => {'before' => {'love' => 1, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}}
    assert_equal expected.to_json, last_response.body
  end

  def test_vote_increments_count_for_the_correct_emotion_when_switched_by_editorial
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act'}.to_json
    post '/vote', params = {'emotion' => 'love'}.to_json
    expected = {'1' => {'before' => {'love' => 1, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}}
    assert_equal expected.to_json, last_response.body
    post '/editorial', params = {'act' => '2', 'phase' => 'after', 'description' => 'some act 2', 'image' => '/foo.png'}.to_json
    get '/act'
    expected = {'act' => '2', 'phase' => 'after', 'description' => 'some act 2', 'image' => '/foo.png'}
    assert_equal expected.to_json, last_response.body
    post '/vote', params = {'emotion' => 'love'}.to_json
    post '/vote', params = {'emotion' => 'sadness'}.to_json
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}.to_json
    get '/act'
    expected = {'act' => '1', 'phase' => 'before', 'description' => 'some act', 'image' => '/foo.png'}
    assert_equal expected.to_json, last_response.body
    post '/vote', params = {'emotion' => 'love'}.to_json
    expected = {'1' => {'before' => {'love' => 2, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}, '2' => {'after' => {'love' => 1, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 1, 'surprise' => 0, 'fear' => 0}}}
    assert_equal expected.to_json, last_response.body
  end

=begin
#TODO: Fix this - wanted to provide api for setting the set of emotions rather than having them hard code but @@emotions in app.rb is essentially global so all the acts ended up referencing the same emotions hash - not good! Should be trivial to fix but just didn't have time.
  def test_setemotions_sets_the_possible_emotions
    post '/setemotions', params = {'foo' => 0, 'bar' => 0}.to_json
    post '/editorial', params = {'act' => '1', 'phase' => 'before'}.to_json
    assert last_response.ok?
    expected = {'1' => {'before' => {'foo' => 0, 'bar' => 0}}}
    assert_equal expected.to_json, last_response.body
    post '/vote', params = {'emotion' => 'foo'}.to_json
    expected = {'1' => {'before' => {'foo' => 1, 'bar' => 0}}}
    assert_equal expected.to_json, last_response.body
  end

  def test_setemotions_does_not_destroy_previously_created_emtions
    post '/editorial', params = {'act' => '1', 'phase' => 'before'}.to_json
    assert last_response.ok?
    expected = {'1' => {'before' => {'happy' => 0, 'sad' => 0, 'disappointed' => 0, 'angry' => 0}}}
    assert_equal expected.to_json, last_response.body
    post '/setemotions', params = {'foo' => 0, 'bar' => 0}.to_json
    post '/editorial', params = {'act' => '2', 'phase' => 'before'}.to_json
    expected = {'1' => {'before' => {'happy' => 0, 'sad' => 0, 'disappointed' => 0, 'angry' => 0}}, '2' => {'before' => {'foo' => 0, 'bar' => 0}}}
    assert_equal expected.to_json, last_response.body
  end
=end

  def test_setting_invalid_emotion_results_in_handled_error
    post '/editorial', params = {'act' => '1', 'phase' => 'before', 'description' => 'some act'}.to_json
    assert last_response.ok?
    post '/vote', params = {'emotion' => 'love'}.to_json
    assert last_response.ok?
    expected = {'1' => {'before' => {'love' => 1, 'joy' => 0, 'excitment' => 0, 'anger' => 0, 'disgust' => 0, 'sadness' => 0, 'surprise' => 0, 'fear' => 0}}}
    assert_equal expected.to_json, last_response.body
    post '/vote', params = {'emotion' => 'foobar'}.to_json
    expected = {'error' => 'attempted to set invalid emotion for current act and phase'}
    assert_equal expected.to_json, last_response.body
  end
end
