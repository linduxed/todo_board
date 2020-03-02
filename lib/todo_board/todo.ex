defmodule TodoBoard.Todo do
  defstruct [
    :description,
    :due_date,
    :project,
    :source_data,
    :status,
    :tags,
    :completed_at,
    :inserted_at,
    :updated_at
  ]

  def build(task = %Taskwarrior.Task{}) do
    %__MODULE__{
      description: task.description,
      due_date: task.due,
      project: task.project,
      source_data: task,
      status: task.status,
      tags: task.tags,
      completed_at: task.end,
      inserted_at: task.entry,
      updated_at: task.modified
    }
  end
end
