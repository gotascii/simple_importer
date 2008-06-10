require 'test_helper'

module CrazyImporter
  extend SimpleImporter
end

context "CrazyImporter" do
  specify "should parse a comma separated file" do
    CrazyImporter.csv(File.join(File.dirname(__FILE__), 'csv.txt')) do |row|
      row.length.should.equal 3
    end
  end
  specify "should parse a tab separated file" do
    CrazyImporter.tsv(File.join(File.dirname(__FILE__), 'tab.txt')) do |row|
      row.length.should.equal 4
    end
  end
end
