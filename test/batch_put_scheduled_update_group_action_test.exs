defmodule BatchPutScheduledUpdateGroupActionTest do
  use ExUnit.Case

  test "test forming one-time only" do
    op =
      ExAws.AutoScaling.batch_put_scheduled_update_group_action(
        "my-asg",
        [
          [
            desired_capacity: 3,
            start_time: "2013-05-12T08:00:00Z"
          ]
        ]
      )

    assert op.params == %{
             "Action" => "BatchPutScheduledUpdateGroupAction",
             "AutoScalingGroupName" => "my-asg",
             "ScheduledUpdateGroupActions.member.1.DesiredCapacity" => 3,
             "ScheduledUpdateGroupActions.member.1.StartTime" => "2013-05-12T08:00:00Z",
             "Version" => "2011-01-01"
           }
  end

  test "forming scaling on recurring schedule" do
    op =
      ExAws.AutoScaling.batch_put_scheduled_update_group_action(
        "my-asg",
        [
          [
            desired_capacity: 3,
            scheduled_action_name: "scaleup-schedule-year",
            recurrence: "30 0 1 1,6,12 *"
          ]
        ]
      )

    assert op.params == %{
             "Action" => "BatchPutScheduledUpdateGroupAction",
             "AutoScalingGroupName" => "my-asg",
             "ScheduledUpdateGroupActions.member.1.DesiredCapacity" => 3,
             "ScheduledUpdateGroupActions.member.1.Recurrence" => "30 0 1 1,6,12 *",
             "ScheduledUpdateGroupActions.member.1.ScheduledActionName" =>
               "scaleup-schedule-year",
             "Version" => "2011-01-01"
           }
  end
end
