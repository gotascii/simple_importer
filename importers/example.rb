importer :example do
  file 'data/example.csv'

  before do
    puts 'before callback'
  end

  foreach do |row|
    puts "#{row[:name]}, #{row[:lvl]}, #{row[:screenname]}"
  end
end