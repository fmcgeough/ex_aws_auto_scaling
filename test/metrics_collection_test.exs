defmodule MetricsCollectionTest do
  use ExUnit.Case

  test "disable all metrics" do
    op = ExAws.AutoScaling.disable_metrics_collection("my-asg")

    assert op.params == %{
             "Action" => "DisableMetricsCollection",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg"
           }
  end

  test "disable some metrics" do
    op =
      ExAws.AutoScaling.disable_metrics_collection("my-asg",
        metrics: ["GroupPendingInstances", "GroupTerminatingInstances"]
      )

    assert op.params == %{
             "Action" => "DisableMetricsCollection",
             "AutoScalingGroupName" => "my-asg",
             "Version" => "2011-01-01",
             "Metrics.member.1" => "GroupPendingInstances",
             "Metrics.member.2" => "GroupTerminatingInstances"
           }
  end

  test "enable all metrics" do
    op = ExAws.AutoScaling.enable_metrics_collection("my-asg")

    assert op.params == %{
             "Action" => "EnableMetricsCollection",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "Granularity" => "1Minute"
           }
  end

  test "enable some metrics" do
    op =
      ExAws.AutoScaling.enable_metrics_collection("my-asg", "1Minute",
        metrics: ["GroupPendingInstances", "GroupTerminatingInstances"]
      )

    assert op.params == %{
             "Action" => "EnableMetricsCollection",
             "Version" => "2011-01-01",
             "AutoScalingGroupName" => "my-asg",
             "Granularity" => "1Minute",
             "Metrics.member.1" => "GroupPendingInstances",
             "Metrics.member.2" => "GroupTerminatingInstances"
           }
  end
end
