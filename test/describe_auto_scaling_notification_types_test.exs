defmodule DescribeAutoScalingNotificationTypesTest do
  use ExUnit.Case

  test "simple describe" do
    op = ExAws.AutoScaling.describe_auto_scaling_notification_types()

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DescribeAutoScalingNotificationTypes"
           }
  end
end
