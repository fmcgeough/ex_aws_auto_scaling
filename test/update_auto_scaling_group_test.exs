defmodule UpdateAutoScalingGroupTest do
  use ExUnit.Case

  test "simple auto scale group update" do
    op =
      ExAws.AutoScaling.update_auto_scaling_group("my-auto-scaling-group",
        vpc_zone_identifier: "subnet-4176792c",
        launch_configuration_name: "my-launch-config"
      )

    assert op.params == %{
             "Action" => "UpdateAutoScalingGroup",
             "AutoScalingGroupName" => "my-auto-scaling-group",
             "LaunchConfigurationName" => "my-launch-config",
             "VpcZoneIdentifier" => "subnet-4176792c",
             "Version" => "2011-01-01"
           }
  end

  test "update availability zones" do
    op =
      ExAws.AutoScaling.update_auto_scaling_group("my-auto-scaling-group",
        launch_configuration_name: "my-launch-config",
        availability_zones: ["us-east-1", "us-east-2"],
        health_check_grace_period: 120,
        health_check_type: "ELB"
      )

    assert op.params == %{
             "Action" => "UpdateAutoScalingGroup",
             "AutoScalingGroupName" => "my-auto-scaling-group",
             "AvailabilityZones.member.1" => "us-east-1",
             "AvailabilityZones.member.2" => "us-east-2",
             "HealthCheckGracePeriod" => 120,
             "HealthCheckType" => "ELB",
             "LaunchConfigurationName" => "my-launch-config",
             "Version" => "2011-01-01"
           }
  end
end
