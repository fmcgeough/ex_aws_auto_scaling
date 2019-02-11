defmodule DeleteLifeCycleHookTest do
  use ExUnit.Case

  test "simple delete" do
    op = ExAws.AutoScaling.delete_lifecycle_hook("my-asg", "my-lifecycle-hook")

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DeleteLifecycleHook",
             "AutoScalingGroupName" => "my-asg",
             "LifecycleHookName" => "my-lifecycle-hook"
           }
  end
end
