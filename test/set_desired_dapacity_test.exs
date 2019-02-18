defmodule SetDesiredCapacityTest do
  use ExUnit.Case

  test "set desired capacity" do
    op = ExAws.AutoScaling.set_desired_capacity("my-asg", 10, honor_cooldown: true)

    assert op.params == %{
             "Action" => "SetDesiredCapacity",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "DesiredCapacity" => 10,
             "HonorCooldown" => true
           }
  end
end
