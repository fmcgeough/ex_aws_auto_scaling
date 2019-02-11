defmodule CreateOrUpdateTagsTest do
  use ExUnit.Case

  test "basic tagging test" do
    tags = [
      [
        key: "environment",
        propogate_at_launch: true,
        resource_id: "my-asg",
        resource_type: "auto-scaling-group",
        value: "test"
      ],
      [
        key: "project",
        propogate_at_launch: true,
        resource_id: "my-asg",
        resource_type: "auto-scaling-group",
        value: "sample"
      ]
    ]

    op = ExAws.AutoScaling.create_or_update_tags(tags)

    assert op.params == %{
             "Action" => "CreateOrUpdateTags",
             "Tags.1.Key" => "environment",
             "Tags.1.PropogateAtLaunch" => true,
             "Tags.1.ResourceId" => "my-asg",
             "Tags.1.ResourceType" => "auto-scaling-group",
             "Tags.1.Value" => "test",
             "Tags.2.Key" => "project",
             "Tags.2.PropogateAtLaunch" => true,
             "Tags.2.ResourceId" => "my-asg",
             "Tags.2.ResourceType" => "auto-scaling-group",
             "Tags.2.Value" => "sample",
             "Version" => "2011-01-01"
           }
  end
end
