# $Id$

# Equivalent to a header guard in C/C++
# Used to prevent the class/module from being loaded more than once
unless defined? SimpleImporter

require 'csv'

module SimpleImporter
  def file(path)
    file = File.open(path)
    yield file if block_given?
    file.close
  end

  def csv(path, *args, &block)
    file(path) do |f|
      parsed_file = CSV::Reader.parse(f)
      process_rows(parsed_file, !args.empty?, &block)
    end
  end

  def tsv(path, *args, &block)
    file(path) do |f|
      parsed_file = CSV::Reader.parse(f, "\t")
      process_rows(parsed_file, !args.empty?, &block)
    end
  end

  def process_rows(parsed_file, ignore_header, &block)
    parsed_file.shift if ignore_header
    parsed_file.each do |row|    
      row.each {|v| v.trim! if v.respond_to? :trim! }
      yield row if block_given?
    end
  end

  def xml(path)
    require 'hpricot' unless defined? Hpricot
    file(path) do |f|
      doc = Hpricot(f)
      yield doc if block_given?
    end
  end

  def run(reset_flag = false)
    reset if reset_flag && respond_to?(:reset)
    import
  end

  # :stopdoc:
  VERSION = '1.0.0'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, *args)
  end

  # Utility method used to rquire all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

end  # module SimpleImporter

SimpleImporter.require_all_libs_relative_to __FILE__

end  # unless defined?

# EOF
