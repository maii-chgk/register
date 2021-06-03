Rails.application.config.assets.configure do |env|
  env.export_concurrent = false
end

Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
