require 'rails/all'

namespace :utils do
  desc "Initialize DB"
  task db_initializer: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
  end

  desc "Seeds db with random 10 new contacts"
  task db_seeding: :environment do
    puts "Generating contacts"
    100.times do |i|
      Contact.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        kind: Kind.all.sample,
        rmk: Faker::Lorem.paragraph)
    end

    Contact.all.each do |contact|
      Random.rand(1..5).times do |i|

        puts "Generating phones #{i}/? for #{contact.name}"
        Phone.create!(
          phone: Faker::PhoneNumber.phone_number,
          contact: contact)
      end

      puts "Generating address for #{contact.name}"
      Address.create!(
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state,
        contact: contact)
    end
  end
end
