if Code.ensure_loaded?(SweetXml) do
  defmodule ExAws.AutoScaling.Parsers do
    use ExAws.Operation.Query.Parser
    alias AwsDetective.AutoScaling.ParseTransforms
    require Logger

    def parse({:ok, %{body: xml} = resp}, :describe_account_limits) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeAccountLimitsResponse",
          number_of_launch_configurations:
            ~x"./DescribeAccountLimitsResult/NumberOfLaunchConfigurations/text()"i,
          max_number_of_launch_configurations:
            ~x"./DescribeAccountLimitsResult/MaxNumberOfLaunchConfigurations/text()"i,
          number_of_autoscaling_groups:
            ~x"./DescribeAccountLimitsResult/NumberOfAutoScalingGroups/text()"i,
          max_number_of_autoscaling_groups:
            ~x"./DescribeAccountLimitsResult/MaxNumberOfAutoScalingGroups/text()"i,
          request_id: ~x"./ResponseMetadata/RequestId/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_adjustment_types) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeAdjustmentTypesResponse",
          adjustment_types:
            ~x"./DescribeAdjustmentTypesResult/AdjustmentTypes/member/AdjustmentType/text()"l
            |> SweetXml.transform_by(&ParseTransforms.to_list/1),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_auto_scaling_groups) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeAutoScalingGroupsResponse",
          auto_scaling_groups: auto_scaling_groups_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribeAutoScalingGroupsResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_auto_scaling_instances) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeAutoScalingInstancesResponse",
          instances: auto_scaling_instances_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribeAutoScalingInstancesResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_auto_scaling_notification_types) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeAutoScalingNotificationTypesResponse",
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          auto_scaling_notification_types:
            ~x"./DescribeAutoScalingNotificationTypesResult/AutoScalingNotificationTypes/member/text()"l
            |> SweetXml.transform_by(&ParseTransforms.to_list/1)
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_launch_configurations) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeLaunchConfigurationsResponse",
          launch_configurations: launch_configurations_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribeLaunchConfigurationsResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_lifecycle_hooks) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeLifecycleHooksResponse",
          lifecycle_hooks: lifecycle_hooks_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_lifecycle_hook_types) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeLifecycleHookTypesResponse",
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          lifecycle_hook_types:
            ~x"./DescribeLifecycleHookTypesResult/LifecycleHookTypes/member/text()"l
            |> SweetXml.transform_by(&ParseTransforms.to_list/1)
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_load_balancers) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeLoadBalancersResponse",
          load_balancers: load_balancers_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_load_balancer_target_groups) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeLoadBalancerTargetGroupsResponse",
          load_balancer_target_groups: load_balancer_target_groups_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribeLaunchConfigurationsResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_metric_collection_types) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeMetricCollectionTypesResponse",
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          granularities:
            ~x"./DescribeMetricCollectionTypesResult/Granularities/member/Granularity/text()"l
            |> SweetXml.transform_by(&ParseTransforms.to_list/1),
          metrics:
            ~x"./DescribeMetricCollectionTypesResult/Metrics/member/Metric/text()"l
            |> SweetXml.transform_by(&ParseTransforms.to_list/1)
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_notification_configurations) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeNotificationConfigurationsResponse",
          notification_configurations: notification_configurations_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribeNotificationConfigurationsResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_policies) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribePoliciesResponse",
          scaling_policies: scaling_policies_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribePoliciesResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_scaling_activities) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeScalingActivitiesResponse",
          scaling_activities: scaling_activities_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribeScalingActivitiesResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_scaling_process_types) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeScalingProcessTypesResponse",
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          process_types:
            ~x"./DescribeScalingProcessTypesResult/Processes/member/ProcessName/text()"l
            |> SweetXml.transform_by(&ParseTransforms.to_list/1)
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_scheduled_actions) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeScheduledActionsResponse",
          scheduled_actions: scheduled_actions_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribeScheduledActionsResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_tags) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeTagsResponse",
          tags: tags_xml_description(),
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          next_token: ~x"./DescribeTagsResult/NextToken/text()"s
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_termination_policy_types) do
      parsed_body =
        xml
        |> SweetXml.xpath(
          ~x"//DescribeTerminationPolicyTypesResponse",
          request_id: ~x"./ResponseMetadata/RequestId/text()"s,
          termination_policy_types:
            ~x"DescribeTerminationPolicyTypesResult/TerminationPolicyTypes/member/text()"l
            |> SweetXml.transform_by(&ParseTransforms.to_list/1)
        )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse(val, _), do: val

    def to_launch_template(nil), do: nil

    def to_launch_template(xml) do
      xml
      |> SweetXml.xpath(~x"//LaunchTemplate",
        launch_template_id: ~x"./LaunchTemplateId/text()"s,
        launch_template_name: ~x"./LaunchTemplateName/text()"s,
        version: ~x"./Version/text()"s
      )
    end

    defp tags_xml_description do
      [
        ~x"./DescribeTagsResult/Tags/member"l,
        key: ~x"./Key/text()"s,
        propogate_at_launch: ~x"./PropagateAtLaunch/text()"s,
        resource_id: ~x"./ResourceId/text()"s,
        resource_type: ~x"./ResourceType/text()"s,
        value: ~x"./Value/text()"s
      ]
    end

    defp scheduled_actions_xml_description do
      [
        ~x"./DescribeScheduledActionsResult/ScheduledUpdateGroupActions/member"l,
        auto_scaling_group_name: ~x"./AutoScalingGroupName/text()"s,
        desired_capacity: ~x"./DesiredCapacity/text()"oi,
        end_time: ~x"./EndTime/text()"s,
        max_size: ~x"./MaxSize/text()"oi,
        min_size: ~x"./MinSize/text()"oi,
        recurrence: ~x"./Recurrence/text()"s,
        scheduled_action_arn: ~x"./ScheduledActionARN/text()"s,
        scheduled_action_name: ~x"./ScheduledActionName/text()"s,
        start_time: ~x"./StartTime/text()"s
      ]
    end

    defp scaling_activities_xml_description do
      [
        ~x"./DescribeScalingActivitiesResult/Activities/member"l,
        activity_id: ~x"./ActivityId/text()"s,
        auto_scaling_group_name: ~x"./AutoScalingGroupName/text()"s,
        cause: ~x"./Cause/text()"s,
        description: ~x"./Description/text()"s,
        details: ~x"./Details/text()"s,
        end_time: ~x"./EndTime/text()"s,
        progress: ~x"./Progress/text()"oi,
        start_time: ~x"./StartTime/text()"s,
        status_code: ~x"./StatusCode/text()"s,
        status_message: ~x"./StatusMessage/text()"s
      ]
    end

    defp scaling_policies_xml_description do
      [
        ~x"./DescribePoliciesResult/ScalingPolicies/member"l,
        adjustment_type: ~x"./AdjustmentType/text()"s,
        alarms: [
          ~x"./Alarms/member"l,
          alarm_name: ~x"./AlarmName/text()"s,
          alarm_arn: ~x"./AlarmARN/text()"s
        ],
        auto_scaling_group_name: ~x"./AutoScalingGroupName/text()"s,
        cooldown: ~x"./Cooldown/text()"oi,
        estimated_instance_warmup: ~x"./EstimatedInstanceWarmup/text()"oi,
        metric_aggregation_type: ~x"./MetricAggregationType/text()"s,
        min_adjustment_magnitude: ~x"./MinAdjustmentMagnitude/text()"oi,
        min_adjustment_step: ~x"./MinAdjustmentStep/text()"oi,
        policy_arn: ~x"./PolicyARN/text()"s,
        policy_name: ~x"./PolicyName/text()"s,
        policy_type: ~x"./PolicyType/text()"s,
        scaling_adjustment: ~x"./ScalingAdjustment/text()"oi,
        step_adjustments: [
          ~x"./StepAdjustments.member"l,
          metric_interval_lower_bound: ~x"./MetricIntervalLowerBound/text()"s,
          metric_interval_upper_bound: ~x"./MetricIntervalUpperBound/text()"s,
          scaling_adjustment: ~x"./ScalingAdjustment/text()"oi
        ],
        target_tracking_configuration: [
          ~x"./TargetTrackingConfiguration"l,
          customized_metric_specification: [
            ~x"./CustomizedMetricSpecification"l,
            dimensions: [
              ~x"./Dimensions.member"l,
              name: ~x"./Name/text()"s,
              value: ~x"./Value/text()"s
            ],
            metric_name: ~x"./MetricName/text()"s,
            namespace: ~x"./Namespace/text()"s,
            statistic: ~x"./Statistic/text()"s,
            unit: ~x"./Unit/text()"s
          ],
          disable_scale_in:
            ~x"./DisableScaleIn/text()"s |> SweetXml.transform_by(&ParseTransforms.to_boolean/1),
          predefined_metric_specification: [
            ~x"./PredefinedMetricSpecification"l,
            predefined_metric_type: ~x"./PredefinedMetricType/text()"s,
            resource_label: ~x"./ResourceLabel/text()"s
          ],
          target_value: ~x"./TargetValue/text()"s
        ]
      ]
    end

    defp notification_configurations_xml_description do
      [
        ~x"./DescribeNotificationConfigurationsResult/NotificationConfigurations/member"l,
        auto_scaling_group_name: ~x"./AutoScalingGroupName/text()"s,
        notification_type: ~x"./NotificationType/text()"s,
        topic_arn: ~x"./TopicARN/text()"s
      ]
    end

    defp load_balancer_target_groups_xml_description do
      [
        ~x"./DescribeLoadBalancerTargetGroupsResult/LoadBalancerTargetGroups/member"l,
        load_balancer_target_group_arn: ~x"./LoadBalancerTargetGroupARN/text()"s,
        state: ~x"./State/text()"s
      ]
    end

    defp load_balancers_xml_description do
      [
        ~x"./DescribeLoadBalancersResult/LoadBalancers/member"l,
        load_balancer_name: ~x"./LoadBalancerName/text()"s,
        state: ~x"./State/text()"s
      ]
    end

    defp lifecycle_hooks_xml_description do
      [
        ~x"./DescribeLifecycleHooksResult/LifecycleHooks/member"l,
        auto_scaling_group_name: ~x"./AutoScalingGroupName/text()"s,
        default_result: ~x"./DefaultResult/text()"s,
        global_timeout: ~x"./GlobalTimeout/text()"oi,
        heartbeat_timeout: ~x"./HeartbeatTimeout/text()"oi,
        lifecycle_hook_name: ~x"./LifecycleHookName/text()"s,
        lifecycle_transition: ~x"./LifecycleTransition/text()"s,
        notification_metadata: ~x"./NotificationMetadata/text()"s,
        notification_target_arn: ~x"./NotificationTargetARN/text()"s,
        role_arn: ~x"./RoleARN/text()"s
      ]
    end

    defp launch_configurations_xml_description do
      [
        ~x"./DescribeLaunchConfigurationsResult/LaunchConfigurations/member"l,
        associate_public_ip_address: ~x"./AssociatePublicIpAddress/text()"s,
        block_device_mappings: [
          ~x"./BlockDeviceMappings/member"l,
          device_name: ~x"./DeviceName/text()"s,
          ebs: [
            ~x"./Ebs"l,
            delete_on_termination:
              ~x"./DeleteOnTermination/text()"s
              |> SweetXml.transform_by(&ParseTransforms.to_boolean/1),
            encrypted:
              ~x"./Encrypted/text()"s |> SweetXml.transform_by(&ParseTransforms.to_boolean/1),
            iops: ~x"./Iops/text()"oi,
            snapshot_id: ~x"./SnapshotId/text()"s,
            volume_size: ~x"./VolumeSize/text()"oi,
            volume_type: ~x"./VolumeType/text()"s
          ],
          no_device: ~x"./NoDevice/text()"s,
          virtual_name: ~x"./VirtualName/text()"s
        ],
        classic_link_vpc_id: ~x"./ClassicLinkVPCId/text()"s,
        classic_link_vpc_security_groups: [
          ~x"./ClassicLinkVPCSecurityGroups/member"l,
          id: ~x"./text()"s
        ],
        created_time: ~x"./CreatedTime/text()"s,
        ebs_optimized: ~x"./EbsOptimized/text()"s,
        iam_instance_profile: ~x"./IamInstanceProfile/text()"s,
        image_id: ~x"./ImageId/text()"s,
        instance_monitoring_enabled: ~x"./InstanceMonitoring/Enabled/text()"s,
        instance_type: ~x"./InstanceType/text()"s,
        kernel_id: ~x"./KernelId/text()"s,
        key_name: ~x"./KeyName/text()"s,
        launch_configuration_arn: ~x"./LaunchConfigurationARN/text()"s,
        launch_configuration_name: ~x"./LaunchConfigurationName/text()"s,
        placement_tenancy: ~x"./PlacementTenancy/text()"s,
        ramdisk_id: ~x"./RamdiskId/text()"s,
        security_groups: [
          ~x"./SecurityGroups.member"l,
          id: ~x"./text()"s
        ],
        spot_price: ~x"./SpotPrice/text()"s,
        user_data: ~x"./UserData/text()"s
      ]
    end

    defp auto_scaling_instances_xml_description do
      [
        ~x"./DescribeAutoScalingInstancesResult/AutoScalingInstances/member"l,
        auto_scaling_group_name: ~x"./AutoScalingGroupName/text()"s,
        availability_zone: ~x"./AvailabilityZone/text()"s,
        health_status: ~x"./HealthStatus/text()"s,
        instance_id: ~x"./InstanceId/text()"s,
        launch_configuration_name: ~x"./LaunchConfigurationName/text()"s,
        launch_template: [
          ~x"./LaunchTemplate/LaunchTemplateSpecification"l,
          template_name: ~x"./LaunchTemplateName/text()"s,
          version: ~x"./Version/text()"s,
          launch_template_id: ~x"./LaunchTemplateId/text()"s
        ],
        life_cycle_state: ~x"./LifecycleState/text()"s,
        protected_from_scale_in:
          ~x"./ProtectedFromScaleIn/text()"s
          |> SweetXml.transform_by(&ParseTransforms.to_boolean/1)
      ]
    end

    defp auto_scaling_groups_xml_description do
      [
        ~x"./DescribeAutoScalingGroupsResult/AutoScalingGroups/member"l,
        auto_scaling_group_arn: ~x"./AutoScalingGroupARN/text()"s,
        auto_scaling_group_name: ~x"./AutoScalingGroupName/text()"s,
        availability_zones:
          ~x".//AvailabilityZones/member/text()"l
          |> SweetXml.transform_by(&ParseTransforms.to_list/1),
        created_time: ~x"./CreatedTime/text()"s,
        default_cooldown: ~x"./DefaultCooldown/text()"i,
        desired_capacity: ~x"./DesiredCapacity/text()"i,
        enabled_metrics: [
          ~x"./EnabledMetrics/member"l,
          granularity: ~x"./Granularity/text()"s,
          metric: ~x"./Metric/text()"s
        ],
        health_check_grace_period: ~x"./HealthCheckGracePeriod/text()"Io,
        health_check_type: ~x"./HealthCheckType/text()"s,
        instances: [
          ~x"./Instances/member"l,
          availability_zone: ~x"./AvailabilityZone/text()"s,
          health_status: ~x"./HealthStatus/text()"s,
          instance_id: ~x"./InstanceId/text()"s,
          launch_configuration_name: ~x"./LaunchConfigurationName/text()"s,
          launch_template:
            ~x"./LaunchTemplate"
            |> SweetXml.transform_by(&to_launch_template/1),
          life_cycle_state: ~x"./LifecycleState/text()"s,
          protected_from_scale_in:
            ~x"./ProtectedFromScaleIn/text()"s
            |> SweetXml.transform_by(&ParseTransforms.to_boolean/1)
        ],
        mixed_instances_policy: [
          ~x"./MixedInstancesPolicy"l,
          instances_distribution: [
            ~x"./InstancesDistribution"l,
            spot_allocation_strategy: ~x"./SpotAllocationStrategy/text()"s,
            on_demand_percentage_above_base_capacity:
              ~x"./OnDemandPercentageAboveBaseCapacity/text()"s,
            on_demand_allocation_stategy: ~x"./OnDemandAllocationStrategy/text()"s,
            spot_instance_pools: ~x"./SpotInstancePools/text()"Io,
            on_demand_capacity: ~x"./OnDemandBaseCapacity/text()"Io
          ],
          launch_template: [
            ~x"./LaunchTemplate/LaunchTemplateSpecification"l,
            template_name: ~x"./LaunchTemplateName/text()"s,
            version: ~x"./Version/text()"s,
            launch_template_id: ~x"./LaunchTemplateId/text()"s
          ]
        ],
        load_balancer_names:
          ~x"./LoadBalancerNames/member/text()"l
          |> SweetXml.transform_by(&ParseTransforms.to_list/1),
        max_size: ~x"./MaxSize/text()"Io,
        min_size: ~x"./MinSize/text()"Io,
        new_instances_protected_from_scale_in:
          ~x"./NewInstancesProtectedFromScaleIn/text()"s
          |> SweetXml.transform_by(&ParseTransforms.to_boolean/1),
        placement_group: ~x"./PlacementGroup/text()"s,
        service_linked_role_arn: ~x"./ServiceLinkedRoleARN/text()"s,
        status: ~x"./Status/text()"s,
        suspended_processes: [
          ~x"./SuspendedProcesses.member"l,
          process_name: ~x"./ProcessName/text()"s,
          suspension_reason: ~x"./SuspensionReason/text()"s
        ],
        tags: [
          ~x"./Tags/member"l,
          key: ~x"./Key/text()"s,
          propogate_at_launch: ~x"./PropagateAtLaunch/text()"s,
          resource_id: ~x"./ResourceId/text()"s,
          resource_type: ~x"./ResourceType/text()"s,
          value: ~x"./Value/text()"s
        ],
        target_group_arns:
          ~x"./TargetGroupARNs/member/text()"l
          |> SweetXml.transform_by(&ParseTransforms.to_list/1),
        termination_policies:
          ~x"./TerminationPolicies/member/text()"l
          |> SweetXml.transform_by(&ParseTransforms.to_list/1),
        vpc_zone_identifier: ~x"./VPCZoneIdentifier/text()"s
      ]
    end
  end
else
  defmodule ExAws.AutoScaling.Parsers do
    def parse(val, _), do: val
  end
end
