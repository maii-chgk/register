require "test_helper"

describe VotingSession do
  test "voting sessions for dates are found" do
    assert VotingSession.for_date(Date.new(2022, 6, 30))
    assert_nil VotingSession.for_date(Date.new(2022, 6, 29))
    assert_nil VotingSession.for_date(Date.new(2022, 7, 29))
  end
end
