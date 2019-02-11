defmodule DeleteTagsTest do
  use ExUnit.Case

  test "simple delete" do
    tags = [
      [
        key: "environment",
        resource_id: "my-asg",
        resource_type: "auto-scaling-group"
      ],
      [
        key: "project",
        resource_id: "my-asg",
        resource_type: "auto-scaling-group"
      ]
    ]

    op = ExAws.AutoScaling.delete_tags(tags)

    assert op.params == %{
             "Version" => "2011-01-01",
             "Action" => "DeleteTags",
             "Tags.1.Key" => "environment",
             "Tags.1.ResourceId" => "my-asg",
             "Tags.1.ResourceType" => "auto-scaling-group",
             "Tags.2.Key" => "project",
             "Tags.2.ResourceId" => "my-asg",
             "Tags.2.ResourceType" => "auto-scaling-group"
           }
  end
end
