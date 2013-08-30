#Wheel of feel - ITV's Innovations day project 3.

Allows viewers to "vote" on "acts" defined by the Editorial Team.

Backend: Matt Robbins. Sinatra webservice exposing RESTFUL interface. Not persisting any data.

Frontend: Krzysztof Pastwa, Nicholas Goward. Static HTML with Ajax client. Uses jQuery, jQueryTouch, HTML Boilerplate and Compass.

Wheel widget: Nicholas Goward - HTML, CSS3



##Installation

###To install the sinatra service:

####pre-reqs:

* Ruby 1.9
* RubyGems
* Bundler Gem

Run  `bundle install` to install the gems, then run `ruby app.rb` to run the app, run `ruby tests.rb` to run the tests - these use Rack-Test so don't need the server to be running.

