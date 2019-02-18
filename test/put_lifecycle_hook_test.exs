defmodule PutLifecycleHookTest do
  use ExUnit.Case

  test "all params for put_lifecycle_hook" do
    op =
      ExAws.AutoScaling.put_lifecycle_hook("my-asg", "my-hook",
        lifecycle_transition: "autoscaling:EC2_INSTANCE_LAUNCHING",
        default_result: "CONTINUE",
        heartbeat_timeout: 60,
        notification_metadata: "notification-data",
        role_arn: "arn:aws:iam::123456789012:role/my-auto-scaling-role",
        notification_target_arn: "arn:aws:sns:us-west-2:123456789012:my-sns-topic --role-arn"
      )

    assert op.params == %{
             "Action" => "PutLifecycleHook",
             "AutoScalingGroupName" => "my-asg",
             "LifecycleHookName" => "my-hook",
             "Version" => "2011-01-01",
             "DefaultResult" => "CONTINUE",
             "HeartbeatTimeout" => 60,
             "LifecycleTransition" => "autoscaling:EC2_INSTANCE_LAUNCHING",
             "NotificationMetadata" => "notification-data",
             "NotificationTargetARN" =>
               "arn:aws:sns:us-west-2:123456789012:my-sns-topic --role-arn",
             "RoleARN" => "arn:aws:iam::123456789012:role/my-auto-scaling-role"
           }
  end
end
