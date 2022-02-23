defmodule Webhook.GithubConsumer do
  require Logger
  use Broadway
  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: { 
          BroadwayKafka.Producer,
          [
            hosts: "localhost:9092",
            group_id: "american_orders",
            topics: ["pedidos"],
            client_config: []
          ]
        },
        concurrency: 10
      ],
      processors: [
        default: [
          concurrency: 2
        ]
      ],
      batchers: [
        github_requests: [concurrency: 2, batch_size: 10, batch_timeout: 1000]
      ]
    )
  end

  def handle_message(_, message, _) do
    Message.put_batcher(message, :github_requests)
  end

  def handle_batch(:github_requests, messages, batch_info, context) do
    IO.inspect(messages)
    IO.inspect(batch_info)
    IO.inspect(context)
    messages
    |> Webhook.ScheduleJob.new()
    |> Oban.insert()
  end
end
