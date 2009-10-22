require "csv"

if CSV.const_defined? :Reader
  require 'fastercsv'
  Object.send(:remove_const, :CSV)
  CSV = FasterCSV
end

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

    [:before, :foreach, :foreach_file].each do |meth|
      base.class_eval <<-METH
        def #{meth}(&block)
          config[:#{meth}] = block if block_given?
          config[:#{meth}]
        end
      METH
    end
    
    base.class_eval do
      attr_accessor :name
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
    csv_config_meths + [:file, :callbacks, :desc]
  end

  def self.importers
    @importers ||= []
  end

  def self.importer(name, &block)
    importers << Importer.new(name, &block)
  end

  def self.[](name)
    importers.select{|i| i.name == name}.first
  end

  def config
    @config ||= {
      :callbacks => true,
      :headers => true,
      :header_converters => :symbol,
      :converters => :all,
      :desc => 'a simple_import importer'
    }
  end

  def csv_config
    config.select{|k,v| SimpleImporter.csv_config_meths.include?(k)}
  end

  def run
    run_callbacks
    [file].flatten.each do |f|
      foreach_file.call(f) if foreach_file
      CSV.foreach(f, csv_config, &foreach) if foreach
    end
  end

  def run_callbacks
    self.before.call if callbacks && before
  end

  class Importer
    include SimpleImporter

    def initialize(name, &block)
      self.name = name
      instance_eval(&block)
    end
  end
end