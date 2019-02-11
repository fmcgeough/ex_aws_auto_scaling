defmodule DescribeLoadBalancersTest do
  use ExUnit.Case

  test "describe classic balancers" do
    op = ExAws.AutoScaling.describe_load_balancers("my-asg")

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DescribeLoadBalancers",
             "AutoScalingGroupName" => "my-asg"
           }
  end

  test "describe app and network balancers" do
    op = ExAws.AutoScaling.describe_load_balancer_target_groups("my-asg")

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DescribeLoadBalancerTargetGroups",
             "AutoScalingGroupName" => "my-asg"
           }
  end
end
