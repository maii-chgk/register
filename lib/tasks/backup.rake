desc "Back up database"
task :backup => :environment do
  puts "Loading credentials..."
  credentials = Aws::Credentials.new(Rails.application.credentials.dig(:aws, :access_key_id),
                                     Rails.application.credentials.dig(:aws, :secret_access_key))
  s3 = Aws::S3::Client.new(region: 'eu-central-1', credentials: credentials)

  db_name = "/db/production_db.sqlite3"
  backup_name = "/db/#{Date.today}_backup.sqlite3"

  puts "Creating local backup at #{backup_name}..."
  system "sqlite3 #{db_name} \".backup #{backup_name}\""
  puts "Local backup created"

  puts "Uploading backup to S3..."
  s3.put_object(bucket: "maii-register-backup", key: "#{backup_name}", body: IO.read(backup_name))
  puts "Backup uploaded"

  puts "Removing local backup file at #{backup_name}..."
  system "rm #{backup_name}"
  puts "Local backup file removed"
end
