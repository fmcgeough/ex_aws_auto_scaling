defmodule DescribeAccountLimitsTest do
  use ExUnit.Case

  test "simple describe" do
    op = ExAws.AutoScaling.describe_account_limits()

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DescribeAccountLimits"
           }
  end
end
