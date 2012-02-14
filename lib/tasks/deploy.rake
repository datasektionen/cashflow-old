require "sass"
require "sass/plugin"
namespace :deploy do
  desc "compile stylesheets"
  task :compile_stylesheets do
    Sass::Plugin.options[:template_location] = {"app/stylesheets" => "public/stylesheets"}
    Sass::Plugin.force_update_stylesheets
  end
end
