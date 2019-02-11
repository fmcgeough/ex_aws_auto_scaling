defmodule DeleteAutoScalingGroupTest do
  use ExUnit.Case

  test "delete with just name" do
    op = ExAws.AutoScaling.delete_auto_scaling_group("my-asg")

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DeleteAutoScalingGroup",
             "AutoScalingGroupName" => "my-asg"
           }
  end

  test "delete with force option" do
    op = ExAws.AutoScaling.delete_auto_scaling_group("my-asg", force_delete: true)

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DeleteAutoScalingGroup",
             "AutoScalingGroupName" => "my-asg",
             "ForceDelete" => true
           }
  end
end
