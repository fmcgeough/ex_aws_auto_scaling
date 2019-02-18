defmodule EnterStandbyTest do
  use ExUnit.Case

  test "Move instances into standby state" do
    op = ExAws.AutoScaling.enter_standby("my-asg", true, instance_ids: ["i-12345678"])

    assert op.params == %{
             "Action" => "EnterStandby",
             "AutoScalingGroupName" => "my-asg",
             "Version" => "2011-01-01",
             "InstanceIds.member.1" => "i-12345678",
             "ShouldDecrementDesiredCapacity" => true
           }
  end
end
