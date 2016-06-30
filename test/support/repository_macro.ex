defmodule Matchup.RepositoryTestMacro do

  defmacro test_repository(repository) do
    quote do
      use Matchup.DomainCase

      def repository do
        unquote(repository)
      end

      setup do
        {:ok, artists} = repository.collection("artists")
        :ok = repository.clear(artists)

        john =  %{"name" => "John Lennon", "band" => "Beatles"}
        yoko =  %{"name" => "Yoko Ono", "band" => "None"}

        :ok = repository.create(artists, "john", john)
        :ok = repository.create(artists, "yoko", yoko)

        {:ok, artists: artists, john: john, yoko: yoko}    
      end
    
      test "#create and #read", %{artists: artists, john: john} do
        ^john = repository.read(artists, "john")
      end

      test "#read nonexistent", %{artists: artists} do
        nil = repository.read(artists, "missing")
      end

      test "#update and #read", %{artists: artists} do
        married_yoko = %{"band" => "Beatles"}
        :ok = repository.update(artists, "yoko", married_yoko)
        ^married_yoko = repository.read(artists, "yoko")
      end

      test "#update nonexistent", %{artists: artists} do
        :error = repository.update(artists, "missing", %{"some" => "data"})
      end

      test "#search all", %{artists: artists, john: john, yoko: yoko} do
        results = repository.search(artists)
        assert_contain_exactly results, [john, yoko]
      end

      test "#search by attribute", %{artists: artists, john: john} do
        results = repository.search(artists, %{"name" => "John Lennon"})
        assert_contain_exactly results, [john]
      end

    end
  end

end
