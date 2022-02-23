defmodule Webhook.GithubProducer do
  def send_message(data) do
    client_id = :american_orders
    hosts = [localhost: 9092]
    :ok = :brod.start_client(hosts, client_id)
    :ok = :brod.start_producer(client_id, "pedidos", [])

    :brod.produce(client_id, "pedidos", :rand.uniform(3) - 1, Integer.to_string(:rand.uniform(3000)), data)
  end
end
