defmodule TerminateInstanceInAutoScalingGroupTest do
  use ExUnit.Case

  test "terminate instance in ASG" do
    op = ExAws.AutoScaling.terminate_instance_in_auto_scaling_group("i-12345678", true)

    assert op.params == %{
             "Action" => "TerminateInstanceInAutoScalingGroup",
             "Version" => "2011-01-01",
             "InstanceId" => "i-12345678",
             "ShouldDecrementDesiredCapacity" => true
           }
  end
end
