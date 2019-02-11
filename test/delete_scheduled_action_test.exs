defmodule DeleteScheduledActionTest do
  use ExUnit.Case

  test "simple delete" do
    op = ExAws.AutoScaling.delete_scheduled_action("my-asg", "my-scheduled-action")

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DeleteScheduledAction",
             "AutoScalingGroupName" => "my-asg",
             "ScheduledActionName" => "my-scheduled-action"
           }
  end
end
