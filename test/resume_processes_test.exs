defmodule ResumeProcessesTest do
  use ExUnit.Case

  test "resume processes in ASG" do
    op =
      ExAws.AutoScaling.resume_processes("my-asg",
        scaling_processes: ["Launch", "ReplaceUnhealthy"]
      )

    assert op.params == %{
             "Action" => "ResumeProcesses",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "ScalingProcesses.member.1" => "Launch",
             "ScalingProcesses.member.2" => "ReplaceUnhealthy"
           }
  end
end
