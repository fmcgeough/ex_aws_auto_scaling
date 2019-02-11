defmodule DeleteLaunchConfigurationTest do
  use ExUnit.Case

  test "simple delete" do
    op = ExAws.AutoScaling.delete_launch_configuration("my-launch-config")

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DeleteLaunchConfiguration",
             "LaunchConfigurationName" => "my-launch-config"
           }
  end
end
