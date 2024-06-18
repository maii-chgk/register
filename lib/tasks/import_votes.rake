require_relative "../../app/lib/discourse/client"

task :import_votes_for_assembly, [:assembly_id] => :environment do |_, args|
  import_vote_for_assembly(args[:assembly_id])
end

task import_votes_for_all_assemblies: :environment do
  Assembly.all.each do |assembly|
    Rails.logger.info "Importing votes for assembly #{assembly.id}"
    import_vote_for_assembly(assembly.id)
  end
end

task :import_votes_for_voting_session, [:voting_session_id] => :environment do |_, args|
  import_vote_for_voting_session(args[:voting_session_id])
end

task import_votes_for_all_voting_sessions: :environment do
  VotingSession.all.each do |voting_session|
    Rails.logger.info "Importing votes for voting session #{voting_session.id}"
    import_vote_for_voting_session(voting_session.id)
  end
end

def import_vote_for_assembly(assembly_id)
  assembly = Assembly.find(assembly_id)
  return if assembly.nil?

  client = Discourse::Client.new
  assembly.voting_topics.each do |voting_topic|
    Rails.logger.info "Listing voters for topic #{voting_topic.topic_id}"
    voters = client.list_all_voters_for_topic(voting_topic.topic_id)

    voters.each do |discourse_username, _discourse_id|
      person = Person.find_by(discourse_username:)
      if person.nil?
        Rails.logger.warn "person with discourse_username #{discourse_username} not found"
        next
      end

      Vote.find_or_create_by(person:, voting_topic:, assembly:, date: assembly.start_date)
    end
  end
end

def import_vote_for_voting_session(voting_session_id)
  voting_session = VotingSession.find(voting_session_id)
  return if voting_session.nil?

  client = Discourse::Client.new
  voting_session.voting_topics.each do |voting_topic|
    Rails.logger.info "Listing voters for topic #{voting_topic.topic_id}"
    voters = client.list_all_voters_for_topic(voting_topic.topic_id)

    voters.each do |discourse_username, _discourse_id|
      person = Person.find_by(discourse_username:)
      if person.nil?
        Rails.logger.warn "person with discourse_username #{discourse_username} not found"
        next
      end

      Vote.find_or_create_by(person:, voting_topic:, voting_session:, date: voting_session.start_date)
    end
  end
end
