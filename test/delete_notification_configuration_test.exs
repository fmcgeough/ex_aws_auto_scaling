defmodule DeleteNotificationConfigurationTest do
  use ExUnit.Case

  test "simple delete" do
    arn = "arn:aws:sns:us-east-1:123456789012:my-sns-topic"
    op = ExAws.AutoScaling.delete_notification_configuration("my-asg", arn)

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DeleteNotificationConfiguration",
             "AutoScalingGroupName" => "my-asg",
             "TopicARN" => arn
           }
  end
end
