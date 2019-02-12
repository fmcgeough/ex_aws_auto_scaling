defmodule DescribeNotificationConfigurationsTest do
  use ExUnit.Case

  test "describe notification configurations on auto scaling group" do
    op =
      ExAws.AutoScaling.describe_notification_configurations(auto_scaling_group_names: ["my-asg"])

    assert op.params == %{
             "Action" => "DescribeNotificationConfigurations",
             "Version" => "2011-01-01",
             "AutoScalingGroupNames.member.1" => "my-asg"
           }
  end
end
