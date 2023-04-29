class BackupJob < ApplicationJob
  queue_as :default

  after_perform do |_job|
    BackupJob.set(wait: 1.day).perform_later
  end

  def perform(*args)
    Rails.logger.info "Loading credentials..."
    credentials = Aws::Credentials.new(Rails.application.credentials.dig(:aws, :access_key_id),
                                       Rails.application.credentials.dig(:aws, :secret_access_key))
    s3 = Aws::S3::Client.new(region: 'eu-central-1', credentials: credentials)

    db_name = "/db/production_db.sqlite3"
    backup_name = "/db/#{Date.today}_backup.sqlite3"

    Rails.logger.info "Creating local backup at #{backup_name}..."
    system "sqlite3 #{db_name} \".backup #{backup_name}\""
    Rails.logger.info "Local backup created"

    Rails.logger.info "Uploading backup to S3..."
    s3.put_object(bucket: "maii-register-backup", key: "#{backup_name}", body: IO.read(backup_name))
    Rails.logger.info "Backup uploaded"

    Rails.logger.info "Removing local backup file at #{backup_name}..."
    system "rm #{backup_name}"
    Rails.logger.info "Local backup file removed"
  end
end
