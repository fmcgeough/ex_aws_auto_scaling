defmodule RecordLifecycleActionHeartbeatTest do
  use ExUnit.Case

  test "all params for record_lifecycle_action_heartbeat" do
    op =
      ExAws.AutoScaling.record_lifecycle_action_heartbeat("my-asg", "my-hook",
        lifecycle_action_token: "token-test",
        instance_id: "i-12345678"
      )

    assert op.params == %{
             "Action" => "RecordLifecycleActionHeartbeat",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "LifecycleHookName" => "my-hook",
             "LifecycleActionToken" => "token-test",
             "InstanceId" => "i-12345678"
           }
  end
end
