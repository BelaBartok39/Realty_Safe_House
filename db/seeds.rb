# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# --- Ensure User Roles Exist ---
# Find or create the default realtor user
realtor_email = "jackthelion83@gmail.com"
realtor = User.find_or_initialize_by(email: realtor_email)
if realtor.new_record?
  realtor.password = "password"
  realtor.password_confirmation = "password"
  realtor.name = "Default Realtor"
  realtor.role = :realtor
  realtor.save!
  puts "Created Realtor: #{realtor_email}"
else
  # Ensure existing user has realtor role if found by email
  realtor.update!(role: :realtor) unless realtor.realtor?
  puts "Found Realtor: #{realtor_email}"
end

# Find or create a default client user
client_email = "ndrdmond@memphis.edu"
client = User.find_or_initialize_by(email: client_email)
if client.new_record?
  client.password = "password"
  client.password_confirmation = "password"
  client.name = "Default Client"
  client.role = :client # Assuming default is client, but explicitly set
  client.save!
  puts "Created Client: #{client_email}"
else
  puts "Found Client: #{client_email}"
end


# --- Seed Properties ---
puts "Seeding properties..."

# Define the path to your seed images
seed_image_dir = Rails.root.join('db', 'seed_images')
image_files = Dir.glob(File.join(seed_image_dir, '*.{jpg,jpeg,png}'))

if image_files.empty?
  puts "WARNING: No images found in #{seed_image_dir}. Properties will be created without images."
  puts "Please create the directory and add some .jpg or .png files."
end

# Number of properties to create
property_count = 18

property_count.times do |i|
  start_time = Faker::Time.forward(days: 30, period: :afternoon) # Removed format: :long
  end_time = start_time + [ 1, 2, 3 ].sample.hours # Add 1, 2, or 3 hours

  property = Property.new(
    title: Faker::Lorem.words(number: [ 3, 4, 5 ].sample).map(&:capitalize).join(' ') + " Open House",
    description: Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4),
    address: Faker::Address.full_address,
    start_time: start_time,
    end_time: end_time,
    realtor: realtor # Assign the realtor user
  )

  # Attach an image if available
  if image_files.any?
    image_path = image_files.sample # Pick a random image
    property.image.attach(io: File.open(image_path), filename: File.basename(image_path))
    puts "  Attaching image: #{File.basename(image_path)}"
  end

  if property.save
    puts "  Created property: #{property.title}"
  else
    puts "  ERROR creating property: #{property.errors.full_messages.join(', ')}"
  end
end

puts "Finished seeding database."
