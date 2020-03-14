defmodule TodoBoard.Todo do
  @moduledoc """
  Representation of a TODO item

  Fields represent the subset of data that is currently perceived useful.
  """

  alias TodoBoard.Rating

  @enforce_keys [
    :description,
    :source_data,
    :status,
    :tags,
    :inserted_at
  ]
  defstruct [
    :description,
    :due_date,
    :project,
    :rating,
    :rating_deviation,
    :rating_volatility,
    :source_data,
    :status,
    :tags,
    :uuid,
    :completed_at,
    :inserted_at,
    :updated_at
  ]

  def build(task = %Taskwarrior.Task{}) do
    %__MODULE__{
      description: task.description,
      due_date: task.due,
      project: task.project,
      rating:
        Rating.build(
          task.udas.rating_true,
          task.udas.rating_deviation,
          task.udas.rating_volatility
        ),
      source_data: task,
      status: task.status,
      tags: task.tags,
      uuid: task.uuid,
      completed_at: task.end,
      inserted_at: task.entry,
      updated_at: task.modified
    }
  end
end
