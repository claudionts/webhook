defmodule Webhook.GithubConsumer do
  require Logger
  use Broadway
  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      context: %{},
      producer: [
        module: {
          BroadwayKafka.Producer,
          [
            hosts: "localhost:9093",
            group_id: "brod_producer",
            topics: ["github"]
          ]
        },
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 10]
      ]
    )
  end

  @impl Broadway
  def handle_message(_, %Message{data: data, metadata: meta} = message, _ctx) do
    Logger.info("Got message from topic #{meta[:topic]}")

    {:ok, decoded} = Jason.decode(data)

    Webhook.ScheduleJob.new(decoded)
    |> Oban.insert()

    message
  end

  @impl Broadway
  def handle_failed(messages, _ctx) do
    Logger.info("#{Enum.count(messages)} failed messages")

    messages
  end
end
