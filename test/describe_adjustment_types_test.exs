defmodule DescribeAdjustmentTypesTest do
  use ExUnit.Case

  test "simple describe" do
    op = ExAws.AutoScaling.describe_adjustment_types()

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DescribeAdjustmentTypes"
           }
  end
end
