#---
# Excerpted from "Programming Ecto",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wmecto for more book information.
#---
##############################################
## Ecto Playground
#
# This script sets up a sandbox for experimenting with Ecto. To
# use it, just add the code you want to try into the Playground.play/0
# function below, then execute the script via mix:
#
#   mix run priv/repo/playground.exs
#
# The return value of the play/0 function will be written to the console
#
# To get the test data back to its original state, just run:
#
#   mix ecto.reset
#
alias MusicDB.Repo
alias MusicDB.{Artist, Album, Track, Genre, Log, AlbumWithEmbeds, ArtistEmbed, TrackEmbed}
alias Ecto.Multi

import Ecto.Query
import Ecto.Changeset

defmodule Playground do
  # this is just to hide the "unused import" warnings while we play
  def this_hides_warnings do
    [Artist, Album, Track, Genre, Repo, Multi, Log, AlbumWithEmbeds, ArtistEmbed, TrackEmbed]
    from(a in "artists")
    from(a in "artists", where: a.id == 1)
    cast({%{}, %{}}, %{}, [])
  end

  def albums_by_artist(artist_name) do
    from a in "albums",
      join: ar in "artists", on: a.artists_id == ar.id,
      where: ar.name == ^artist_name
  end

  def by_artist(query, artist_name) do
    from a in query,
      join: ar in "artists", on: a.artist_id == ar.id,
      where: ar.name == ^artist_name
  end

  def with_tracks_longer_than(query, duration) do
    from a in query,
    join: t in "tracks", on: t.album_id == a.id,
    where: t.duration > ^duration,
    distinct: true
  end

  def title_only(query), do: from a in query, select: a.title

  def validate_birth_date_in_the_past(changeset, field) do
    validate_change(changeset, :birth_date, fn _field, value ->
        cond do
          is_nil(value) -> []
          Date.compare(value, Date.utc_today()) == :lt -> []
          true -> [{field, "must be in the past"}]
        end
    end)
  end

  def play do
    ###############################################
    #
    # PUT YOUR TEST CODE HERE
    #
    ##############################################

    "albums"
    |> by_artist("Miles Davis")
    |> with_tracks_longer_than(720)
    |> title_only()
    |> Repo.all()

    params = %{"name" => "Theolonius Monk", "birth_date" => "2117-10-10"}
    changeset =
      %Artist{}
      |> cast(params, [:name, :birth_date])
      |> validate_birth_date_in_the_past(:birth_date)

      changeset.errors

      from(g in Genre)
      |> where([g], g.name == ^"bebop")
      |> Repo.one()
      |> case do
         nil -> :noop
         genre -> Repo.delete(genre)
      end

      Repo.insert!(%Genre{name: "bebop"})

      params = %{"name" => "bebop"}
      changeset =
        %Genre{}
        |> cast(params, [:name])
        |> validate_required(:name)
        |> validate_length(:name, min: 3)
        |> unique_constraint(:name)

        case Repo.insert(changeset) do
          {:ok, _genre} -> IO.puts("Success!")
          {:error, changeset} -> changeset.errors
        end
  end
end

# add your test code to Playground.play above - this will execute it
# and write the result to the console
IO.inspect(Playground.play())
