require 'csv'

# require 'lib/simple_importer'
# SimpleImporter.find_importers
# SimpleImporter[:crazy].run

module SimpleImporter
  def self.included(base)
    config_meths.each do |meth|
      base.class_eval <<-METH
        def #{meth}(val = nil)
          config[:#{meth}] = val unless val.nil?
          config[:#{meth}]
        end
      METH
    end

    [:before, :foreach].each do |meth|
      base.class_eval <<-METH
        def #{meth}(&block)
          config[:#{meth}] = block if block_given?
          config[:#{meth}]
        end
      METH
    end
  end

  def self.importer_paths
    %w{importers app/importers lib/importers}
  end

  def self.find_importers
    importer_paths.each do |path| 
      Dir[File.join(path, '*.rb')].each do |file|
        coedz = File.open(file).read
        SimpleImporter.class_eval(coedz)
      end
    end
  end

  def self.csv_config_meths
    CSV::DEFAULT_OPTIONS.keys
  end

  def self.config_meths
    csv_config_meths + [:file, :callbacks]
  end

  def self.importers
    @importers ||= {}
  end

  def self.importer(name, &block)
    importers[name] = Importer.new(&block)
  end

  def self.[](name)
    importers[name]
  end

  def config
    @config ||= {
      :callbacks => true,
      :headers => true,
      :header_converters => :symbol,
      :converters => :all
    }
  end

  def csv_config
    config.select{|k,v| SimpleImporter.csv_config_meths.include?(k)}
  end

  def run
    run_callbacks
    CSV.foreach(file, csv_config, &foreach)
  end

  def run_callbacks
    self.before.call if callbacks && before
  end

  class Importer
    include SimpleImporter

    def initialize(&block)
      instance_eval(&block)
    end
  end
end