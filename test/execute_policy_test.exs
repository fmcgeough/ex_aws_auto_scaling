defmodule ExecutePolicyTest do
  use ExUnit.Case

  test "policy" do
    op = ExAws.AutoScaling.execute_policy("my-asg", "ScaleIn", honor_cooldown: true)

    assert op.params == %{
             "Action" => "ExecutePolicy",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "PolicyName" => "ScaleIn",
             "HonorCooldown" => true
           }
  end
end
