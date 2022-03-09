defmodule Webhook.GithubProducer do
  def send_message(data) do
    :brod.produce_sync_offset(
      :brod_producer,
      "github",
      &random_partitioner/4,
      :undefined,
      data
    )
  end

  defp random_partitioner(_topic, partitions_count, _key, _value) do
    partition = Enum.random(0..(partitions_count - 1))
    {:ok, partition}
  end
end
