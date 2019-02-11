defmodule DescribeAutoScalingInstancesTest do
  use ExUnit.Case

  test "simple describe" do
    op = ExAws.AutoScaling.describe_auto_scaling_instances()

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DescribeAutoScalingInstances"
           }
  end

  test "describe single instance" do
    op = ExAws.AutoScaling.describe_auto_scaling_instances(instance_ids: ["i-12345678"])

    assert op.params == %{
             "Action" => "DescribeAutoScalingInstances",
             "Version" => "2011-01-01",
             "InstanceIds.member.1" => "i-12345678"
           }
  end
end
