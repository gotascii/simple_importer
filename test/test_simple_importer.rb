require 'test_helper'

class CrazyImporter
  include SimpleImporter
end

class SimpleImporterTest < Test::Unit::TestCase
  context "The SimpleImporter module" do
    setup do
      SimpleImporter.importers.clear
    end

    should "have an importers hash field" do
      SimpleImporter.importers.should == {}
    end

    should "create a new importer" do
      block = lambda{ 'omg' }
      SimpleImporter::Importer.expects(:new).with(&block)
      SimpleImporter.importer(:bob, &block)
    end

    should "add new importer to importers" do
      SimpleImporter::Importer.stubs(:new).returns('hi')
      SimpleImporter.importer(:bob)
      SimpleImporter.importers[:bob].should == 'hi'
    end

    should "look in importer, app/importers, and lib/importers for importers" do
      SimpleImporter.importer_paths.should == %w{importers app/importers lib/importers}
    end

    should "return csv default options for csv_config_methods" do
      SimpleImporter.csv_config_meths.should == CSV::DEFAULT_OPTIONS.keys
    end

    should "return csv_config_meths plus file and callbacks for config_meths" do
      SimpleImporter.stubs(:csv_config_meths).returns([:yo])
      SimpleImporter.config_meths.should == [:yo, :file, :callbacks]
    end

    should "forward [] to importers" do
      SimpleImporter.importers.expects(:[]).with(:omg).returns('hey')
      SimpleImporter[:omg].should == 'hey'
    end
  end

  context "An instance of the CrazyImporter class" do
    setup do
      @importer = CrazyImporter.new
    end

    should "return kv pairs where key is in SimpleImporter.csv_config_meths for csv_config" do
      @importer.csv_config.keys.each do |k|
        SimpleImporter.csv_config_meths.include?(k).should be(true)
      end
    end

    should "have fields for every CSV::DEFAULT_OPTIONS" do
      CSV::DEFAULT_OPTIONS.keys.each do |meth|
        @importer.send(meth, 'val')
        @importer.send(meth).should == 'val'
      end
    end

    should "have a file field" do
      @importer.file 'file'
      @importer.file.should == 'file'
    end

    should "have a callbacks field" do
      @importer.callbacks true
      @importer.callbacks.should be(true)
    end
    
    should "execute callbacks by default" do
      @importer.callbacks.should be(true)
    end

    should "create headers by default" do
      @importer.headers.should be(true)
    end

    should "execute symbol header_converters by default" do
      @importer.header_converters.should == :symbol
    end

    should "execute all converters by default" do
      @importer.converters.should == :all
    end

    should "save block passed to before in before field" do
      @importer.before { 'blazer' }
      @importer.before.call.should == 'blazer'
    end

    should "save block passed to foreach in foreach field" do
      @importer.foreach { 'blazer' }
      @importer.foreach.call.should == 'blazer'
    end

    should "not run callbacks if callbacks is false" do
      before = mock { expects(:call).never }
      @importer.stubs(:before => before)
      @importer.callbacks false
      @importer.run_callbacks
    end

    should "run callbacks if callbacks is true" do
      before = mock { expects(:call) }
      @importer.stubs(:before => before)
      @importer.callbacks true
      @importer.run_callbacks
    end

    should "not run callbacks if callbacks is true and there are no callbacks" do
      @importer.config[:before] = nil
      @importer.callbacks true
      @importer.run_callbacks
    end

    should "run callbacks when run" do
      CSV.stubs(:foreach)
      @importer.expects(:run_callbacks)
      @importer.run
    end

    should "call CSV.foreach with file, csv_config when run" do
      @importer.stubs(:file).returns('file')
      @importer.stubs(:csv_config).returns('csv_config')
      CSV.expects(:foreach).with('file', 'csv_config')
      @importer.run
    end
  end

  context "The Importer class" do
    should "include SimpleImporter" do
      SimpleImporter::Importer.ancestors.include?(SimpleImporter)
    end

    should "instance eval block on initialize" do
      SimpleImporter::Importer.any_instance.expects(:bobo)
      SimpleImporter::Importer.new do
        bobo
      end
    end
  end
end