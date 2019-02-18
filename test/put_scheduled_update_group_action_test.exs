defmodule PutScheduledUpdateGroupActionTest do
  use ExUnit.Case

  test "params for put_scheduled_update_group_action" do
    op =
      ExAws.AutoScaling.put_scheduled_update_group_action("my-asg", "my-scheduled-action",
        desired_capacity: 8,
        min_size: 6,
        max_size: 10,
        start_time: "2019-06-01T00:00:00Z"
      )

    assert op.params == %{
             "Action" => "PutScheduledUpdateGroupAction",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "ScheduledActionName" => "my-scheduled-action",
             "MinSize" => 6,
             "MaxSize" => 10,
             "DesiredCapacity" => 8,
             "StartTime" => "2019-06-01T00:00:00Z"
           }
  end
end
