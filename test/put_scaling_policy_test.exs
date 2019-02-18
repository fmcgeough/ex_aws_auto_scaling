defmodule PutScalingPolicyTest do
  use ExUnit.Case

  test "put_scaling_policy" do
    op =
      ExAws.AutoScaling.put_scaling_policy("my-asg", "my-policy",
        policy_type: "StepScaling",
        step_adjustments: [
          [
            metric_interval_lower_bound: 0,
            metric_interval_upper_bound: 10,
            scaling_adjustment: 2
          ],
          [
            metric_interval_lower_bound: 10,
            metric_interval_upper_bound: 20,
            scaling_adjustment: 2
          ]
        ]
      )

    assert op.params == %{
             "Action" => "PutScalingPolicy",
             "AutoScalingGroupName" => "my-asg",
             "PolicyName" => "my-policy",
             "Version" => "2011-01-01",
             "PolicyType" => "StepScaling",
             "StepAdjustments.member.1.MetricIntervalLowerBound" => 0,
             "StepAdjustments.member.1.MetricIntervalUpperBound" => 10,
             "StepAdjustments.member.1.ScalingAdjustment" => 2,
             "StepAdjustments.member.2.MetricIntervalLowerBound" => 10,
             "StepAdjustments.member.2.MetricIntervalUpperBound" => 20,
             "StepAdjustments.member.2.ScalingAdjustment" => 2
           }
  end
end
