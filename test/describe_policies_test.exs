defmodule DescribePoliciesTest do
  use ExUnit.Case

  test "describe policies" do
    op = ExAws.AutoScaling.describe_policies(auto_scaling_group_name: "my-asg")

    assert op.params == %{
             "Action" => "DescribePolicies",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg"
           }
  end
end
