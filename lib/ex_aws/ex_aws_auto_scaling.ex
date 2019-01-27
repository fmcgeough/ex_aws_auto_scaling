defmodule ExAws.AutoScaling do
  @moduledoc """
    Operations on AWS EC2 Auto Scaling
  """
  use ExAws.Utils,
    format_type: :xml,
    non_standard_keys: %{}

  # version of the AWS API
  @version "2011-01-01"
  @member_actions [
    :auto_scaling_group_names,
    :load_balancer_names,
    :instance_ids,
    :target_group_arns,
    :scheduled_action_names,
    :scheduled_update_group_actions
  ]

  @type describe_auto_scaling_groups_opts :: [
          auto_scaling_group_names: [binary, ...],
          max_records: integer,
          next_token: binary
        ]

  @type attach_instances_opts :: [
          instance_ids: [binary, ...]
        ]

  @type scheduled_update_group_action_request :: [
          desired_capacity: integer,
          end_time: binary,
          max_size: integer,
          min_size: integer,
          recurrence: binary,
          start_time: binary,
          scheduled_action_name: binary
        ]
  @type scheduled_update_group_actions :: [scheduled_update_group_action_request, ...]

  @type complete_life_cycle_action_opts :: [
          lifecycle_action_token: binary,
          instance_id: binary
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

  ## Example

          iex> op = ExAws.AutoScaling.attach_instances("my-asg", [instance_ids: ["i-12345678"]])
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
    `attach_load_balancer_target_groups/1`.

    To describe the load balancers for an Auto Scaling group, use `describe_load_balancers/1`.

    To detach the load balancer from the Auto Scaling group, use `detach_load_balancers/1`.

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
            "TargetGroupArns.member.1" => "my-targetarn",
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
      ) do
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

  def convert_to_flat_map(opts) do
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

  defp format_param({action, names}) when action in @member_actions do
    action_string = action |> Atom.to_string() |> Macro.camelize()
    names |> format(prefix: "#{action_string}.member")
  end

  defp format_param({key, parameters}) do
    format([{key, parameters}])
  end
end
