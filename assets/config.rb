# Require any additional compass plugins here.

# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "css"
sass_dir = "sass"
images_dir = "img"
fonts_dir = "fonts"
sprite_load_path = ["assets/sprite", "sprite"]
generated_images_dir = "img/sprite"
javascripts_dir = "js"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
output_style = :compact

# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true

# Import paths
add_import_path "../../zuul/assets/sass"

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false

# Make font size math accurate to 5 decimal places
Sass::Script::Number::PRECISION = 100000.0

#Override options if we compile in development mode (compass compile -e development)
if environment == :development
  output_style = :expanded #Human readable CSS
  sass_options = { :debug_info => true } # Set to true for debug info so we can use FireSass
end

if environment == :production
  output_style = :compressed 
  sass_options = { :debug_info => false } # Set to true for debug info so we can use FireSass
end

# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
