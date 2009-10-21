importer :crazy do
  file 'data/people.csv'
  callbacks true
  headers true
  header_converters :symbol
  converters :all

  before do
    puts 'before!'
  end

  foreach do |row|
    puts row[:name]
    puts row[:rank]
    puts row[:nickname]
  end
end