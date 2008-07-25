simple_importer
    by Justin Marney
    http://github.com/vigetlabs/simple_importer/

== DESCRIPTION:

Simple API for importing from csv, tsv and xml.

== FEATURES/PROBLEMS:

* FIXME (list of features or problems)

== SYNOPSIS:

# extend your import modules and define import methods
module AccessoryImporter
  extend SimpleImporter

  # if true is passed to run, reset will get called first if it exists.
  def self.reset
    Accessory.find(:all).each {|a| a.destroy }
  end

  def self.import
    csv('Accessory Schema.csv') do |row|
      unless row[0].nil? || row[0] == 'SKU'
        accessory = Accessory.create!(:sku => row[0],
        :image => row[1],
        :thumbnail_image => row[2],
        :name => row[3],
        :supplier_cost => row[4],
        :retail_cost => row[5],
        :description => row[6])
      end
    end
  end
end

# run your import modules (from a rake task perhaps)
AccessoryImporter.run

The csv & tsv import methods also take an optional (default false) boolean
parameter that indicates whether or not to ignore the header (first) line.

== REQUIREMENTS:

Hpricot is required if you intend to import xml.
test/spec and mocha are required to run the tests.

== INSTALL:

sudo gem install vigetlabs-simple_importer -s http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 Justin Marney

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
