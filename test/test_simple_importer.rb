require 'test_helper'

module CrazyImporter
  extend SimpleImporter
end

context "CrazyImporter" do
  specify "should parse a comma separated file" do
    rows = []
    CrazyImporter.csv(File.join(File.dirname(__FILE__), 'csv.txt')) do |row|
      row.length.should.equal 3
      rows << row
    end
    rows.length.should.equal 2
  end

  specify "should ignore header line in csv" do
    rows = []
    CrazyImporter.csv(File.join(File.dirname(__FILE__), 'csv.txt'), true) do |row|
      row[0].should.equal "dude"
      rows << row
    end
    rows.length.should.equal 1
  end

  specify "should parse a tab separated file" do
    rows = []
    CrazyImporter.tsv(File.join(File.dirname(__FILE__), 'tab.txt')) do |row|
      row.length.should.equal 4
      rows << row
    end
    rows.length.should.equal 2
  end

  specify "should ignore header line in tsv" do
    rows = []
    CrazyImporter.tsv(File.join(File.dirname(__FILE__), 'tab.txt'), true) do |row|
      row[0].should.equal "seriously"
      rows << row
    end
    rows.length.should.equal 1
  end
end
