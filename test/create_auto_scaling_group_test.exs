defmodule CreateAutoScalingGroupTest do
  use ExUnit.Case

  test "create simple auto scale group" do
    op =
      ExAws.AutoScaling.create_auto_scaling_group("my-auto-scaling-group", 1, 3,
        vpc_zone_identifier: "subnet-4176792c",
        launch_configuration_name: "my-launch-config"
      )

    assert op.params == %{
             "Action" => "CreateAutoScalingGroup",
             "AutoScalingGroupName" => "my-auto-scaling-group",
             "LaunchConfigurationName" => "my-launch-config",
             "MaxSize" => 3,
             "MinSize" => 1,
             "Version" => "2011-01-01",
             "VpcZoneIdentifier" => "subnet-4176792c"
           }
  end

  test "create auto scaling group attached to classic load balancer" do
    op =
      ExAws.AutoScaling.create_auto_scaling_group("my-auto-scaling-group", 1, 3,
        launch_configuration_name: "my-launch-config",
        availability_zones: ["us-east-1", "us-east-2"],
        health_check_grace_period: 120,
        health_check_type: "ELB",
        load_balancer_names: ["my-load-balancer"]
      )

    assert op.params == %{
             "Action" => "CreateAutoScalingGroup",
             "AutoScalingGroupName" => "my-auto-scaling-group",
             "AvailabilityZones.member.1" => "us-east-1",
             "AvailabilityZones.member.2" => "us-east-2",
             "HealthCheckGracePeriod" => 120,
             "HealthCheckType" => "ELB",
             "LaunchConfigurationName" => "my-launch-config",
             "LoadBalancerNames.member.1" => "my-load-balancer",
             "MaxSize" => 3,
             "MinSize" => 1,
             "Version" => "2011-01-01"
           }
  end

  test "create auto scale group and attach to specified target group" do
    op =
      ExAws.AutoScaling.create_auto_scaling_group("my-auto-scaling-group", 1, 3,
        launch_configuration_name: "my-launch-config",
        health_check_grace_period: 120,
        health_check_type: "ELB",
        target_group_arns: [
          "arn:aws:elasticloadbalancing:us-west-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"
        ],
        vpc_zone_identifier: "subnet-4176792c, subnet-65ea5f08"
      )

    assert op.params == %{
             "Action" => "CreateAutoScalingGroup",
             "AutoScalingGroupName" => "my-auto-scaling-group",
             "HealthCheckGracePeriod" => 120,
             "HealthCheckType" => "ELB",
             "LaunchConfigurationName" => "my-launch-config",
             "MaxSize" => 3,
             "MinSize" => 1,
             "TargetGroupARNs.member.1" =>
               "arn:aws:elasticloadbalancing:us-west-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067",
             "Version" => "2011-01-01",
             "VpcZoneIdentifier" => "subnet-4176792c, subnet-65ea5f08"
           }
  end
end
