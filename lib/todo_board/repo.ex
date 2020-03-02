defmodule TodoBoard.Repo do
  @callback read_all() :: {:ok, [%TodoBoard.Todo{}]} | {:error, term()}
  @callback write_all([%TodoBoard.Todo{}]) :: :ok | {:error, term()}
end
