defmodule DetachInstancesTest do
  use ExUnit.Case

  test "detach single instance from ASG" do
    op = ExAws.AutoScaling.detach_instances("my-asg", true, instance_ids: ["1=i-12345678"])

    assert op.params == %{
             "Action" => "DetachInstances",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "InstanceIds.member.1" => "1=i-12345678",
             "ShouldDecrementDesiredCapacity" => true
           }
  end
end
