defmodule ExAws.AutoScaling do
  @moduledoc """
    Operations on AWS EC2 Auto Scaling
  """
  # Help with formatting requests
  @special_formatting %{
    target_group_arns: "TargetGroupARNs",
    classic_link_vpc_id: "ClassicLinkVPCId",
    classic_link_vpc_security_groups: "ClassicLinkVPCSecurityGroups",
    notification_target_arn: "NotificationTargetARN",
    role_arn: "RoleARN",
    service_linked_role_arn: "ServiceLinkedRoleARN",
    topic_arn: "TopicARN",
    values: "Values.member"
  }

  @member_actions [
    :auto_scaling_group_names,
    :availability_zones,
    :classic_link_vpc_security_groups,
    :filters,
    :instance_ids,
    :launch_configuration_names,
    :lifecycle_hook_names,
    :load_balancer_names,
    :metrics,
    :notification_types,
    :scheduled_action_names,
    :scheduled_update_group_actions,
    :security_groups,
    :target_group_arns
  ]

  use ExAws.Utils,
    format_type: :xml,
    non_standard_keys: @special_formatting

  # version of the AWS API
  @version "2011-01-01"

  @typedoc """
    The optional parameters when calling `describe_auto_scaling_groups/1`

  ## Keys

  * auto_scaling_group_names (`List` of `String`) - The names of the Auto Scaling groups.
  Each name can be a maximum of 1600 characters. By default, you can only specify up
  to 50 names. You can optionally increase this limit using the MaxRecords parameter.
  If you omit this parameter, all Auto Scaling groups are described.

  * max_records (`Integer`) - The maximum number of items to return with this call. The
  default value is 50 and the maximum value is 100.

  * next_token (`String`) - The token for the next set of items to return. (You received
  this token from a previous call.)
  """
  @type describe_auto_scaling_groups_opts :: [
          auto_scaling_group_names: [binary, ...],
          max_records: integer,
          next_token: binary
        ]

  @typedoc """
    Describes one or more scheduled scaling action updates for a specified
    Auto Scaling group. Used in combination with `batch_put_scheduled_update_group_action/2`.

  ## Keys

    * desired_capacity (`Integer`) - The number of EC2 instances that should be running in the group.

    * end_time (`String`) - The time for the recurring schedule to end. Amazon EC2 Auto Scaling
    does not perform the action after this time.

    * max_size (`Integer`) - The maximum size of the group.

    * min_size (`Integer`) - The minimum size of the group.

    * recurrence (`String`) - The recurring schedule for the action, in Unix cron syntax format.
    This format consists of five fields separated by white spaces:
    [Minute] [Hour] [Day_of_Month] [Month_of_Year] [Day_of_Week].
    The value must be in quotes (for example, "30 0 1 1,6,12 *"). For more information about
    this format, see Crontab.

    * start_time (`String`) - The time for the action to start, in YYYY-MM-DDThh:mm:ssZ
    format in UTC/GMT only and in quotes (for example, "2019-06-01T00:00:00Z").
    If you specify recurrence and start_time, Amazon EC2 Auto Scaling performs the action
    at this time, and then performs the action based on the specified recurrence.
    If you try to schedule the action in the past, Amazon EC2 Auto Scaling returns an
    error message.

    * scheduled_action_name (`String`) - The name of the scaling action.
  """
  @type scheduled_update_group_action_request :: [
          desired_capacity: integer,
          end_time: binary,
          max_size: integer,
          min_size: integer,
          recurrence: binary,
          start_time: binary,
          scheduled_action_name: binary
        ]

  @typedoc """
    The optional parameters when calling `complete_life_cycle_action/4`

  ## Members

    * lifecycle_action_token (`String`) - A universally unique identifier (UUID) that
    identifies a specific lifecycle action associated with an instance. Amazon EC2
    Auto Scaling sends this token to the notification target you specified when you
    created the lifecycle hook.

    * instance_id (`String`) - The ID of the instance.
  """
  @type complete_life_cycle_action_opts :: [
          lifecycle_action_token: binary,
          instance_id: binary
        ]

  @typedoc """
    Describes a launch template and the launch template version

    The launch template that is specified must be configured for use with an Auto
    Scaling group. For more information, see Creating a Launch Template for an Auto
    Scaling group in the Amazon EC2 Auto Scaling User Guide.

  ## Keys

    * launch_template_id (`String`) - The ID of the launch template. You must specify
    either a template ID or a template name.

    * launch_template_name (`String`) - The name of the launch template. You must specify
    either a template name or a template ID.

    * version (`String`) - The version number, "$Latest", or "$Default". If the value is
    "$Latest", Amazon EC2 Auto Scaling selects the latest version of the launch template
    when launching instances. If the value is "$Default", Amazon EC2 Auto Scaling selects
    the default version of the launch template when launching instances. The default value
    is "$Default".
  """
  @type launch_template_specification :: [
          launch_template_id: binary,
          launch_template_name: binary,
          version: binary
        ]

  @typedoc """
    Describes a lifecycle hook, which tells Amazon EC2 Auto Scaling that you
    want to perform an action whenever it launches instances or whenever it
    terminates instances.

    Used in combination with `create_auto_scaling_group/3`. For more information,
    see Amazon EC2 Auto Scaling Lifecycle Hooks in the Amazon EC2 Auto Scaling
    User Guide.

  ## Keys

    * default_result (`String`) - Defines the action the Auto Scaling group
    should take when the lifecycle hook timeout elapses or if an unexpected
    failure occurs. The valid values are "CONTINUE" and "ABANDON".

    * heartbeat_timeout (`Integer`) - The maximum time, in seconds, that can
    elapse before the lifecycle hook times out. If the lifecycle hook times
    out, Amazon EC2 Auto Scaling performs the action that you specified in the
    default_result parameter. You can prevent the lifecycle hook from timing
    out by calling `record_lifecycle_action_heartbeat/2`.

    * lifecycle_hook_name (`String`) - The name of the lifecycle hook.

    * lifecycle_transition (`String`) - The state of the EC2 instance to which you
    want to attach the lifecycle hook. The possible values are:
    "autoscaling:EC2_INSTANCE_LAUNCHING" | "autoscaling:EC2_INSTANCE_TERMINATING"

    * notification_target_arn (`String`) - The ARN of the target that Amazon EC2
    Auto Scaling sends notifications to when an instance is in the transition state
    for the lifecycle hook. The notification target can be either an SQS queue or
    an SNS topic.

    * role_arn (`String`) - The ARN of the IAM role that allows the Auto Scaling group
    to publish to the specified notification target, for example, an Amazon SNS
    topic or an Amazon SQS queue
  """
  @type lifecycle_hook_specification :: [
          default_result: binary,
          heartbeat_timeout: integer,
          lifecycle_hook_name: binary,
          lifecycle_transition: binary,
          notification_target_arn: binary,
          role_arn: binary
        ]

  @typedoc """
    Optional parmeters to `put_lifecycle_hook/3`

  ## Keys

    * default_result (`String`) - Defines the action the Auto Scaling group
    should take when the lifecycle hook timeout elapses or if an unexpected
    failure occurs. The valid values are "CONTINUE" and "ABANDON".

    * heartbeat_timeout (`Integer`) - The maximum time, in seconds, that can
    elapse before the lifecycle hook times out. If the lifecycle hook times
    out, Amazon EC2 Auto Scaling performs the action that you specified in the
    default_result parameter. You can prevent the lifecycle hook from timing
    out by calling `record_lifecycle_action_heartbeat/2`.

    * notification_metadata (`String`) - Contains additional information that
    you want to include any time Amazon EC2 Auto Scaling sends a message to
    the notification target.

    * lifecycle_transition (`String`) - The state of the EC2 instance to which you
    want to attach the lifecycle hook. The possible values are:
    "autoscaling:EC2_INSTANCE_LAUNCHING" | "autoscaling:EC2_INSTANCE_TERMINATING"

    * notification_target_arn (`String`) - The ARN of the target that Amazon EC2
    Auto Scaling sends notifications to when an instance is in the transition state
    for the lifecycle hook. The notification target can be either an SQS queue or
    an SNS topic.

    * role_arn (`String`) - The ARN of the IAM role that allows the Auto Scaling group
    to publish to the specified notification target, for example, an Amazon SNS
    topic or an Amazon SQS queue
  """
  @type put_lifecycle_hook_opts :: [
          default_result: binary,
          heartbeat_timeout: integer,
          lifecycle_transition: binary,
          notification_metadata: binary,
          notification_target_arn: binary,
          role_arn: binary
        ]

  @typedoc """
    Describes an instances distribution for an Auto Scaling group with
    mixed_instances_policy.

  ## Keys

    * on_demand_allocation_strategy (`String`) - Indicates how to allocate instance types to
    fulfill On-Demand capacity. The only valid value is "prioritized", which is also the
    default value. This strategy uses the order of instance type overrides for the
    launch_template to define the launch priority of each instance type. The first instance
    type in the array is prioritized higher than the last. If all your On-Demand capacity
    cannot be fulfilled using your highest priority instance, then the Auto Scaling groups
    launches the remaining capacity using the second priority instance type, and so on.

    * on_demand_base_capacity (`Integer`) - The minimum amount of the Auto Scaling group's
    capacity that must be fulfilled by On-Demand Instances. This base portion is provisioned
    first as your group scales. The default value is 0. If you leave this parameter set to
    0, On-Demand Instances are launched as a percentage of the Auto Scaling group's desired
    capacity, per the on_demand_percentage_above_base_capacity setting.

    * on_demand_percentage_above_base_capacity (`Integer`) - Controls the percentages of On-Demand
    Instances and Spot Instances for your additional capacity beyond on_demand_base_capacity.
    The range is 0–100. The default value is 100. If you leave this parameter set to 100, the
    percentages are 100% for On-Demand Instances and 0% for Spot Instances.

    * spot_allocation_strategy (`String`) - Indicates how to allocate Spot capacity across Spot pools.
    The only valid value is "lowest-price", which is also the default value. The Auto Scaling group
    selects the cheapest Spot pools and evenly allocates your Spot capacity across the number of
    Spot pools that you specify.

    * spot_instance_pools (`Integer`) - The number of Spot pools to use to allocate your Spot capacity.
    The Spot pools are determined from the different instance types in the Overrides array of
    launch_template. The range is 1–20 and the default is 2.

    * spot_max_price (`String`) - The maximum price per unit hour that you are willing to pay for a
    Spot Instance. If you leave the value of this parameter blank (which is the default), the
    maximum Spot price is set at the On-Demand price. To remove a value that you previously set,
    include the parameter but leave the value blank.
  """
  @type instances_distribution :: [
          on_demand_allocation_strategy: binary,
          on_demand_base_capacity: integer,
          on_demand_percentage_above_base_capacity: integer,
          spot_allocation_strategy: binary,
          spot_instance_pools: integer,
          spot_max_price: binary
        ]

  @typedoc """
    Describes an override for a launch template

    instance_type (String - The instance type. For information about available instance
    types, see Available Instance Types in the Amazon Elastic Compute Cloud User Guide.
  """
  @type launch_template_overrides :: [
          instance_type: binary
        ]

  @typedoc """
    Describes a launch template and overrides

    The overrides are used to override the instance type specified by the launch template
    with multiple instance types that can be used to launch On-Demand Instances and
    Spot Instances.

  ## Keys

    * launch_template_specification (`t:launch_template_specification/0` - The launch
    template to use. You must specify either the launch template ID or launch template
    name in the request.

    * overrides (`List` of `t:launch_template_overrides/0` - Any parameters that you
    specify override the same parameters in the launch template. Currently, the only
    supported override is instance type
  """
  @type launch_template :: [
          launch_template_specification: launch_template_specification,
          overrides: [launch_template_overrides, ...]
        ]

  @typedoc """
    Describes a mixed instances policy for an Auto Scaling group

    With mixed instances, your Auto Scaling group can provision a combination of On-Demand
    Instances and Spot Instances across multiple instance types. For more information, see
    Using Multiple Instance Types and Purchase Options in the Amazon EC2 Auto Scaling
    User Guide.

    When you create your Auto Scaling group, you can specify a launch configuration or
    template as a parameter for the top-level object, or you can specify a mixed instances
    policy, but not both at the same time.

  ## Keys

    * instances_distribution (`t:instances_distribution/0`) - The instances distribution to
    use. If you leave this parameter unspecified when creating the group, the default values
    are used.

    * launch_template (`t:launch_template/0`) - The launch template and overrides. This
    parameter is required when creating an Auto Scaling group with a mixed instances policy,
    but is not required when updating the group.
  """
  @type mixed_instances_policy :: [
          instances_distribution: instances_distribution,
          launch_template: launch_template
        ]

  @typedoc """
    Describes a tag for an Auto Scaling group.

  ## Keys

    * key (`String`) - The tag key. Length Constraints: Minimum length of 1. Maximum length of 128.
    Required.

    * propagate_at_launch (boolean) - Determines whether the tag is added to new instances as
    they are launched in the group.

    * resource_id (`String`) - The name of the group.

    * resource_type (`String`) - The type of resource. The only supported value is "auto-scaling-group".

    * value (`String`) - The tag value. Length Constraints: Minimum length of 0. Maximum length of 256.

  """
  @type tag :: [
          key: binary,
          propogate_at_launch: boolean,
          resource_id: binary,
          resource_type: binary,
          value: binary
        ]

  @typedoc """
    The optional parameters when calling `create_auto_scaling_group/4`

  ## Keys

    * availability_zones (`List`) - One or more Availability Zones for
    the group. This parameter is optional if you specify one
    or more subnets. Minimum number of 1 item. Maximum number
    is 255.

    * default_cool_down (`Integer`) - The amount of time, in seconds,
    after a scaling activity completes before another scaling
    activity can start. The default value is 300.

    * desired_capacity (`Integer`) - The number of EC2 instances that
    should be running in the group. This number must be greater than
    or equal to the minimum size of the group and less than or equal
    to the maximum size of the group. If you do not specify a desired
    capacity, the default is the minimum size of the group.

    * health_check_grace_period (`Integer`) - The amount of time, in seconds,
    that Amazon EC2 Auto Scaling waits before checking the health status of
    an EC2 instance that has come into service. During this time, any health
    check failures for the instance are ignored. The default value is 0.
    This parameter is required if you are adding an ELB health check.

    * health_check_type (`String`) - The service to use for the health checks.
    The valid values are "EC2" and "ELB".

    * launch_configuration_name (`String`) - The name of the launch configuration.
    This parameter, a launch template, a mixed instances policy, or an EC2
    instance must be specified.

    * launch_template (`t:launch_template_specification/0`) - The launch template
    to use to launch instances. This parameter, a launch configuration, a mixed
    instances policy, or an EC2 instance must be specified.

    * lifecycle_hook_specification_list (`List` of
    `t:lifecycle_hook_specification/0`) - One or more lifecycle hooks.

    * load_balancer_names (`List` of `String`) - One or more Classic Load Balancers.
    To specify an Application Load Balancer or a Network Load Balancer, use
    target_group_arns instead.

    * mixed_instances_policy (`t:mixed_instances_policy/0`) - The mixed instances policy
    to use to launch instances. This parameter, a launch template, a launch configuration,
    or an EC2 instance must be specified.

    * new_instances_protected_from_scale_in (boolean) - Indicates whether newly launched
    instances are protected from termination by Auto Scaling when scaling in.
    For more information about preventing instances from terminating on scale in, see
    Instance Protection in the Amazon EC2 Auto Scaling User Guide.

    * placement_group (`String`) - The name of the placement group into which to launch
    your instances, if any. For more information, see Placement Groups in the Amazon
    EC2 User Guide for Linux Instances.

    * service_linked_role_arn (`String`) - The Amazon Resource Name (ARN) of the
    service-linked role that the Auto Scaling group uses to call other AWS services
    on your behalf. By default, Amazon EC2 Auto Scaling uses a service-linked role
    named AWSServiceRoleForAutoScaling, which it creates if it does not exist. For
    more information, see Service-Linked Roles in the Amazon EC2 Auto Scaling User
    Guide.

    * tags (`List` of `t:tag/0`) - One or more tags

    * target_group_arns (`List` of `String`) - The Amazon Resource Names (ARN) of the
    target groups.

    * termination_policies (`List` of `String`) - One or more termination policies used
    to select the instance to terminate. These policies are executed in the order that
    they are listed. For more information, see "Controlling Which Instances Auto Scaling
    Terminates During Scale In" in the Amazon EC2 Auto Scaling User Guide.

    * vpc_zone_identifier (`String`) - A comma-separated list of subnet identifiers for
    your virtual private cloud (VPC)
  """
  @type create_auto_scaling_group_opts :: [
          availability_zones: [binary, ...],
          default_cool_down: integer,
          desired_capacity: integer,
          health_check_grace_period: integer,
          health_check_type: binary,
          instance_id: binary,
          launch_configuration_name: binary,
          launch_template: launch_template_specification,
          lifecycle_hook_specification_list: [lifecycle_hook_specification, ...],
          load_balancer_names: [binary, ...],
          mixed_instances_policy: mixed_instances_policy,
          new_instances_protected_from_scale_in: boolean,
          placement_group: binary,
          service_linked_role_arn: binary,
          tags: [tag, ...],
          target_group_arns: [binary, ...],
          termination_policies: [binary, ...],
          vpc_zone_identifier: binary
        ]

  @typedoc """
    The optional parameters when calling `update_auto_scaling_group/2`

  ## Keys

    * availability_zones (`List`) - One or more Availability Zones for
    the group. This parameter is optional if you specify one
    or more subnets. Minimum number of 1 item. Maximum number
    is 255.

    * default_cool_down (`Integer`) - The amount of time, in seconds,
    after a scaling activity completes before another scaling
    activity can start. The default value is 300.

    * desired_capacity (`Integer`) - The number of EC2 instances that
    should be running in the group. This number must be greater than
    or equal to the minimum size of the group and less than or equal
    to the maximum size of the group. If you do not specify a desired
    capacity, the default is the minimum size of the group.

    * health_check_grace_period (`Integer`) - The amount of time, in seconds,
    that Amazon EC2 Auto Scaling waits before checking the health status of
    an EC2 instance that has come into service. During this time, any health
    check failures for the instance are ignored. The default value is 0.
    This parameter is required if you are adding an ELB health check.

    * health_check_type (`String`) - The service to use for the health checks.
    The valid values are "EC2" and "ELB".

    * launch_configuration_name (`String`) - The name of the launch configuration.
    If you specify this parameter, you can't specify a launch template or a mixed
    instances policy.

    * launch_template (`t:launch_template_specification/0`) - The launch template
    and version to use to specify the updates. If you specify this parameter,
    you can't specify a launch configuration or a mixed instances policy

    * max_size (`Integer`) - The maximum size of the Auto Scaling group.

    * min_size (`Integer`) - The minimum size of the Auto Scaling group.

    * mixed_instances_policy - The mixed instances policy to use to launch instances.
    This parameter, a launch template, a launch configuration, or an EC2 instance
    must be specified.

    * new_instances_protected_from_scale_in (boolean) - Indicates whether newly launched
    instances are protected from termination by Auto Scaling when scaling in.
    For more information about preventing instances from terminating on scale in, see
    Instance Protection in the Amazon EC2 Auto Scaling User Guide.

    * placement_group (`String`) - The name of the placement group into which to launch
    your instances, if any. For more information, see Placement Groups in the Amazon
    EC2 User Guide for Linux Instances.

    * service_linked_role_arn (`String`) - The Amazon Resource Name (ARN) of the service-linked
    role that the Auto Scaling group uses to call other AWS services on your behalf. By default,
    Amazon EC2 Auto Scaling uses a service-linked role named AWSServiceRoleForAutoScaling,
    which it creates if it does not exist. For more information, see Service-Linked Roles in
    the Amazon EC2 Auto Scaling User Guide.

    * termination_policies (`List` of String) - One or more termination policies used
    to select the instance to terminate. These policies are executed in the order that
    they are listed. For more information, see "Controlling Which Instances Auto Scaling
    Terminates During Scale In" in the Amazon EC2 Auto Scaling User Guide.

    * vpc_zone_identifier (`String`) - A comma-separated list of subnet identifiers for your
    virtual private cloud (VPC)
  """
  @type update_auto_scaling_group_opts :: [
          availability_zones: [binary, ...],
          default_cool_down: integer,
          desired_capacity: integer,
          health_check_grace_period: integer,
          health_check_type: binary,
          instance_id: binary,
          launch_configuration_name: binary,
          launch_template: launch_template_specification,
          lifecycle_hook_specification_list: [lifecycle_hook_specification, ...],
          max_size: integer,
          min_size: integer,
          mixed_instances_policy: mixed_instances_policy,
          new_instances_protected_from_scale_in: boolean,
          placement_group: binary,
          service_linked_role_arn: binary,
          termination_policies: [binary, ...],
          vpc_zone_identifier: binary
        ]

  @typedoc """
    Describes an Amazon EBS volume. Used in combination with `t:block_device_mapping/0`

  ## Keys

    * delete_on_termination (boolean) - Indicates whether the volume is deleted on
    instance termination. The default value is true.

    * encrypted (boolean) - Specifies whether the volume should be encrypted.
    Encrypted EBS volumes must be attached to instances that support Amazon EBS
    encryption. Volumes that are created from encrypted snapshots are automatically
    encrypted. There is no way to create an encrypted volume from an unencrypted
    snapshot or an unencrypted volume from an encrypted snapshot. If your AMI uses
    encrypted volumes, you can only launch it on supported instance types. For more
    information, see Amazon EBS Encryption in the Amazon EC2 User Guide for Linux Instances.

    * iops (`Integer`) - The number of I/O operations per second (IOPS) to provision for
    the volume. For more information, see Amazon EBS Volume Types in the Amazon EC2 User
    Guide for Linux Instances. Constraint: Required when the volume type is io1. (Not
    used with standard, gp2, st1, or sc1 volumes.) Valid Range: Minimum value of 100.
    Maximum value of 20000.

    * snapshot_id (`String`) - The ID of the snapshot. This parameter is optional if you
    specify a volume size.

    * volume_size (`Integer`) - The volume size, in GiB. Constraints: 1-1,024 for standard,
    4-16,384 for io1, 1-16,384 for gp2, and 500-16,384 for st1 and sc1. If you specify a
    snapshot, the volume size must be equal to or larger than the snapshot size.
    Default: If you create a volume from a snapshot and you don't specify a volume size,
    the default is the snapshot size. Valid Range: Minimum value of 1. Maximum value of 16384.

    * volume_type (`String`) - The volume type, which can be "standard" for Magnetic, "io1" for
    Provisioned IOPS SSD, "gp2" for General Purpose SSD, "st1" for Throughput Optimized HDD,
    or "sc1" for Cold HDD. For more information, see Amazon EBS Volume Types in the Amazon
    EC2 User Guide for Linux Instances.
  """
  @type ebs :: [
          delete_on_termination: boolean,
          encrypted: boolean,
          iops: integer,
          snapshot_id: binary,
          volume_size: integer,
          volume_type: binary
        ]

  @typedoc """
    Describes a block device mapping.

  ## Keys

    * device_name (`String`) - The device name exposed to the EC2 instance (for
    example, /dev/sdh or xvdh). For more information, see Device Naming on Linux
    Instances in the Amazon EC2 User Guide for Linux Instances.

    * ebs (`t:ebs/0`) - The information about the Amazon EBS volume.

    * no_device (boolean) - Suppresses a device mapping. If this parameter is true for
    the root device, the instance might fail the EC2 health check. In that case,
    Amazon EC2 Auto Scaling launches a replacement instance.

    * virtual_name (`String`) - The name of the virtual device (for example, ephemeral0).
  """
  @type block_device_mapping :: [
          device_name: binary,
          ebs: ebs,
          no_device: boolean,
          virtual_name: binary
        ]

  @typedoc """
    The optional parameters when calling `create_launch_configuration/2`

  ## Keys

    * associate_public_ip_address (boolean) - Used for groups that launch instances into a virtual
    private cloud (VPC). Specifies whether to assign a public IP address to each instance.
    For more information, see Launching Auto Scaling Instances in a VPC in the Amazon EC2
    Auto Scaling User Guide. If you specify this parameter, be sure to specify at least
    one subnet when you create your group. Default: If the instance is launched into a
    default subnet, the default is to assign a public IP address. If the instance is launched
    into a nondefault subnet, the default is not to assign a public IP address.

    * block_device_mappings (`List` of `t:block_device_mapping/0`) - One or more mappings that
    specify how block devices are exposed to the instance. For more information, see Block
    Device Mapping in the Amazon EC2 User Guide for Linux Instances.

    * classic_link_vpc_id (`String`) - The ID of a ClassicLink-enabled VPC to link your EC2-Classic
    instances to. This parameter is supported only if you are launching EC2-Classic instances. For
    more information, see ClassicLink in the Amazon EC2 User Guide for Linux Instances and Linking
    EC2-Classic Instances to a VPC in the Amazon EC2 Auto Scaling User Guide.

    * classic_link_vpc_security_groups (`List` of `String`) - The IDs of one or more security groups
    for the specified ClassicLink-enabled VPC. This parameter is required if you specify a
    ClassicLink-enabled VPC, and is not supported otherwise. For more information, see ClassicLink
    in the Amazon EC2 User Guide for Linux Instances and Linking EC2-Classic Instances to a VPC in
    the Amazon EC2 Auto Scaling User Guide.

    * ebs_optimized (boolean) - Indicates whether the instance is optimized for Amazon EBS I/O.
    By default, the instance is not optimized for EBS I/O. The optimization provides dedicated
    throughput to Amazon EBS and an optimized configuration stack to provide optimal I/O performance.
    This optimization is not available with all instance types. Additional usage charges apply.
    For more information, see Amazon EBS-Optimized Instances in the Amazon EC2 User Guide for
    Linux Instances.

    * iam_instance_profile (`String`) - The name or the Amazon Resource Name (ARN) of the instance
    profile associated with the IAM role for the instance. EC2 instances launched with an IAM role
    automatically have AWS security credentials available. You can use IAM roles with Amazon EC2
    Auto Scaling to automatically enable applications running on your EC2 instances to securely
    access other AWS resources. For more information, see Use an IAM Role for Applications That
    Run on Amazon EC2 Instances in the Amazon EC2 Auto Scaling User Guide.

    * image_id (`String`) - The ID of the Amazon Machine Image (AMI) to use to launch your EC2 instances.
    If you do not specify instance_id, you must specify image_id.

    * instance_id (`String`) - The ID of the instance to use to create the launch configuration. The new
    launch configuration derives attributes from the instance, except for the block device mapping.
    If you do not specify instance_id, you must specify both image_id and instance_type.
    To create a launch configuration with a block device mapping or override any other instance
    attributes, specify them as part of the same request. For more information, see Create a Launch
    Configuration Using an EC2 Instance in the Amazon EC2 Auto Scaling User Guide.

    * instance_monitoring (boolean) - Enables detailed monitoring (true) or basic monitoring
    (false) for the Auto Scaling instances. The default value is true.

    * instance_type (`String`) - The instance type of the EC2 instance. If you do not specify instance_id,
    you must specify instance_type. For information about available instance types, see Available Instance
    Types in the Amazon EC2 User Guide for Linux Instances.

    * kernel_id (`String`) - The ID of the kernel associated with the AMI.

    * key_name (`String`) - The name of the key pair. For more information, see Amazon EC2 Key Pairs in
    the Amazon EC2 User Guide for Linux Instances.

    * placement_tenancy (`String`) - The tenancy of the instance. An instance with a tenancy of dedicated
    runs on single-tenant hardware and can only be launched into a VPC. To launch Dedicated Instances
    into a shared tenancy VPC (a VPC with the instance placement tenancy attribute set to default), you
    must set the value of this parameter to dedicated. If you specify this parameter, be sure to specify at
    least one subnet when you create your group. For more information, see Launching Auto Scaling Instances
    in a VPC in the Amazon EC2 Auto Scaling User Guide. Valid values: "default" | "dedicated"

    * ramdisk_id (`String`) - The ID of the RAM disk associated with the AMI.

    * security_groups (`List` of String) - One or more security groups with which to associate the instances.
    If your instances are launched in EC2-Classic, you can either specify security group names or the
    security group IDs. For more information, see Amazon EC2 Security Groups in the Amazon EC2 User Guide
    for Linux Instances. If your instances are launched into a VPC, specify security group IDs. For more
    information, see Security Groups for Your VPC in the Amazon Virtual Private Cloud User Guide.

    * spot_price (`String`) - The maximum hourly price to be paid for any Spot Instance launched to fulfill
    the request. Spot Instances are launched when the price you specify exceeds the current Spot market
    price. For more information, see Launching Spot Instances in Your Auto Scaling Group in the Amazon EC2
    Auto Scaling User Guide.

    * user_data (`String`) - The user data to make available to the launched EC2 instances. For more
    information, see Instance Metadata and User Data in the Amazon EC2 User Guide for Linux Instances.
    This value will be base64 encoded automatically. Do not base64 encode this value prior to performing
    the operation.
  """
  @type create_launch_configuration_opts :: [
          associate_public_ip_address: boolean,
          block_device_mappings: [block_device_mapping, ...],
          classic_link_vpc_id: binary,
          classic_link_vpc_security_groups: [binary, ...],
          ebs_optimized: boolean,
          iam_instance_profile: binary,
          image_id: binary,
          instance_id: binary,
          instance_monitoring: boolean,
          instance_type: binary,
          kernel_id: binary,
          key_name: binary,
          placement_tenancy: binary,
          ramdisk_id: binary,
          security_groups: [binary, ...],
          spot_price: binary,
          user_data: binary
        ]

  @typedoc """
   The optional parameters when calling `delete_auto_scaling_group/2`

  ## Keys

    * force_delete (boolean) - Specifies that the group is to be deleted
    along with all instances associated with the group, without waiting for
    all instances to be terminated. This parameter also deletes any lifecycle
    actions associated with the group.
  """
  @type delete_auto_scaling_group_opts :: [
          force_delete: boolean
        ]

  @typedoc """
   The optional parameters when calling `delete_policy/2`

  ## Keys

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group
  """
  @type delete_policy_opts :: [
          auto_scaling_group_name: binary
        ]

  @typedoc """
    The optional parameters when calling `describe_auto_scaling_instances/1`

  ## Keys

    * instance_ids (`List` of `String`) - The IDs of the instances. You can
    specify up to max_records IDs. If you omit this parameter, all Auto Scaling
    instances are described. If you specify an ID that does not exist, it is
    ignored with no error.

    * max_records (`Integer`) - The maximum number of items to return with
    this call. The default value is 50 and the maximum value is 50.

    * next_token (`String`) - The token for the next set of items to return.
    (You received this token from a previous call.)
  """
  @type describe_auto_scaling_instances_opts :: [
          instance_ids: [binary, ...],
          max_records: integer,
          next_token: binary
        ]

  @typedoc """
   The optional parameters when calling `describe_launch_configurations/1`

  ## Keys

    * launch_configuration_names (`List` of `String`) - The launch configuration names. If
    you omit this parameter, all launch configurations are described.

    * max_records (`Integer`) - The maximum number of items to return with this call. The
    default value is 50 and the maximum value is 100.

    * next_token (`String`) - The token for the next set of items to return. (You received
    this token from a previous call.)
  """
  @type describe_launch_configurations_opts :: [
          launch_configuration_names: [binary, ...],
          max_records: integer,
          next_token: binary
        ]

  @typedoc """
   The optional parameters when calling `describe_lifecycle_hooks/2`

  ## Keys

    * lifecycle_hook_names (`List` of `String`) - The names of one or more lifecycle
    hooks. If you omit this parameter, all lifecycle hooks are described.

  """
  @type describe_lifecycle_hooks_opts :: [
          lifecycle_hook_names: [binary, ...]
        ]

  @typedoc """
   The optional parameters when calling `describe_load_balancers/2`

  ## Keys

    * max_records (`Integer`) - The maximum number of items to return with this call. The
    default value is 50 and the maximum value is 100.

    * next_token (`String`) - The token for the next set of items to return. (You received
    this token from a previous call.)
  """
  @type paging_opts :: [
          max_records: integer,
          next_token: binary
        ]

  @typedoc """
   The optional parameters when calling `describe_notification_configurations/1`

  ## Keys

    * auto_scaling_group_names (`List` of String) - The name of the Auto Scaling group

    * max_records (`Integer`) - The maximum number of items to return with this call. The
    default value is 50 and the maximum value is 100.

    * next_token (`String`) - The token for the next set of items to return. (You received
    this token from a previous call.)
  """
  @type describe_notification_configurations_opts :: [
          auto_scaling_group_names: [binary, ...],
          max_records: integer,
          next_token: binary
        ]

  @typedoc """
    The optional parameters when calling `describe_policies/1`

  ## Keys

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * max_records (`Integer`) - The maximum number of items to return with this call. The
    default value is 50 and the maximum value is 100.

    * next_token (`String`) - The token for the next set of items to return. (You received
    this token from a previous call.)
  """
  @type describe_policies_opts :: [
          auto_scaling_group_name: binary,
          max_records: integer,
          next_token: binary
        ]

  @typedoc """
    The optional parameters when calling `describe_scaling_activities/1`


  ## Keys

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * max_records (`Integer`) - The maximum number of items to return with this call. The
    default value is 50 and the maximum value is 100.

    * next_token (`String`) - The token for the next set of items to return. (You received
    this token from a previous call.)
  """
  @type describe_scaling_activities_opts :: [
          auto_scaling_group_name: binary,
          max_records: integer,
          next_token: binary
        ]

  @typedoc """
   The optional parameters when calling `describe_scheduled_actions/1`

  ## Keys

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * end_time (`String`) - The latest scheduled start time to return. If
    scheduled action names are provided, this parameter is ignored.

    * max_records (`Integer`) - The maximum number of items to return with this call. The
    default value is 50 and the maximum value is 100.

    * next_token (`String`) - The token for the next set of items to return. (You received
    this token from a previous call.)

    * scheduled_action_names (`List` of String) - The names of one or more scheduled
    actions. You can specify up to 50 actions. If you omit this parameter, all
    scheduled actions are described. If you specify an unknown scheduled action,
    it is ignored with no error.

    * start_time (`String`) - The earliest scheduled start time to return. If
    scheduled action names are provided, this parameter is ignored.
  """
  @type describe_scheduled_actions_opts :: [
          auto_scaling_group_name: binary,
          end_time: binary,
          max_records: integer,
          next_token: binary,
          scheduled_action_names: [binary, ...],
          start_time: binary
        ]

  @typedoc """
    Describes a filter.

  ## Parameters

    * name (`String`) - The name of the filter. The valid values are:
    "auto-scaling-group", "key", "value", and "propagate-at-launch".

    * values (`List` of `String`) - The value of the filter.
  """
  @type filter :: [
          name: binary,
          values: [binary, ...]
        ]

  @typedoc """
   The optional parameters when calling `describe_tags/1`

  ## Keys

    * filters (`List` of `t:filter/0`) - One or more filters to scope the tags to
    return. The maximum number of filters per filter type (for example,
    auto-scaling-group) is 1000.

    * max_records (`Integer`) - The maximum number of items to return with this call. The
    default value is 50 and the maximum value is 100.

    * next_token (`String`) - The token for the next set of items to return. (You received
    this token from a previous call.)

  """
  @type describe_tags_opts :: [
          filters: [filter, ...],
          max_records: integer,
          next_token: binary,
          scheduled_action_names: [binary, ...],
          start_time: binary
        ]

  @typedoc """
   The optional parameters when calling `detach_instances/3`,
   `enter_standby/3`, `attach_instances/2`

  ## Keys

    * instance_ids (`List` of `String`) - The IDs of the instances. You can
    specify up to 20 instances.
  """
  @type instances_opts :: [
          instance_ids: [binary, ...]
        ]

  @typedoc """
   The optional parameters when calling `disable_metrics_collection/2`
   or `enable_metrics_collection/3`

  ## Keys

    * metrics (`List` of `String`) - One or more of the following metrics.
    If you omit this parameter, all metrics are disabled.

      * GroupMinSize
      * GroupMaxSize
      * GroupDesiredCapacity
      * GroupInServiceInstances
      * GroupPendingInstances
      * GroupStandbyInstances
      * GroupTerminatingInstances
      * GroupTotalInstances
  """
  @type metrics_collection_opts :: [
          metrics: [binary, ...]
        ]

  @typedoc """
   The optional parameters when calling `execute_policy/3`

  ## Keys

    * breach_threshold (`Float`) - The breach threshold for the alarm. This parameter
    is required if the policy type is StepScaling and not supported otherwise.

    * honor_cooldown (boolean) - Indicates whether Amazon EC2 Auto Scaling waits for the
    cooldown period to complete before executing the policy. This parameter is
    not supported if the policy type is StepScaling.

    * metric_value (`Float`) - The metric value to compare to BreachThreshold. This enables
    you to execute a policy of type StepScaling and determine which step adjustment
    to use. For example, if the breach threshold is 50 and you want to use a step
    adjustment with a lower bound of 0 and an upper bound of 10, you can set the
    metric value to 59. If you specify a metric value that doesn't correspond to
    a step adjustment for the policy, the call returns an error. This parameter is
    required if the policy type is StepScaling and not supported otherwise.
  """
  @type execute_policy_opts :: [
          breach_threshold: binary,
          honor_cooldown: boolean,
          metric_value: binary
        ]

  @typedoc """
    Optional parameters when calling `set_instance_health/3`

  ## Keys

    * should_respect_grace_period (boolean) - If the Auto Scaling group of the specified
    instance has a health_check_grace_period specified for the group, by default, this
    call respects the grace period. Set this to false, to have the call not respect the
    grace period associated with the group. For more information about the health check
    grace period, see `create_auto_scaling_group/4`.
  """
  @type set_instance_health_opts :: [
          should_respect_grace_period: boolean
        ]

  @typedoc """
    Optional parameters when calling `set_desired_dapacity/3`

  ## Keys

    * honor_cooldown (boolean) - Indicates whether Amazon EC2 Auto Scaling waits for
    the cooldown period to complete before initiating a scaling activity to set your
    Auto Scaling group to its new capacity. By default, Amazon EC2 Auto Scaling does
    not honor the cooldown period during manual scaling activities.
  """
  @type set_desired_dapacity_opts :: [
          honor_cooldown: boolean
        ]

  @typedoc """
    Describes the dimension of a metric
  """
  @type metric_dimension :: [
          name: binary,
          value: binary
        ]

  @typedoc """
    A customized metric. You can specify either a predefined metric or a customized metric
  """
  @type customized_metric_specification :: [
          dimensions: [metric_dimension, ...],
          metric_name: binary,
          namespace: binary,
          statistic: binary,
          unit: binary
        ]

  @typedoc """
    Represents a predefined metric for a target tracking scaling policy to use with
    Amazon EC2 Auto Scaling.

  """
  @type predefined_metric_specification :: [
          predefined_metric_type: binary,
          resource_label: binary
        ]

  @typedoc """
    A target tracking scaling policy.

  """
  @type target_tracking_configuration :: [
          customized_metric_specification: customized_metric_specification,
          disable_scale_in: boolean,
          predefined_metric_specification: predefined_metric_specification,
          target_value: float
        ]

  @typedoc """
    Optional parameters to `put_scaling_policy/3`
  """
  @type put_scaling_policy_opts :: [
          adjustment_type: binary,
          cooldown: integer,
          estimated_instance_warmup: integer,
          metric_aggregation_type: binary,
          min_adjustment_magnitude: integer,
          min_adjustment_step: integer,
          policy_type: binary,
          scaling_adjustment: integer,
          target_tracking_configuration: target_tracking_configuration
        ]

  @typedoc """
    Optional parameters to `put_scheduled_update_group_action/3`


  """
  @type put_scheduled_update_group_action_opts :: [
          desired_capacity: integer,
          end_time: binary,
          max_size: integer,
          min_size: integer,
          recurrence: binary,
          start_time: binary
        ]

  @typedoc """
    Optional parameters to `record_lifecycle_action_heartbeat/3`
  """
  @type record_lifecycle_action_heartbeat_opts :: [
          instance_id: binary,
          lifecycle_action_token: binary
        ]

  @doc """
    Attaches one or more EC2 instances to the specified Auto Scaling group

    When you attach instances, Amazon EC2 Auto Scaling increases the desired capacity
    of the group by the number of instances being attached. If the number of instances
    being attached plus the desired capacity of the group exceeds the maximum size of
    the group, the operation fails.

    If there is a Classic Load Balancer attached to your Auto Scaling group, the
    instances are also registered with the load balancer. If there are target groups
    attached to your Auto Scaling group, the instances are also registered with the
    target groups.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * opts (`t:instances_opts/0`) - The optional parameters

  ## Example

          iex> op = ExAws.AutoScaling.attach_instances("my-asg", instance_ids: ["i-12345678"])
          iex> op.params
          %{
            "Action" => "AttachInstances",
            "AutoScalingGroupName" => "my-asg",
            "InstanceIds.member.1" => "i-12345678",
            "Version" => "2011-01-01"
          }
  """
  @spec attach_instances(auto_scaling_group_name :: binary) :: ExAws.Operation.Query.t()
  @spec attach_instances(auto_scaling_group_name :: binary, opts :: instances_opts) ::
          ExAws.Operation.Query.t()
  def attach_instances(auto_scaling_group_name, opts \\ []) do
    [{:auto_scaling_group_name, auto_scaling_group_name} | opts]
    |> build_request(:attach_instances)
  end

  @doc """
    Attaches one or more Classic Load Balancers to the specified Auto Scaling group

    To attach an Application Load Balancer or a Network Load Balancer instead, see
    `attach_load_balancer_target_groups/2`.

    To describe the load balancers for an Auto Scaling group, use `describe_load_balancers/2`.

    To detach the load balancer from the Auto Scaling group, use `detach_load_balancers/2`.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * load_balancer_names (`List` of String) - The names of the load balancers. You
    can specify up to 10 load balancers.

  ## Example:

        iex> op = ExAws.AutoScaling.attach_load_balancers("my-asg", ["my-lb"])
        iex> op.params
        %{
            "Action" => "AttachLoadBalancers",
            "AutoScalingGroupName" => "my-asg",
            "LoadBalancerNames.member.1" => "my-lb",
            "Version" => "2011-01-01"
        }

  """
  @spec attach_load_balancers(
          auto_scaling_group_name :: binary,
          load_balancer_names :: [binary, ...]
        ) :: ExAws.Operation.Query.t()
  def attach_load_balancers(auto_scaling_group_name, load_balancer_names) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:load_balancer_names, load_balancer_names}
    ]
    |> build_request(:attach_load_balancers)
  end

  @doc """
    Attaches one or more target groups to the specified Auto Scaling group

    To describe the target groups for an Auto Scaling group, use
    `describe_load_balancer_target_groups/2`.

    To detach the target group from the Auto Scaling group, use
    `detach_load_balancer_target_groups/2`

  ## Example:

        iex> op = ExAws.AutoScaling.attach_load_balancer_target_groups("my-asg", ["my-targetarn"])
        iex> op.params
        %{
            "Action" => "AttachLoadBalancerTargetGroups",
            "AutoScalingGroupName" => "my-asg",
            "TargetGroupARNs.member.1" => "my-targetarn",
            "Version" => "2011-01-01"
        }

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * target_group_arns (`List` of `String`) - The Amazon Resource Names (ARN) of
    the target groups. You can specify up to 10 target groups.
  """
  @spec attach_load_balancer_target_groups(
          auto_scaling_group_name :: binary,
          target_group_arns :: [binary, ...]
        ) :: ExAws.Operation.Query.t()
  def attach_load_balancer_target_groups(auto_scaling_group_name, target_group_arns) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:target_group_arns, target_group_arns}
    ]
    |> build_request(:attach_load_balancer_target_groups)
  end

  @doc """
    Deletes one or more scheduled actions for the specified Auto Scaling group

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * scheduled_action_names (`List` of `String`) - The names of the scheduled
    actions to delete. The maximum number allowed is 50.
  """
  @spec batch_delete_scheduled_action(
          auto_scaling_group_name :: binary,
          scheduled_action_names :: [binary, ...]
        ) :: ExAws.Operation.Query.t()
  def batch_delete_scheduled_action(auto_scaling_group_name, scheduled_action_names) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:scheduled_action_names, scheduled_action_names}
    ]
    |> build_request(:batch_delete_scheduled_action)
  end

  @doc """
    Creates or updates one or more scheduled scaling actions for an Auto Scaling group

    If you leave a parameter unspecified when updating a scheduled scaling action, the
    corresponding value remains unchanged.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * scheduled_update_group_actions (`List` of
    `t:scheduled_update_group_action_request/0`) - Describes one or more scheduled
    scaling action updates for a specified Auto Scaling group
  """
  @spec batch_put_scheduled_update_group_action(
          auto_scaling_group_name :: binary,
          scheduled_update_group_actions :: [scheduled_update_group_action_request, ...]
        ) :: ExAws.Operation.Query.t()
  def batch_put_scheduled_update_group_action(
        auto_scaling_group_name,
        scheduled_update_group_actions
      )
      when is_list(scheduled_update_group_actions) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:scheduled_update_group_actions, scheduled_update_group_actions}
    ]
    |> build_request(:batch_put_scheduled_update_group_action)
  end

  @doc """
    Completes the lifecycle action for the specified token or instance with the specified result

    This step is a part of the procedure for adding a lifecycle hook to an Auto Scaling group:

    1. (Optional) Create a Lambda function and a rule that allows CloudWatch Events to invoke your
    Lambda function when Amazon EC2 Auto Scaling launches or terminates instances.

    2. (Optional) Create a notification target and an IAM role. The target can be either an Amazon
    SQS queue or an Amazon SNS topic. The role allows Amazon EC2 Auto Scaling to publish lifecycle
    notifications to the target.

    3. Create the lifecycle hook. Specify whether the hook is used when the instances launch or
    terminate.

    4. If you need more time, record the lifecycle action heartbeat to keep the instance in a
    pending state.

    5. If you finish before the timeout period ends, complete the lifecycle action.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * lifecycle_hook_name (`String`) - The name of the lifecycle hook.

    * lifecycle_action_result (`String`) - The action for the group to take. This
    parameter can be either "CONTINUE" or "ABANDON".

    * opts (`t:complete_life_cycle_action_opts/0`) - The optional parameters
  """
  @spec complete_life_cycle_action(
          auto_scaling_group_name :: binary,
          lifecycle_hook_name :: binary,
          lifecycle_action_result :: binary
        ) :: ExAws.Operation.Query.t()
  @spec complete_life_cycle_action(
          auto_scaling_group_name :: binary,
          lifecycle_hook_name :: binary,
          lifecycle_action_result :: binary,
          opts :: complete_life_cycle_action_opts
        ) :: ExAws.Operation.Query.t()
  def complete_life_cycle_action(
        auto_scaling_group_name,
        lifecycle_hook_name,
        lifecycle_action_result,
        opts \\ []
      ) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:lifecycle_hook_name, lifecycle_hook_name},
      {:lifecycle_action_result, lifecycle_action_result} | opts
    ]
    |> build_request(:complete_life_cycle_action)
  end

  @doc """
    Creates an Auto Scaling group with the specified name and attributes.

    If you exceed your maximum limit of Auto Scaling groups, the call fails.
    For information about viewing this limit, see describe_account_limits. For
    information about updating this limit, see Amazon EC2 Auto Scaling Limits
    in the Amazon EC2 Auto Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group. This name
    must be unique within the scope of your AWS account.

    * min_size (`Integer`) - The minimum size of the group

    * max_size (`Integer`) - The maximum size of the group

    * opts (`t:create_auto_scaling_group_opts/0`) - optional parameters
  """
  @spec create_auto_scaling_group(
          auto_scaling_group_name :: binary,
          min_size :: integer,
          max_size :: integer
        ) :: ExAws.Operation.Query.t()
  @spec create_auto_scaling_group(
          auto_scaling_group_name :: binary,
          min_size :: integer,
          max_size :: integer,
          opts :: create_auto_scaling_group_opts
        ) :: ExAws.Operation.Query.t()
  def create_auto_scaling_group(auto_scaling_group_name, min_size, max_size, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:min_size, min_size},
      {:max_size, max_size} | opts
    ]
    |> build_request(:create_auto_scaling_group)
  end

  @doc """
    Creates a launch configuration.

    If you exceed your maximum limit of launch configurations, the call fails.
    For information about viewing this limit, see `describe_account_limits/2`.
    For information about updating this limit, see Amazon EC2 Auto Scaling
    Limits in the Amazon EC2 Auto Scaling User Guide.

    For more information, see Launch Configurations in the Amazon EC2 Auto
    Scaling User Guide.

  ## Parameters

    * launch_configuration_name (`String`) - The name of the launch configuration.
    This name must be unique within the scope of your AWS account.

    * opts (`t:create_launch_configuration_opts/0`) - optional parameters
  """
  @spec create_launch_configuration(
          launch_configuration_name :: binary,
          opts :: create_launch_configuration_opts
        ) :: ExAws.Operation.Query.t()
  def create_launch_configuration(launch_configuration_name, opts) do
    [{:launch_configuration_name, launch_configuration_name} | opts]
    |> build_request(:create_launch_configuration)
  end

  @doc """
    Creates or updates tags for the specified Auto Scaling group.

    When you specify a tag with a key that already exists, the operation overwrites
    the previous tag definition, and you do not get an error message.

    For more information, see Tagging Auto Scaling Groups and Instances in the Amazon
    EC2 Auto Scaling User Guide.

  ## Parameters

    * tags (`List` of `t:tag/0`) - One or more tags.
  """
  def create_or_update_tags(tags) do
    [tags: tags]
    |> build_request(:create_or_update_tags)
  end

  @doc """
    Deletes the specified Auto Scaling group.

    If the group has instances or scaling activities in progress, you must
    specify the option to force the deletion in order for it to succeed.

    If the group has policies, deleting the group deletes the policies, the
    underlying alarm actions, and any alarm that no longer has an associated action.

    To remove instances from the Auto Scaling group before deleting it, call
    `detach_instances/1` with the list of instances and the option to decrement
    the desired capacity. This ensures that Amazon EC2 Auto Scaling does not launch
    replacement instances.

    To terminate all instances before deleting the Auto Scaling group, call
    `update_auto_scaling_group/1` and set the minimum size and desired capacity
    of the Auto Scaling group to zero.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group.

    * opts (`t:delete_auto_scaling_group_opts/0`) - optional parameters
  """
  @spec delete_auto_scaling_group(auto_scaling_group_name :: binary) :: ExAws.Operation.Query.t()
  @spec delete_auto_scaling_group(
          auto_scaling_group_name :: binary,
          opts :: delete_auto_scaling_group_opts
        ) :: ExAws.Operation.Query.t()
  def delete_auto_scaling_group(auto_scaling_group_name, opts \\ []) do
    [{:auto_scaling_group_name, auto_scaling_group_name} | opts]
    |> build_request(:delete_auto_scaling_group)
  end

  @doc """
    Deletes the specified launch configuration.

    The launch configuration must not be attached to an Auto Scaling group. When
    this call completes, the launch configuration is no longer available for use.

  ## Parameters

    * launch_configuration_name (`String`) - The name of the launch configuration.
  """
  @spec delete_launch_configuration(launch_configuration_name :: binary) ::
          ExAws.Operation.Query.t()
  def delete_launch_configuration(launch_configuration_name) do
    [{:launch_configuration_name, launch_configuration_name}]
    |> build_request(:delete_launch_configuration)
  end

  @doc """
    Deletes the specified lifecycle hook.

    If there are any outstanding lifecycle actions, they are completed
    first (ABANDON for launching instances, CONTINUE for terminating instances).

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group.

    * lifecycle_hook_name (`String`) - The name of the lifecycle hook.
  """
  @spec delete_lifecycle_hook(auto_scaling_group_name :: binary, lifecycle_hook_name :: binary) ::
          ExAws.Operation.Query.t()
  def delete_lifecycle_hook(auto_scaling_group_name, lifecycle_hook_name) do
    [auto_scaling_group_name: auto_scaling_group_name, lifecycle_hook_name: lifecycle_hook_name]
    |> build_request(:delete_lifecycle_hook)
  end

  @doc """
    Deletes the specified notification

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group.

    * topic_arn (`String`) - The Amazon Resource Name (ARN) of the Amazon Simple
    Notification Service (Amazon SNS) topic.
  """
  @spec delete_notification_configuration(auto_scaling_group_name :: binary, topic_arn :: binary) ::
          ExAws.Operation.Query.t()
  def delete_notification_configuration(auto_scaling_group_name, topic_arn) do
    [auto_scaling_group_name: auto_scaling_group_name, topic_arn: topic_arn]
    |> build_request(:delete_notification_configuration)
  end

  @doc """
    Deletes the specified Auto Scaling policy.

    Deleting a policy deletes the underlying alarm action, but does not
    delete the alarm, even if it no longer has an associated action.

  ## Parameters

    * policy_name (`String`) - The name or Amazon Resource Name (ARN) of the policy.

    * opts (`t:delete_policy_opts/0`) - optional parameters
  """
  @spec delete_policy(policy_name :: binary) :: ExAws.Operation.Query.t()
  @spec delete_policy(policy_name :: binary, opts :: delete_policy_opts) ::
          ExAws.Operation.Query.t()
  def delete_policy(policy_name, opts \\ []) do
    [{:policy_name, policy_name} | opts]
    |> build_request(:delete_policy)
  end

  @doc """
    Deletes the specified scheduled action

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group.

    * scheduled_action_name (`String`) - The name of the action to delete
  """
  @spec delete_scheduled_action(
          auto_scaling_group_name :: binary,
          scheduled_action_name :: binary
        ) :: ExAws.Operation.Query.t()
  def delete_scheduled_action(auto_scaling_group_name, scheduled_action_name) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:scheduled_action_name, scheduled_action_name}
    ]
    |> build_request(:delete_scheduled_action)
  end

  @doc """
    Deletes the specified tags.

  ## Parameters

    * tags (`List` of `t:tag/0`) - One or more tags.
  """
  @spec delete_tags(tags :: [tag, ...]) :: ExAws.Operation.Query.t()
  def delete_tags(tags) do
    [{:tags, tags}]
    |> build_request(:delete_tags)
  end

  @doc """
    Describes the current Auto Scaling resource limits for your AWS account.

    For information about requesting an increase in these limits, see Amazon
    EC2 Auto Scaling Limits in the Amazon EC2 Auto Scaling User Guide.
  """
  @spec describe_account_limits() :: ExAws.Operation.Query.t()
  def describe_account_limits do
    request(%{}, :describe_account_limits)
  end

  @doc """
    Describes the policy adjustment types for use with `put_scaling_policy/2`
  """
  @spec describe_adjustment_types :: ExAws.Operation.Query.t()
  def describe_adjustment_types do
    request(%{}, :describe_adjustment_types)
  end

  @doc """
    Describes one or more Auto Scaling groups

  ## Parameters

    * opts (`t:describe_auto_scaling_groups_opts/0`) - optional parameters
  """
  @spec describe_auto_scaling_groups() :: ExAws.Operation.Query.t()
  @spec describe_auto_scaling_groups(opts :: describe_auto_scaling_groups_opts) ::
          ExAws.Operation.Query.t()
  def describe_auto_scaling_groups(opts \\ []) do
    opts |> build_request(:describe_auto_scaling_groups)
  end

  @doc """
    Describes one or more Auto Scaling instances.

  ## Parameters

    * opts (`t:describe_auto_scaling_instances_opts/0`) - optional parameters
  """
  @spec describe_auto_scaling_instances() :: ExAws.Operation.Query.t()
  @spec describe_auto_scaling_instances(opts :: describe_auto_scaling_instances_opts) ::
          ExAws.Operation.Query.t()
  def describe_auto_scaling_instances(opts \\ []) do
    opts |> build_request(:describe_auto_scaling_instances)
  end

  @doc """
    Describes the notification types that are supported by Amazon
    EC2 Auto Scaling
  """
  @spec describe_auto_scaling_notification_types() :: ExAws.Operation.Query.t()
  def describe_auto_scaling_notification_types do
    request(%{}, :describe_auto_scaling_notification_types)
  end

  @doc """
    Describes one or more launch configurations.

  ## Parameters

    * opts (`t:describe_launch_configurations_opts/0`) - optional parameters
  """
  @spec describe_launch_configurations() :: ExAws.Operation.Query.t()
  @spec describe_launch_configurations(opts :: describe_launch_configurations_opts) ::
          ExAws.Operation.Query.t()
  def describe_launch_configurations(opts \\ []) do
    opts |> build_request(:describe_launch_configurations)
  end

  @doc """
    Describes the lifecycle hooks for the specified Auto Scaling group

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group.

    * opts (`t:describe_lifecycle_hooks_opts/0`) - optional parameters
  """
  @spec describe_lifecycle_hooks(auto_scaling_group_name :: binary) :: ExAws.Operation.Query.t()
  @spec describe_lifecycle_hooks(
          auto_scaling_group_name :: binary,
          opts :: describe_lifecycle_hooks_opts
        ) :: ExAws.Operation.Query.t()
  def describe_lifecycle_hooks(auto_scaling_group_name, opts \\ []) do
    [{:auto_scaling_group_name, auto_scaling_group_name} | opts]
    |> build_request(:describe_lifecycle_hooks)
  end

  @doc """
    Describes the available types of lifecycle hooks.

    The following hook types are supported:

    * autoscaling:EC2_INSTANCE_LAUNCHING
    * autoscaling:EC2_INSTANCE_TERMINATING
  """
  @spec describe_lifecycle_hook_types() :: ExAws.Operation.Query.t()
  def describe_lifecycle_hook_types do
    request(%{}, :describe_lifecycle_hook_types)
  end

  @doc """
    Describes the load balancers for the specified Auto Scaling group.

    This operation describes only Classic Load Balancers. If you have
    Application Load Balancers or Network Load Balancers, use
    `describe_load_balancer_target_groups/2` instead.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group.

    * opts (`t:paging_opts/0`) - optional parameters
  """
  @spec describe_load_balancers(auto_scaling_group_name :: binary) :: ExAws.Operation.Query.t()
  @spec describe_load_balancers(auto_scaling_group_name :: binary, opts :: paging_opts) ::
          ExAws.Operation.Query.t()
  def describe_load_balancers(auto_scaling_group_name, opts \\ []) do
    [{:auto_scaling_group_name, auto_scaling_group_name} | opts]
    |> build_request(:describe_load_balancers)
  end

  @doc """
    Describes the target groups for the specified Auto Scaling group

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group.

    * opts (`t:paging_opts/0`) - optional parameters
  """
  @spec describe_load_balancer_target_groups(auto_scaling_group_name :: binary) ::
          ExAws.Operation.Query.t()
  @spec describe_load_balancer_target_groups(
          auto_scaling_group_name :: binary,
          opts :: paging_opts
        ) :: ExAws.Operation.Query.t()
  def describe_load_balancer_target_groups(auto_scaling_group_name, opts \\ []) do
    [{:auto_scaling_group_name, auto_scaling_group_name} | opts]
    |> build_request(:describe_load_balancer_target_groups)
  end

  @doc """
    Describes the available CloudWatch metrics for Amazon EC2 Auto Scaling.

    The GroupStandbyInstances metric is not returned by default. You must
    explicitly request this metric when calling `enable_metrics_collection/2`.
  """
  @spec describe_metric_collection_types() :: ExAws.Operation.Query.t()
  def describe_metric_collection_types do
    request(%{}, :describe_metric_collection_types)
  end

  @doc """
    Describes the notification actions associated with the specified
    Auto Scaling group.

  ## Parameters

    * opts (`t:describe_notification_configurations_opts/0`) - optional parameters
  """
  @spec describe_notification_configurations() :: ExAws.Operation.Query.t()
  @spec describe_notification_configurations(opts :: describe_notification_configurations_opts) ::
          ExAws.Operation.Query.t()
  def describe_notification_configurations(opts \\ []) do
    opts
    |> build_request(:describe_notification_configurations)
  end

  @doc """
    Describes the policies for the specified Auto Scaling group

  ## Parameters

    * opts (`t:describe_policies_opts/0`) - optional parameters
  """
  @spec describe_policies() :: ExAws.Operation.Query.t()
  @spec describe_policies(opts :: describe_policies_opts) :: ExAws.Operation.Query.t()
  def describe_policies(opts \\ []) do
    opts
    |> build_request(:describe_policies)
  end

  @doc """
    Describes one or more scaling activities for the specified Auto Scaling group.

  ## Parameters

    * opts (`t:describe_scaling_activities_opts/0`) - optional parameters
  """
  @spec describe_scaling_activities() :: ExAws.Operation.Query.t()
  @spec describe_scaling_activities(opts :: describe_scaling_activities_opts) ::
          ExAws.Operation.Query.t()
  def describe_scaling_activities(opts \\ []) do
    opts
    |> build_request(:describe_scaling_activities)
  end

  @doc """
    Describes the scaling process types for use with `resume_processes/2` and
    `suspend_processes/2`.
  """
  @spec describe_scaling_process_types() :: ExAws.Operation.Query.t()
  def describe_scaling_process_types do
    request(%{}, :describe_scaling_process_types)
  end

  @doc """
    Describes the actions scheduled for your Auto Scaling group
    that haven't run. To describe the actions that have already
    run, use `describe_scaling_activities/2`.

  ## Parameters

    * opts (`t:describe_scheduled_actions_opts/0`) - optional parameters
  """
  def describe_scheduled_actions(opts \\ []) do
    opts
    |> build_request(:describe_scheduled_actions)
  end

  @doc """
    Describes the specified tags.

    You can use filters to limit the results. For example, you can query
    for the tags for a specific Auto Scaling group. You can specify multiple
    values for a filter. A tag must match at least one of the specified
    values for it to be included in the results.

    You can also specify multiple filters. The result includes information for
    a particular tag only if it matches all the filters. If there's no match,
    no special message is returned.

  ## Parameters

    * opts (`t:describe_tags_opts/0`) - optional parameters
  """
  @spec describe_tags() :: ExAws.Operation.Query.t()
  @spec describe_tags(opts :: describe_tags_opts) :: ExAws.Operation.Query.t()
  def describe_tags(opts \\ []) do
    opts
    |> build_request(:describe_tags)
  end

  @doc """
    Describes the termination policies supported by Amazon EC2 Auto Scaling.

    For more information, see Controlling Which Auto Scaling Instances Terminate
    During Scale In in the Amazon EC2 Auto Scaling User Guide.
  """
  @spec describe_termination_policy_types() :: ExAws.Operation.Query.t()
  def describe_termination_policy_types do
    request(%{}, :describe_termination_policy_types)
  end

  @doc """
    Removes one or more instances from the specified Auto Scaling group.

    After the instances are detached, you can manage them independent of the
    Auto Scaling group.

    If you do not specify the option to decrement the desired capacity, Amazon
    EC2 Auto Scaling launches instances to replace the ones that are detached.

    If there is a Classic Load Balancer attached to the Auto Scaling group,
    the instances are deregistered from the load balancer. If there are target
    groups attached to the Auto Scaling group, the instances are deregistered
    from the target groups.

    For more information, see Detach EC2 Instances from Your Auto Scaling Group
    in the Amazon EC2 Auto Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name  (`String`) - The name of the Auto Scaling group

    * should_decrement_desired_capacity (boolean) - Indicates whether the Auto Scaling
    group decrements the desired capacity value by the number of instances detached.

    * opts (`t:instances_opts/0`) - optional parameters
  """
  @spec detach_instances(
          auto_scaling_group_name :: binary,
          should_decrement_desired_capacity :: boolean
        ) :: ExAws.Operation.Query.t()
  @spec detach_instances(
          auto_scaling_group_name :: binary,
          should_decrement_desired_capacity :: boolean,
          opts :: instances_opts
        ) :: ExAws.Operation.Query.t()
  def detach_instances(auto_scaling_group_name, should_decrement_desired_capacity, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:should_decrement_desired_capacity, should_decrement_desired_capacity} | opts
    ]
    |> build_request(:detach_instances)
  end

  @doc """
    Detaches one or more Classic Load Balancers from the specified Auto Scaling group.

    This operation detaches only Classic Load Balancers. If you have Application Load
    Balancers or Network Load Balancers, use `detach_load_balancer_target_groups/2`
    instead.

    When you detach a load balancer, it enters the Removing state while deregistering
    the instances in the group. When all instances are deregistered, then you can no
    longer describe the load balancer using `describe_load_balancers/2`. The instances
    remain running.

  ## Parameters

    * auto_scaling_group_name  (`String`) - The name of the Auto Scaling group

    * load_balancer_names (`List` of `String`) - The names of the load balancers. You
    can specify up to 10 load balancers.
  """
  @spec detach_load_balancers(
          auto_scaling_group_name :: binary,
          load_balancer_names :: [binary, ...]
        ) :: ExAws.Operation.Query.t()
  def detach_load_balancers(auto_scaling_group_name, load_balancer_names) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:load_balancer_names, load_balancer_names}
    ]
    |> build_request(:detach_load_balancers)
  end

  @doc """
    Detaches one or more target groups from the specified Auto Scaling group.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * target_group_arns (`List` of `String`) - The Amazon Resource Names (ARN) of
    the target groups. You can specify up to 10 target groups.
  """
  @spec detach_load_balancer_target_groups(
          auto_scaling_group_name :: binary,
          target_group_arns :: [binary, ...]
        ) :: ExAws.Operation.Query.t()
  def detach_load_balancer_target_groups(auto_scaling_group_name, target_group_arns) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:target_group_arns, target_group_arns}
    ]
    |> build_request(:detach_load_balancer_target_groups)
  end

  @doc """
    Disables group metrics for the specified Auto Scaling group.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * opts (`t:metrics_collection_opts/0`) - optional parameters
  """
  @spec disable_metrics_collection(auto_scaling_group_name :: binary) :: ExAws.Operation.Query.t()
  @spec disable_metrics_collection(
          auto_scaling_group_name :: binary,
          opts :: metrics_collection_opts
        ) :: ExAws.Operation.Query.t()
  def disable_metrics_collection(auto_scaling_group_name, opts \\ []) do
    [{:auto_scaling_group_name, auto_scaling_group_name} | opts]
    |> build_request(:disable_metrics_collection)
  end

  @doc """
    Enables group metrics for the specified Auto Scaling group

    For more information, see Monitoring Your Auto Scaling Groups and
    Instances in the Amazon EC2 Auto Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * granularity (`String`) - The granularity to associate with the metrics to collect.
    The only valid value is "1Minute".

    * opts (`t:metrics_collection_opts/0`) - optional parameters
  """
  @spec enable_metrics_collection(auto_scaling_group_name :: binary, granularity :: binary) ::
          ExAws.Operation.Query.t()
  @spec enable_metrics_collection(
          auto_scaling_group_name :: binary,
          granularity :: binary,
          opts :: metrics_collection_opts
        ) :: ExAws.Operation.Query.t()
  def enable_metrics_collection(auto_scaling_group_name, granularity \\ "1Minute", opts \\ []) do
    [{:auto_scaling_group_name, auto_scaling_group_name}, {:granularity, granularity} | opts]
    |> build_request(:enable_metrics_collection)
  end

  @doc """
    Moves the specified instances into the standby state.

    For more information, see Temporarily Removing Instances from Your Auto Scaling
    Group in the Amazon EC2 Auto Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * should_decrement_desired_capacity (boolean) - Indicates whether to decrement the desired
    capacity of the Auto Scaling group by the number of instances moved to Standby mode.

    * opts (`t:instances_opts/0`) - optional parameters
  """
  @spec enter_standby(
          auto_scaling_group_name :: binary,
          should_decrement_desired_capacity :: boolean
        ) :: ExAws.Operation.Query.t()
  @spec enter_standby(
          auto_scaling_group_name :: binary,
          should_decrement_desired_capacity :: boolean,
          opts :: instances_opts
        ) :: ExAws.Operation.Query.t()
  def enter_standby(auto_scaling_group_name, should_decrement_desired_capacity, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:should_decrement_desired_capacity, should_decrement_desired_capacity} | opts
    ]
    |> build_request(:enter_standby)
  end

  @doc """
    Executes the specified policy

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * policy_name (`String`) - The name or ARN of the policy.

    * opts (`t:execute_policy_opts/0`) - optional parameters
  """
  @spec execute_policy(auto_scaling_group_name :: binary, policy_name :: binary) ::
          ExAws.Operation.Query.t()
  @spec execute_policy(
          auto_scaling_group_name :: binary,
          policy_name :: binary,
          opts :: execute_policy_opts
        ) :: ExAws.Operation.Query.t()
  def execute_policy(auto_scaling_group_name, policy_name, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:policy_name, policy_name} | opts
    ]
    |> build_request(:execute_policy)
  end

  @doc """
    Moves the specified instances out of the standby state.

    For more information, see Temporarily Removing Instances from
    Your Auto Scaling Group in the Amazon EC2 Auto Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * opts (`t:instances_opts/0`) - optional parameters
  """
  @spec exit_standby(auto_scaling_group_name :: binary) :: ExAws.Operation.Query.t()
  @spec exit_standby(auto_scaling_group_name :: binary, opts :: instances_opts) ::
          ExAws.Operation.Query.t()
  def exit_standby(auto_scaling_group_name, opts \\ []) do
    [{:auto_scaling_group_name, auto_scaling_group_name} | opts]
    |> build_request(:exit_standby)
  end

  @doc """
    Creates or updates a lifecycle hook for the specified Auto Scaling group.

    A lifecycle hook tells Amazon EC2 Auto Scaling to perform an action on an
    instance that is not actively in service, for example, either when the
    instance launches or before the instance terminates.

    This step is a part of the procedure for adding a lifecycle hook to an
    Auto Scaling group:

    1. (Optional) Create a Lambda function and a rule that allows CloudWatch
    Events to invoke your Lambda function when Amazon EC2 Auto Scaling launches
    or terminates instances.

    2. (Optional) Create a notification target and an IAM role. The target can be
    either an Amazon SQS queue or an Amazon SNS topic. The role allows Amazon EC2
    Auto Scaling to publish lifecycle notifications to the target.

    3. Create the lifecycle hook. Specify whether the hook is used when the instances
    launch or terminate.

    4. If you need more time, record the lifecycle action heartbeat to keep the
    instance in a pending state.

    5. If you finish before the timeout period ends, complete the lifecycle action.

    For more information, see Amazon EC2 Auto Scaling Lifecycle Hooks in the Amazon EC2
    Auto Scaling User Guide.

    If you exceed your maximum limit of lifecycle hooks, which by default is 50 per Auto
    Scaling group, the call fails.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * lifecycle_hook_name (`String`) - The name of the lifecycle hook

    * opts (`t:put_lifecycle_hook_opts/0`) - optional parameters
  """
  @spec put_lifecycle_hook(auto_scaling_group_name :: binary, lifecycle_hook_name :: binary) ::
          ExAws.Operation.Query.t()
  @spec put_lifecycle_hook(
          auto_scaling_group_name :: binary,
          lifecycle_hook_name :: binary,
          opts :: put_lifecycle_hook_opts
        ) :: ExAws.Operation.Query.t()
  def put_lifecycle_hook(auto_scaling_group_name, lifecycle_hook_name, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:lifecycle_hook_name, lifecycle_hook_name} | opts
    ]
    |> build_request(:put_lifecycle_hook)
  end

  @doc """
    Configures an Auto Scaling group to send notifications when specified events
    take place.

    Subscribers to the specified topic can have messages delivered to an endpoint
    such as a web server or an email address.

    This configuration overwrites any existing configuration.

    For more information, see Getting Amazon SNS Notifications When Your Auto Scaling
    Group Scales in the Amazon EC2 Auto Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * topic_arn (`String`) - The Amazon Resource Name (ARN) of the Amazon Simple
    Notification Service (Amazon SNS) topic.

    * notification_types (`List` of `String`) - The type of event that causes the
    notification to be sent. For more information about notification types supported
    by Amazon EC2 Auto Scaling, see describe_auto_scaling_notification_types.
  """
  @spec put_notification_configuration(
          auto_scaling_group_name :: binary,
          topic_arn :: binary,
          notification_types :: [binary, ...]
        ) :: ExAws.Operation.Query.t()
  def put_notification_configuration(auto_scaling_group_name, topic_arn, notification_types) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:topic_arn, topic_arn},
      {:notification_types, notification_types}
    ]
    |> build_request(:put_lifecycle_hook)
  end

  @doc """
    Creates or updates a policy for an Auto Scaling group

    To update an existing policy, use the existing policy name and set the
    parameters to change. Any existing parameter not changed in an update
    to an existing policy is not changed in this update request.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * policy_name (`String`) - The name of the policy

    * opts (`t:put_scaling_policy_opts/0`) - optional parameters
  """
  @spec put_scaling_policy(auto_scaling_group_name :: binary, policy_name :: binary) ::
          ExAws.Operation.Query.t()
  @spec put_scaling_policy(
          auto_scaling_group_name :: binary,
          policy_name :: binary,
          opts :: put_scaling_policy_opts
        ) :: ExAws.Operation.Query.t()
  def put_scaling_policy(auto_scaling_group_name, policy_name, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:policy_name, policy_name} | opts
    ]
    |> build_request(:put_scaling_policy)
  end

  @doc """
    Creates or updates a scheduled scaling action for an Auto Scaling group

    If you leave a parameter unspecified when updating a scheduled scaling action,
    the corresponding value remains unchanged.

    For more information, see Scheduled Scaling in the Amazon EC2 Auto Scaling
    User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * scheduled_action_name (`String`) - The name of this scaling action

    * opts (`t:put_scheduled_update_group_action_opts/0`)
  """
  @spec put_scheduled_update_group_action(
          auto_scaling_group_name :: binary,
          scheduled_action_name :: binary
        ) :: ExAws.Operation.Query.t()
  @spec put_scheduled_update_group_action(
          auto_scaling_group_name :: binary,
          scheduled_action_name :: binary,
          opts :: put_scheduled_update_group_action_opts
        ) :: ExAws.Operation.Query.t()
  def put_scheduled_update_group_action(
        auto_scaling_group_name,
        scheduled_action_name,
        opts \\ []
      ) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:scheduled_action_name, scheduled_action_name} | opts
    ]
    |> build_request(:put_scheduled_update_group_action)
  end

  @doc """
    Records a heartbeat for the lifecycle action associated with the
    specified token or instance

    This extends the timeout by the length of time defined using PutLifecycleHook.

    This step is a part of the procedure for adding a lifecycle hook to an Auto
    Scaling group:

    1. (Optional) Create a Lambda function and a rule that allows CloudWatch
    Events to invoke your Lambda function when Amazon EC2 Auto Scaling launches
    or terminates instances.

    2. (Optional) Create a notification target and an IAM role. The target can be
    either an Amazon SQS queue or an Amazon SNS topic. The role allows Amazon EC2
    Auto Scaling to publish lifecycle notifications to the target.

    3. Create the lifecycle hook. Specify whether the hook is used when the instances
    launch or terminate.

    4. If you need more time, record the lifecycle action heartbeat to keep the
    instance in a pending state.

    5. If you finish before the timeout period ends, complete the lifecycle action.

    For more information, see Auto Scaling Lifecycle in the Amazon EC2 Auto
    Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * lifecycle_hook_name (`String`) - A token that uniquely identifies a specific
    lifecycle action associated with an instance. Amazon EC2 Auto Scaling sends
    this token to the notification target that you specified when you created
    the lifecycle hook.

    * opts (`t:record_lifecycle_action_heartbeat_opts/0`)
  """
  @spec record_lifecycle_action_heartbeat(
          auto_scaling_group_name :: binary,
          lifecycle_hook_name :: binary
        ) :: ExAws.Operation.Query.t()
  @spec record_lifecycle_action_heartbeat(
          auto_scaling_group_name :: binary,
          lifecycle_hook_name :: binary,
          opts :: record_lifecycle_action_heartbeat_opts
        ) :: ExAws.Operation.Query.t()
  def record_lifecycle_action_heartbeat(auto_scaling_group_name, lifecycle_hook_name, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:lifecycle_hook_name, lifecycle_hook_name} | opts
    ]
    |> build_request(:record_lifecycle_action_heartbeat)
  end

  @doc """
    Resumes the specified suspended automatic scaling processes, or all
    suspended process, for the specified Auto Scaling group.

    For more information, see Suspending and Resuming Scaling Processes
    in the Amazon EC2 Auto Scaling User Guide.
  """
  def resume_processes do
    request(%{}, :resume_processes)
  end

  @doc """
    Sets the size of the specified Auto Scaling group.

    For more information about desired capacity, see
    What Is Amazon EC2 Auto Scaling? in the Amazon EC2 Auto
    Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * desired_capacity (`Integer`) - The number of EC2 instances that should
    be running in the Auto Scaling group.

    * opts (`t: set_desired_dapacity_opts/0`)
  """
  @spec set_desired_dapacity(auto_scaling_group_name :: binary, desired_capacity :: integer) ::
          ExAws.Operation.Query.t()
  @spec set_desired_dapacity(
          auto_scaling_group_name :: binary,
          desired_capacity :: integer,
          opts :: set_desired_dapacity_opts
        ) :: ExAws.Operation.Query.t()
  def set_desired_dapacity(auto_scaling_group_name, desired_capacity, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:desired_capacity, desired_capacity} | opts
    ]
    |> build_request(:set_desired_dapacity)
  end

  @doc """
    Sets the health status of the specified instance.

    For more information, see Health Checks in the Amazon EC2
    Auto Scaling User Guide.

  ## Parameters

    * instance_id (`String`) - The ID of the instance

    * health_status (`String`) - The health status of the instance.
    Set to "Healthy" to have the instance remain in service. Set to
    "Unhealthy" to have the instance be out of service. Amazon EC2
    Auto Scaling terminates and replaces the unhealthy instance.

    * opts (`t:set_instance_health_opts/0`)
  """
  @spec set_instance_health(instance_id :: binary, health_status :: binary) ::
          ExAws.Operation.Query.t()
  @spec set_instance_health(
          instance_id :: binary,
          health_status :: binary,
          opts :: set_instance_health_opts
        ) :: ExAws.Operation.Query.t()
  def set_instance_health(instance_id, health_status, opts \\ []) do
    [
      {:instance_id, instance_id},
      {:health_status, health_status} | opts
    ]
    |> build_request(:set_instance_health)
  end

  @doc """
    Updates the instance protection settings of the specified instances.

    For more information about preventing instances that are part of an
    Auto Scaling group from terminating on scale in, see Instance Protection
    in the Amazon EC2 Auto Scaling User Guide.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * instance_ids (`List` of `String`) - One or more instance IDs.

    * protected_from_scale_in (boolean) - Indicates whether the instance is
    protected from termination by Amazon EC2 Auto Scaling when scaling in.
  """
  @spec set_instance_protection(
          auto_scaling_group_name :: binary,
          instance_ids :: [binary, ...],
          protected_from_scale_in :: boolean
        ) :: ExAws.Operation.Query.t()
  def set_instance_protection(auto_scaling_group_name, instance_ids, protected_from_scale_in) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name},
      {:instance_ids, instance_ids},
      {:protected_from_scale_in, protected_from_scale_in}
    ]
    |> build_request(:set_instance_protection)
  end

  @doc """
    Suspends the specified automatic scaling processes, or all
    processes, for the specified Auto Scaling group.

    If you suspend either the Launch or Terminate process types,
    it can prevent other process types from functioning properly.

    To resume processes that have been suspended, use
    `resume_processes/0`.

    For more information, see Suspending and Resuming Scaling
    Processes in the Amazon EC2 Auto Scaling User Guide.
  """
  @spec suspend_processes() :: ExAws.Operation.Query.t()
  def suspend_processes do
    request(%{}, :suspend_processes)
  end

  @doc """
    Terminates the specified instance and optionally adjusts the
    desired group size.

    This call simply makes a termination request. The instance
    is not terminated immediately.

  ## Parameters

    * instance_id (`String`) - The ID of the instance

    * should_decrement_desired_capacity (boolean) - Indicates whether terminating
    the instance also decrements the size of the Auto Scaling group.

  """
  @spec terminate_instance_in_auto_scaling_group(
          instance_id :: binary,
          should_decrement_desired_capacity :: boolean
        ) :: ExAws.Operation.Query.t()
  def terminate_instance_in_auto_scaling_group(instance_id, should_decrement_desired_capacity) do
    [
      {:instance_id, instance_id},
      {:should_decrement_desired_capacity, should_decrement_desired_capacity}
    ]
    |> build_request(:terminate_instance_in_auto_scaling_group)
  end

  @doc """
    Updates the configuration for the specified Auto Scaling group.

    The new settings take effect on any scaling activities after this
    call returns. Scaling activities that are currently in progress
    aren't affected.

    To update an Auto Scaling group with a launch configuration with
    InstanceMonitoring set to false, you must first disable the
    collection of group metrics. Otherwise, you get an error. If you
    have previously enabled the collection of group metrics, you can
    disable it using `disable_metrics_collection/2`.

    Note the following:

    * If you specify a new value for min_size without specifying a
    value for desired_capacity, and the new min_size is larger than
    the current size of the group, we implicitly call
    `set_desired_capacity/2` to set the size of the group to the new
    value of min_size.

    * If you specify a new value for max_size without specifying a
    value for desired_capacity, and the new max_size is smaller than
    the current size of the group, we implicitly call
    `set_desired_capacity/2` to set the size of the group to the new
    value of max_size.

    * All other optional parameters are left unchanged if not specified.

  ## Parameters

    * auto_scaling_group_name (`String`) - The name of the Auto Scaling group

    * opts (`t:update_auto_scaling_group_opts/0`) - optional parameters
  """
  @spec update_auto_scaling_group(auto_scaling_group_name :: binary) :: ExAws.Operation.Query.t()
  @spec update_auto_scaling_group(
          auto_scaling_group_name :: binary,
          opts :: update_auto_scaling_group_opts
        ) :: ExAws.Operation.Query.t()
  def update_auto_scaling_group(auto_scaling_group_name, opts \\ []) do
    [
      {:auto_scaling_group_name, auto_scaling_group_name} | opts
    ]
    |> build_request(:update_auto_scaling_group)
  end

  ####################
  # Helper Functions #
  ####################

  defp build_request(opts, action) do
    opts
    |> convert_to_flat_map()
    |> request(action)
  end

  defp convert_to_flat_map(opts) do
    opts
    |> Enum.flat_map(&format_param/1)
  end

  defp request(params, action) do
    action_string = action |> Atom.to_string() |> Macro.camelize()

    %ExAws.Operation.Query{
      path: "/",
      params:
        params
        |> filter_nil_params
        |> Map.put("Action", action_string)
        |> Map.put("Version", @version),
      service: :autoscaling,
      action: action
    }
  end

  ####################
  # Format Functions #
  ####################
  defp format_param({action, names}) when action in @member_actions do
    action_string = action |> atom_to_string()
    names |> format(prefix: "#{action_string}.member")
  end

  defp format_param({key, parameters}) do
    format([{key, parameters}])
  end

  defp atom_to_string(atom) do
    case Map.get(@special_formatting, atom) do
      nil -> atom |> Atom.to_string() |> Macro.camelize()
      val -> val
    end
  end
end
