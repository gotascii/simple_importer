require 'test_helper'

class CrazyImporter
  include SimpleImporter
end

class SimpleImporterTest < Test::Unit::TestCase
  context "The SimpleImporter module" do
    setup do
      SimpleImporter.importers.clear
    end

    should "have an importers array field" do
      SimpleImporter.importers.should == []
    end

    should "create a new importer" do
      block = lambda{ 'omg' }
      SimpleImporter::Importer.expects(:new).with(&block)
      SimpleImporter.importer(:bob, &block)
    end

    should "add new importer to importers" do
      SimpleImporter::Importer.stubs(:new).returns('hi')
      SimpleImporter.importers.expects(:<<).with('hi')
      SimpleImporter.importer(:bob)
    end
  end

  context "An instance of the CrazyImporter class" do
    setup do
      @importer = CrazyImporter.new
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
  end

  context "The Importer class" do
    should "include SimpleImporter" do
      SimpleImporter::Importer.ancestors.include?(SimpleImporter)
    end
  end
end