defmodule MusicDB.Album do
  use Ecto.Schema

  schema "albums" do
    field :title, :string
    timestamps()

    has_many :tracks, MusicDB.Track
    belongs_to :artist, MusicDB.Artist

    many_to_many :genres, MusicDB.Genre, join_through: "albums_genres"
  end
end
