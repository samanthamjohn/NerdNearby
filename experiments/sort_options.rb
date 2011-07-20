ab_test "Sort options" do
  description "Test good sorting vs bad sorting."
  alternatives "good", "bad"
  metrics :interaction
end
