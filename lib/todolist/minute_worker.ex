defmodule TodoList.MinuteWorker do
  use Oban.Worker

  alias TodoList.Lists

  @impl Oban.Worker
  def perform(_job) do
    Lists.archive_items_within_last_24_hours()
    IO.inspect("Change Archived status successfuly!")
    :ok
  end
end
