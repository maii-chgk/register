require "test_helper"

describe Assembly do
  test "assemblies for dates are found" do
    assert Assembly.for_date(Date.new(2021, 5, 29))
    assert_nil Assembly.for_date(Date.new(2021, 5, 30))
    assert Assembly.for_date(Date.new(2021, 7, 3))
    assert Assembly.for_date(Date.new(2021, 7, 4))
    assert Assembly.for_date(Date.new(2022, 12, 20))
    assert Assembly.for_date(Date.new(2022, 12, 21))
    assert_nil Assembly.for_date(Date.new(2022, 12, 22))
  end
end
