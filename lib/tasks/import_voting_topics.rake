task import_voting_topics_for_assemblies: :environment do
  Psych.load_file("config/assemblies.yml").each do |assembly_id, voting_topic_ids|
    assembly = Assembly.find(assembly_id)
    voting_topic_ids.each do |topic_id|
      VotingTopic.find_or_create_by(assembly:, topic_id:)
    end
  end
end

task import_voting_topics_for_voting_sessions: :environment do
  Psych.load_file("config/voting_sessions.yml").each do |voting_session_id, voting_topic_ids|
    voting_session = VotingSession.find(voting_session_id)
    voting_topic_ids.each do |topic_id|
      VotingTopic.find_or_create_by(voting_session:, topic_id:)
    end
  end
end
