require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module B2cshop
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Rails 5中在生产环境下autoload_paths并不会自动加载，需要下面的配置重新启用
    config.enable_dependency_loading = true
    config.autoload_paths += %W[#{Rails.root}/lib]

    # rails g 不生成 assets 和 test 文件
    config.generators do |generator|
      generator.assets false # js css
      generator.test_framework false
      generator.skip_routes true # 不生成路由
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
