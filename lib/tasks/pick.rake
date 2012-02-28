namespace :pick do
  desc "Pick a random user as the winner"
  task :winner => :environment do
    puts "Winner: #{pick(IndexedDirectory).name}"
  end

  desc "Pick a random product as the prize"
  task :prize => :environment do
    puts "Prize: #{pick(IndexedFile).name}"
  end

  desc "Pick a random prize and winner"
  task :all => [:prize, :winner]

  def pick(model_class)
    model_class.first()
  end

  desc "Testing environment and variables"
  task :hello, [:message, :msg2] => :environment do |t, args|
    puts "[#{args[:message]}]"
    puts "#{args}"
    args.with_defaults({:message => "Thanks for logging on"})
    puts "#{args}"
    puts "[#{args[:message]}]"
    #puts "Winner: [#{pick(IndexedDirectory).name}] #{:message}"
  end
end