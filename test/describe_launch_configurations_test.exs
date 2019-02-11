defmodule DescribeLaunchConfigurationsTest do
  use ExUnit.Case

  test "simple describe" do
    op = ExAws.AutoScaling.describe_launch_configurations()

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DescribeLaunchConfigurations"
           }
  end

  test "describe for one launch config" do
    op = ExAws.AutoScaling.describe_launch_configurations(launch_configuration_names: ["my-lc"])

    assert op.params == %{
             "Action" => "DescribeLaunchConfigurations",
             "Version" => "2011-01-01",
             "LaunchConfigurationNames.member.1" => "my-lc"
           }
  end
end
