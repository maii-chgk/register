desc "Back up database"
task :backup => :environment do
  credentials = Aws::Credentials.new(Rails.application.credentials.dig(:aws, :access_key_id),
                                     Rails.application.credentials.dig(:aws, :secret_access_key))
  s3 = Aws::S3::Client.new(region: 'eu-central-1', credentials: credentials)

  db_name = "db/production.sqlite3"
  backup_name = "db/#{Date.today}_backup.sqlite3"

  system "sqlite3 #{db_name} \".backup #{backup_name}\""

  s3.put_object(bucket: "maii-register-backup", key: "#{backup_name}")

  system "rm #{backup_name}"
end
