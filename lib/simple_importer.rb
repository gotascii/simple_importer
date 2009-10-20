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
end