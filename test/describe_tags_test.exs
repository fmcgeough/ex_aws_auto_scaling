defmodule DescribeTagsTest do
  use ExUnit.Case

  test "describe tags no params" do
    op = ExAws.AutoScaling.describe_tags()

    assert op.params == %{
             "Action" => "DescribeTags",
             "Version" => "2011-01-01"
           }
  end

  test "describe tags with filtering" do
    filter1 = [name: "auto-scaling-group", values: ["my-asg-1", "my-asg-2"]]
    filter2 = [name: "auto-scaling-group", values: ["my-asg-3", "my-asg-4"]]
    op = ExAws.AutoScaling.describe_tags(filters: [filter1, filter2])

    assert op.params == %{
             "Action" => "DescribeTags",
             "Filters.member.1.Name" => "auto-scaling-group",
             "Filters.member.1.Values.member.1" => "my-asg-1",
             "Filters.member.1.Values.member.2" => "my-asg-2",
             "Version" => "2011-01-01",
             "Filters.member.2.Name" => "auto-scaling-group",
             "Filters.member.2.Values.member.1" => "my-asg-3",
             "Filters.member.2.Values.member.2" => "my-asg-4"
           }
  end
end
