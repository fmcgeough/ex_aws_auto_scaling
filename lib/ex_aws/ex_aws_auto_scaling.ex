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
    role_arn: "RoleARN"
  }

  @member_actions [
    :auto_scaling_group_names,
    :availability_zones,
    :classic_link_vpc_security_groups,
    :instance_ids,
    :load_balancer_names,
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
    Optional arguments to `describe_auto_scaling_groups/1`

  ## Keys

  * auto_scaling_group_names (List of String) - The names of the Auto Scaling groups.
  Each name can be a maximum of 1600 characters. By default, you can only specify up
  to 50 names. You can optionally increase this limit using the MaxRecords parameter.
  If you omit this parameter, all Auto Scaling groups are described.

  * max_records (Integer) - The maximum number of items to return with this call. The
  default value is 50 and the maximum value is 100.

  * next_token (String) - The token for the next set of items to return. (You received
  this token from a previous call.)
  """
  @type describe_auto_scaling_groups_opts :: [
          auto_scaling_group_names: [binary, ...],
          max_records: integer,
          next_token: binary
        ]

  @typedoc """
    Optional arguments to `attach_instances/2`

  ## Keys

   * instance_ids (List of String) - The IDs of the instances. You can
   specify up to 20 instances. Minimum length of 1. Maximum length of 19.
  """
  @type attach_instances_opts :: [
          instance_ids: [binary, ...]
        ]

  @typedoc """
    Describes one or more scheduled scaling action updates for a specified
    Auto Scaling group. Used in combination with `batch_put_scheduled_update_group_action/2`.

  ## Keys

    * desired_capacity (Integer) - The number of EC2 instances that should be running in the group.

    * end_time (String) - The time for the recurring schedule to end. Amazon EC2 Auto Scaling
    does not perform the action after this time.

    * max_size (Integer) - The maximum size of the group.

    * min_size (Integer) - The minimum size of the group.

    * recurrence (String) - The recurring schedule for the action, in Unix cron syntax format.
    This format consists of five fields separated by white spaces:
    [Minute] [Hour] [Day_of_Month] [Month_of_Year] [Day_of_Week].
    The value must be in quotes (for example, "30 0 1 1,6,12 *"). For more information about
    this format, see Crontab.

    * start_time (String) - The time for the action to start, in YYYY-MM-DDThh:mm:ssZ
    format in UTC/GMT only and in quotes (for example, "2019-06-01T00:00:00Z").
    If you specify recurrence and start_time, Amazon EC2 Auto Scaling performs the action
    at this time, and then performs the action based on the specified recurrence.
    If you try to schedule the action in the past, Amazon EC2 Auto Scaling returns an
    error message.

    * scheduled_action_name (String) - The name of the scaling action.
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
    One or more scheduled actions. The maximum number allowed is 50.
    See `batch_put_scheduled_update_group_action/2`
  """
  @type scheduled_update_group_actions :: [scheduled_update_group_action_request, ...]

  @typedoc """
    The optional parameters when calling `complete_life_cycle_action/4`

  ## Members

    * lifecycle_action_token (String) - A universally unique identifier (UUID) that
    identifies a specific lifecycle action associated with an instance. Amazon EC2
    Auto Scaling sends this token to the notification target you specified when you
    created the lifecycle hook.

    * instance_id (String) - The ID of the instance.
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

    * launch_template_id (String) - The ID of the launch template. You must specify
    either a template ID or a template name.

    * launch_template_name (String) - The name of the launch template. You must specify
    either a template name or a template ID.

    * version (String) - The version number, "$Latest", or "$Default". If the value is
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

    * default_result (String) - Defines the action the Auto Scaling group
    should take when the lifecycle hook timeout elapses or if an unexpected
    failure occurs. The valid values are "CONTINUE" and "ABANDON".

    * heartbeat_timeout (Integer) - The maximum time, in seconds, that can
    elapse before the lifecycle hook times out. If the lifecycle hook times
    out, Amazon EC2 Auto Scaling performs the action that you specified in the
    default_result parameter. You can prevent the lifecycle hook from timing
    out by calling `record_lifecycle_action_heartbeat/2`.

    * lifecycle_hook_name (String) - The name of the lifecycle hook.

    * lifecycle_transition (String) - The state of the EC2 instance to which you
    want to attach the lifecycle hook. The possible values are:
    "autoscaling:EC2_INSTANCE_LAUNCHING" | "autoscaling:EC2_INSTANCE_TERMINATING"

    * notification_target_arn (String) - The ARN of the target that Amazon EC2
    Auto Scaling sends notifications to when an instance is in the transition state
    for the lifecycle hook. The notification target can be either an SQS queue or
    an SNS topic.

    * role_arn (String) - The ARN of the IAM role that allows the Auto Scaling group
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
    Describes an instances distribution for an Auto Scaling group with
    mixed_instances_policy.

  ## Keys

    * on_demand_allocation_strategy (String) - Indicates how to allocate instance types to
    fulfill On-Demand capacity. The only valid value is "prioritized", which is also the
    default value. This strategy uses the order of instance type overrides for the
    launch_template to define the launch priority of each instance type. The first instance
    type in the array is prioritized higher than the last. If all your On-Demand capacity
    cannot be fulfilled using your highest priority instance, then the Auto Scaling groups
    launches the remaining capacity using the second priority instance type, and so on.

    * on_demand_base_capacity (Integer) - The minimum amount of the Auto Scaling group's
    capacity that must be fulfilled by On-Demand Instances. This base portion is provisioned
    first as your group scales. The default value is 0. If you leave this parameter set to
    0, On-Demand Instances are launched as a percentage of the Auto Scaling group's desired
    capacity, per the on_demand_percentage_above_base_capacity setting.

    * on_demand_percentage_above_base_capacity (Integer) - Controls the percentages of On-Demand
    Instances and Spot Instances for your additional capacity beyond on_demand_base_capacity.
    The range is 0–100. The default value is 100. If you leave this parameter set to 100, the
    percentages are 100% for On-Demand Instances and 0% for Spot Instances.

    * spot_allocation_strategy (String) - Indicates how to allocate Spot capacity across Spot pools.
    The only valid value is "lowest-price", which is also the default value. The Auto Scaling group
    selects the cheapest Spot pools and evenly allocates your Spot capacity across the number of
    Spot pools that you specify.

    * spot_instance_pools (Integer) - The number of Spot pools to use to allocate your Spot capacity.
    The Spot pools are determined from the different instance types in the Overrides array of
    launch_template. The range is 1–20 and the default is 2.

    * spot_max_price (String) - The maximum price per unit hour that you are willing to pay for a
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

    * launch_template_specification - The launch template to use. You must specify either
    the launch template ID or launch template name in the request.

    * overrides - Any parameters that you specify override the same parameters in the
    launch template. Currently, the only supported override is instance type
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

    * instances_distribution - The instances distribution to use. If you leave this parameter
    unspecified when creating the group, the default values are used.

    * launch_template - The launch template and overrides.This parameter is required when
    creating an Auto Scaling group with a mixed instances policy, but is not required when
    updating the group.
  """
  @type mixed_instances_policy :: [
          instances_distribution: instances_distribution,
          launch_template: launch_template
        ]

  @typedoc """
    Describes a tag for an Auto Scaling group.

  ## Keys

    * key (String) - The tag key. Length Constraints: Minimum length of 1. Maximum length of 128.
    Required.

    * propagate_at_launch (Boolean) - Determines whether the tag is added to new instances as
    they are launched in the group.

    * resource_id (String) - The name of the group.

    * resource_type (String) - The type of resource. The only supported value is "auto-scaling-group".

    * value (String) - The tag value. Length Constraints: Minimum length of 0. Maximum length of 256.

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

    * availability_zones (List) - One or more Availability Zones for
    the group. This parameter is optional if you specify one
    or more subnets. Minimum number of 1 item. Maximum number
    is 255.

    * default_cool_down (Integer) - The amount of time, in seconds,
    after a scaling activity completes before another scaling
    activity can start. The default value is 300.

    * desired_capacity (Integer) - The number of EC2 instances that
    should be running in the group. This number must be greater than
    or equal to the minimum size of the group and less than or equal
    to the maximum size of the group. If you do not specify a desired
    capacity, the default is the minimum size of the group.

    * health_check_grace_period (Integer) - The amount of time, in seconds,
    that Amazon EC2 Auto Scaling waits before checking the health status of
    an EC2 instance that has come into service. During this time, any health
    check failures for the instance are ignored. The default value is 0.
    This parameter is required if you are adding an ELB health check.

    * health_check_type (String) - The service to use for the health checks.
    The valid values are "EC2" and "ELB".

    * launch_configuration_name (String) - The name of the launch configuration.
    This parameter, a launch template, a mixed instances policy, or an EC2
    instance must be specified.

    * launch_template - The launch template to use to launch instances. This
    parameter, a launch configuration, a mixed instances policy, or an EC2
    instance must be specified.

    * lifecycle_hook_specification_list - One or more lifecycle hooks.

    * load_balancer_names - One or more Classic Load Balancers. To specify an
    Application Load Balancer or a Network Load Balancer, use target_group_ARNS
    instead.

    * mixed_instances_policy - The mixed instances policy to use to launch instances.
    This parameter, a launch template, a launch configuration, or an EC2 instance
    must be specified.

    * new_instances_protected_from_scale_in (Boolean) - Indicates whether newly launched
    instances are protected from termination by Auto Scaling when scaling in.
    For more information about preventing instances from terminating on scale in, see
    Instance Protection in the Amazon EC2 Auto Scaling User Guide.

    * placement_group (String) - The name of the placement group into which to launch
    your instances, if any. For more information, see Placement Groups in the Amazon
    EC2 User Guide for Linux Instances.

    * service_linked_role_arn (String) - The Amazon Resource Name (ARN) of the service-linked
    role that the Auto Scaling group uses to call other AWS services on your behalf. By default,
    Amazon EC2 Auto Scaling uses a service-linked role named AWSServiceRoleForAutoScaling,
    which it creates if it does not exist. For more information, see Service-Linked Roles in
    the Amazon EC2 Auto Scaling User Guide.

    * tags (List of Tag) - One or more tags

    * target_group_arns (List of String) - The Amazon Resource Names (ARN) of the target groups.

    * termination_policies (List of String) - One or more termination policies used to select the
    instance to terminate. These policies are executed in the order that they are listed. For more
    information, see "Controlling Which Instances Auto Scaling Terminates During Scale In" in the
    Amazon EC2 Auto Scaling User Guide.

    * vpc_zone_identifier - A comma-separated list of subnet identifiers for your virtual private
    cloud (VPC)
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
    Describes an Amazon EBS volume. Used in combination with `t:block_device_mapping/0`

  ## Keys

    * delete_on_termination (Boolean) - Indicates whether the volume is deleted on
    instance termination. The default value is true.

    * encrypted (Boolean) - Specifies whether the volume should be encrypted.
    Encrypted EBS volumes must be attached to instances that support Amazon EBS
    encryption. Volumes that are created from encrypted snapshots are automatically
    encrypted. There is no way to create an encrypted volume from an unencrypted
    snapshot or an unencrypted volume from an encrypted snapshot. If your AMI uses
    encrypted volumes, you can only launch it on supported instance types. For more
    information, see Amazon EBS Encryption in the Amazon EC2 User Guide for Linux Instances.

    * iops (Integer) - The number of I/O operations per second (IOPS) to provision for
    the volume. For more information, see Amazon EBS Volume Types in the Amazon EC2 User
    Guide for Linux Instances. Constraint: Required when the volume type is io1. (Not
    used with standard, gp2, st1, or sc1 volumes.) Valid Range: Minimum value of 100.
    Maximum value of 20000.

    * snapshot_id (String) - The ID of the snapshot. This parameter is optional if you
    specify a volume size.

    * volume_size (Integer) - The volume size, in GiB. Constraints: 1-1,024 for standard,
    4-16,384 for io1, 1-16,384 for gp2, and 500-16,384 for st1 and sc1. If you specify a
    snapshot, the volume size must be equal to or larger than the snapshot size.
    Default: If you create a volume from a snapshot and you don't specify a volume size,
    the default is the snapshot size. Valid Range: Minimum value of 1. Maximum value of 16384.

    * volume_type (String) - The volume type, which can be "standard" for Magnetic, "io1" for
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

    * device_name (String) - The device name exposed to the EC2 instance (for
    example, /dev/sdh or xvdh). For more information, see Device Naming on Linux
    Instances in the Amazon EC2 User Guide for Linux Instances.

    * ebs - The information about the Amazon EBS volume.

    * no_device (Boolean) - Suppresses a device mapping. If this parameter is true for
    the root device, the instance might fail the EC2 health check. In that case,
    Amazon EC2 Auto Scaling launches a replacement instance.

    * virtual_name (String) - The name of the virtual device (for example, ephemeral0).
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

    * associate_public_ip_address (Boolean) - Used for groups that launch instances into a virtual
    private cloud (VPC). Specifies whether to assign a public IP address to each instance.
    For more information, see Launching Auto Scaling Instances in a VPC in the Amazon EC2
    Auto Scaling User Guide. If you specify this parameter, be sure to specify at least
    one subnet when you create your group. Default: If the instance is launched into a
    default subnet, the default is to assign a public IP address. If the instance is launched
    into a nondefault subnet, the default is not to assign a public IP address.

    * block_device_mappings (List of `t:block_device_mapping/0`) - One or more mappings that
    specify how block devices are exposed to the instance. For more information, see Block
    Device Mapping in the Amazon EC2 User Guide for Linux Instances.

    * classic_link_vpc_id (String) - The ID of a ClassicLink-enabled VPC to link your EC2-Classic
    instances to. This parameter is supported only if you are launching EC2-Classic instances. For
    more information, see ClassicLink in the Amazon EC2 User Guide for Linux Instances and Linking
    EC2-Classic Instances to a VPC in the Amazon EC2 Auto Scaling User Guide.

    * classic_link_vpc_security_groups (List of String) - The IDs of one or more security groups
    for the specified ClassicLink-enabled VPC. This parameter is required if you specify a
    ClassicLink-enabled VPC, and is not supported otherwise. For more information, see ClassicLink
    in the Amazon EC2 User Guide for Linux Instances and Linking EC2-Classic Instances to a VPC in
    the Amazon EC2 Auto Scaling User Guide.

    * ebs_optimized (Boolean) - Indicates whether the instance is optimized for Amazon EBS I/O.
    By default, the instance is not optimized for EBS I/O. The optimization provides dedicated
    throughput to Amazon EBS and an optimized configuration stack to provide optimal I/O performance.
    This optimization is not available with all instance types. Additional usage charges apply.
    For more information, see Amazon EBS-Optimized Instances in the Amazon EC2 User Guide for
    Linux Instances.

    * iam_instance_profile (String) - The name or the Amazon Resource Name (ARN) of the instance
    profile associated with the IAM role for the instance. EC2 instances launched with an IAM role
    automatically have AWS security credentials available. You can use IAM roles with Amazon EC2
    Auto Scaling to automatically enable applications running on your EC2 instances to securely
    access other AWS resources. For more information, see Use an IAM Role for Applications That
    Run on Amazon EC2 Instances in the Amazon EC2 Auto Scaling User Guide.

    * image_id (String) - The ID of the Amazon Machine Image (AMI) to use to launch your EC2 instances.
    If you do not specify instance_id, you must specify image_id.

    * instance_id (String) - The ID of the instance to use to create the launch configuration. The new
    launch configuration derives attributes from the instance, except for the block device mapping.
    If you do not specify instance_id, you must specify both image_id and instance_type.
    To create a launch configuration with a block device mapping or override any other instance
    attributes, specify them as part of the same request. For more information, see Create a Launch
    Configuration Using an EC2 Instance in the Amazon EC2 Auto Scaling User Guide.

    * instance_monitoring (Boolean) - Enables detailed monitoring (true) or basic monitoring
    (false) for the Auto Scaling instances. The default value is true.

    * instance_type (String) - The instance type of the EC2 instance. If you do not specify instance_id,
    you must specify instance_type. For information about available instance types, see Available Instance
    Types in the Amazon EC2 User Guide for Linux Instances.

    * kernel_id (String) - The ID of the kernel associated with the AMI.

    * key_name (String) - The name of the key pair. For more information, see Amazon EC2 Key Pairs in
    the Amazon EC2 User Guide for Linux Instances.

    * placement_tenancy (String) - The tenancy of the instance. An instance with a tenancy of dedicated
    runs on single-tenant hardware and can only be launched into a VPC. To launch Dedicated Instances
    into a shared tenancy VPC (a VPC with the instance placement tenancy attribute set to default), you
    must set the value of this parameter to dedicated. If you specify this parameter, be sure to specify at
    least one subnet when you create your group. For more information, see Launching Auto Scaling Instances
    in a VPC in the Amazon EC2 Auto Scaling User Guide. Valid values: "default" | "dedicated"

    * ramdisk_id (String) - The ID of the RAM disk associated with the AMI.

    * security_groups (List of String) - One or more security groups with which to associate the instances.
    If your instances are launched in EC2-Classic, you can either specify security group names or the
    security group IDs. For more information, see Amazon EC2 Security Groups in the Amazon EC2 User Guide
    for Linux Instances. If your instances are launched into a VPC, specify security group IDs. For more
    information, see Security Groups for Your VPC in the Amazon Virtual Private Cloud User Guide.

    * spot_price (String) - The maximum hourly price to be paid for any Spot Instance launched to fulfill
    the request. Spot Instances are launched when the price you specify exceeds the current Spot market
    price. For more information, see Launching Spot Instances in Your Auto Scaling Group in the Amazon EC2
    Auto Scaling User Guide.

    * user_data (String) - The user data to make available to the launched EC2 instances. For more
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

    * force_delete (Boolean) - Specifies that the group is to be deleted
    along with all instances associated with the group, without waiting for
    all instances to be terminated. This parameter also deletes any lifecycle
    actions associated with the group.
  """
  @type delete_auto_scaling_group_opts :: [
          force_delete: boolean
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

    * auto_scaling_group_name (String) - The name of the Auto Scaling group

    * opts - See `t:attach_instances_opts/0`

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
  @spec attach_instances(auto_scaling_group_name :: binary, opts :: attach_instances_opts) ::
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

    To detach the load balancer from the Auto Scaling group, use `detach_load_balancers/1`.

  ## Parameters

    * auto_scaling_group_name (String) - The name of the Auto Scaling group

    * load_balancer_names (List of String) - The names of the load balancers. You
    can specify up to 10 load balancers.

  ## Examples:

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
    `describe_load_balancer_target_groups\1'.

    To detach the target group from the Auto Scaling group, use
    `detach_load_balancer_target_groups\1'

  ## Example:

        iex> op = ExAws.AutoScaling.attach_load_balancer_target_groups("my-asg", ["my-targetarn"])
        iex> op.params
        %{
            "Action" => "AttachLoadBalancerTargetGroups",
            "AutoScalingGroupName" => "my-asg",
            "TargetGroupARNs.member.1" => "my-targetarn",
            "Version" => "2011-01-01"
        }
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
  """
  @spec batch_put_scheduled_update_group_action(
          auto_scaling_group_name :: binary,
          scheduled_update_group_actions :: scheduled_update_group_actions
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

    * (Optional) Create a Lambda function and a rule that allows CloudWatch Events to invoke your
    Lambda function when Amazon EC2 Auto Scaling launches or terminates instances.

    * (Optional) Create a notification target and an IAM role. The target can be either an Amazon
    SQS queue or an Amazon SNS topic. The role allows Amazon EC2 Auto Scaling to publish lifecycle
    notifications to the target.

    * Create the lifecycle hook. Specify whether the hook is used when the instances launch or
    terminate.

    * If you need more time, record the lifecycle action heartbeat to keep the instance in a
    pending state.

    * If you finish before the timeout period ends, complete the lifecycle action.
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

    * auto_scaling_group_name - The name of the Auto Scaling group. This name
    must be unique within the scope of your AWS account.

    * min_size - The minimum size of the group

    * max_size - The maximum size of the group

    * opts - See `t:create_auto_scaling_group_opts/0`
  """
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

    * launch_configuration_name (String) - The name of the launch configuration.
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

    * tags (List of `t:tag/0`) - One or more tags.
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

    * auto_scaling_group_name (String) - The name of the Auto Scaling group.

    * opts (`t:delete_auto_scaling_group_opts`)
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
    Describes one or more Auto Scaling groups
  """
  @spec describe_auto_scaling_groups() :: ExAws.Operation.Query.t()
  @spec describe_auto_scaling_groups(opts :: describe_auto_scaling_groups_opts) ::
          ExAws.Operation.Query.t()
  def describe_auto_scaling_groups(opts \\ []) do
    opts |> build_request(:describe_auto_scaling_groups)
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
