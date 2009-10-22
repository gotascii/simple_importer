namespace :simple_importer do
  def importers
    require 'simple_importer'
    SimpleImporter.find_importers
    SimpleImporter.importers
  end

  importers.each do |i|
    desc i.desc
    task i.name do
      Rake::Task[:environment].invoke if Rake::Task.task_defined?(:environment)
      puts "Importing #{i.name}"
      i.run
      puts "Finished importing #{i.name}"
    end
  end

  desc "run all importers"
  task :import do
    importers.each do |i|
      Rake::Task["simple_importer:#{i.name}"].invoke
    end
  end
end