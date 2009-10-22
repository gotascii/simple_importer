namespace :simple_importer do
  desc "find SimpleImporter"
  task :find do
    require 'simple_importer'
    puts SimpleImporter
  end
end