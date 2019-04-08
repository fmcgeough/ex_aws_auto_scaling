defmodule AutoScalGroupParseTest do
  use ExUnit.Case
  alias ExAws.AutoScaling.Parsers

  @asg_xml_for_instance_check """
  <DescribeAutoScalingGroupsResponse xmlns="http://autoscaling.amazonaws.com/doc/2011-01-01/">
    <DescribeAutoScalingGroupsResult>
      <AutoScalingGroups>
        <member>
          <HealthCheckType>EC2</HealthCheckType>
          <Instances>
            <member>
              <LaunchConfigurationName>ecs_prod_apps_ami-test</LaunchConfigurationName>
              <LifecycleState>InService</LifecycleState>
              <InstanceId>i-12345678</InstanceId>
              <HealthStatus>Healthy</HealthStatus>
              <ProtectedFromScaleIn>true</ProtectedFromScaleIn>
              <AvailabilityZone>us-east-1a</AvailabilityZone>
              <LaunchTemplate>
                <LaunchTemplateId>testing</LaunchTemplateId>
                <LaunchTemplateName>test</LaunchTemplateName>
                <Version>1.0</Version>
              </LaunchTemplate>
            </member>
          </Instances>
          <DefaultCooldown>3600</DefaultCooldown>
          <DesiredCapacity>9</DesiredCapacity>
        </member>
     </AutoScalingGroups>
    </DescribeAutoScalingGroupsResult>
  </DescribeAutoScalingGroupsResponse>
  """

  test "parse instance with specification" do
    {:ok, %{body: body}} =
      Parsers.parse({:ok, %{body: @asg_xml_for_instance_check}}, :describe_auto_scaling_groups)

    asgs = body.auto_scaling_groups
    assert is_list(asgs)
    assert Enum.count(asgs) == 1
    auto_scale_group = Enum.at(asgs, 0)
    assert Enum.count(auto_scale_group.instances) == 1
    instance = Enum.at(auto_scale_group.instances, 0)
    assert instance.launch_template != nil
    assert is_map(instance.launch_template)
    assert instance.launch_template.launch_template_id == "testing"
    assert instance.launch_template.launch_template_name == "test"
    assert instance.launch_template.version == "1.0"
  end
end
