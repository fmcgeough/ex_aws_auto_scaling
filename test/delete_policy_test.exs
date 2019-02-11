defmodule DeletePolicyTest do
  use ExUnit.Case

  test "simple delete" do
    op = ExAws.AutoScaling.delete_policy("ScaleIn", auto_scaling_group_name: "my-asg")

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DeletePolicy",
             "AutoScalingGroupName" => "my-asg",
             "PolicyName" => "ScaleIn"
           }
  end
end
