defmodule MusicDB.Genre do
  use Ecto.Schema

  schema "genres" do
    field :name, :string
    field :wiki_tag, :string
    timestamps()

    many_to_many :albums, MusicDB.Album, join_through: "albums_genres"
  end
end
