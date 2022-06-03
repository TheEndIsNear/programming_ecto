defmodule MusicDB.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field(:title, :string)
    timestamps()

    has_many(:tracks, MusicDB.Track)
    belongs_to(:artist, MusicDB.Artist)

    many_to_many(:genres, MusicDB.Genre, join_through: "albums_genres")
  end

  def changeset(album, params) do
    album
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
