# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.compile = true
Rails.application.config.assets.precompile =  ['*.js', '*.css', '*.css.erb', '*.png', '*.jpg']
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( foundation-social-web-icons.png )
Rails.application.config.assets.precompile += %w( foundation-icons.eot )
Rails.application.config.assets.precompile += %w( foundation-icons.woff )
Rails.application.config.assets.precompile += %w( foundation-icons.ttf )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
