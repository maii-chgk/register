Rails.application.config.after_initialize do
  if Rails.env.production? && !Rails.const_defined?(:Console)
    BackupJob.set(wait: 1.hour).perform_later
  end
end
