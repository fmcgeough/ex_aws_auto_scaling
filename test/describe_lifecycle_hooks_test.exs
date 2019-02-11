defmodule DescribeLifecycleHooksTest do
  use ExUnit.Case

  test "simple describe" do
    op = ExAws.AutoScaling.describe_lifecycle_hooks("my-asg")

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DescribeLifecycleHooks",
             "AutoScalingGroupName" => "my-asg"
           }
  end

  test "describe for one hook" do
    op =
      ExAws.AutoScaling.describe_lifecycle_hooks("my-asg",
        lifecycle_hook_names: ["my-launch-hook"]
      )

    assert op.params == %{
             "Action" => "DescribeLifecycleHooks",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "LifecycleHookNames.member.1" => "my-launch-hook"
           }
  end
end
