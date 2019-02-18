defmodule SetInstanceProtectionTest do
  use ExUnit.Case

  test "terminate instance in ASG" do
    op = ExAws.AutoScaling.set_instance_protection("my-asg", ["i-12345678"], false)

    assert op.params == %{
             "Action" => "SetInstanceProtection",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "InstanceIds.member.1" => "i-12345678",
             "ProtectedFromScaleIn" => false
           }
  end
end
