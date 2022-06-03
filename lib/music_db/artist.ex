defmodule MusicDB.Artist do
  use Ecto.Schema

  schema "artists" do
    field(:name, :string)
    field(:birth_date, :date)
    field(:death_date, :date)
    timestamps()

    has_many(:albums, MusicDB.Album, on_replace: :nilify)
    has_many(:tracks, through: [:albums, :tracks])
  end
end
