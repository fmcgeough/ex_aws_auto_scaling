defmodule CompleteLifeCycleActionTest do
  use ExUnit.Case

  test "basic op test" do
    op =
      ExAws.AutoScaling.complete_life_cycle_action("my-asg", "my-hook", "CONTINUE",
        instance_id: "i-12345678",
        lifecycle_action_token: "UUID13244ABC"
      )

    assert op.params == %{
             "Action" => "CompleteLifecycleAction",
             "AutoScalingGroupName" => "my-asg",
             "InstanceId" => "i-12345678",
             "LifecycleHookName" => "my-hook",
             "LifecycleActionResult" => "CONTINUE",
             "LifecycleActionToken" => "UUID13244ABC",
             "Version" => "2011-01-01"
           }
  end
end
