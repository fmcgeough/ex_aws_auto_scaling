defmodule SetInstanceHealthTest do
  use ExUnit.Case

  test "mark instance Unhealthy in ASG" do
    op =
      ExAws.AutoScaling.set_instance_health("i-12345678", "Unhealthy",
        should_respect_grace_period: true
      )

    assert op.params == %{
             "Action" => "SetInstanceHealth",
             "Version" => "2011-01-01",
             "HealthStatus" => "Unhealthy",
             "InstanceId" => "i-12345678",
             "ShouldRespectGracePeriod" => true
           }
  end
end
