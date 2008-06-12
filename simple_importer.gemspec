Gem::Specification.new do |s|
  s.name = %q{simple_importer}
  s.version = "1.0.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Marney"]
  s.date = %q{2008-06-12}
  s.description = %q{Simple API for importing from csv, tsv and xml.}
  s.email = %q{justin.marney@viget.com}
  s.extra_rdoc_files = ["History.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/simple_importer.rb", "tasks/ann.rake", "tasks/annotations.rake", "tasks/bones.rake", "tasks/doc.rake", "tasks/gem.rake", "tasks/manifest.rake", "tasks/post_load.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/test.rake", "test/test_helper.rb", "test/test_simple_importer.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/vigetlabs/simple_importer/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{simple_importer}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Simple API for importing from csv, tsv and xml}
  s.test_files = ["test/test_helper.rb", "test/test_simple_importer.rb"]
end