population = for _ <- 1..100, do: for(_ <- 1..1000, do: Enum.random(0..1))

evaluate = fn population ->
  Enum.sort_by(population, &Enum.sum/1, &>=/2)
end

selection = fn population ->
  population
  |> Enum.chunk_every(2)
  |> Enum.map(&List.to_tuple(&1))
end

crossover = fn population ->
  population
  |> Enum.reduce(
    [],
    fn {parent1, parent2}, acc ->
      cx_point = :rand.uniform(1000)
      {{h1, t1}, {h2, t2}} = {Enum.split(parent1, cx_point), Enum.split(parent2, cx_point)}
      [h1 ++ t2, h2 ++ t1 | acc]
    end
  )
end

mutation = fn population ->
  population
  |> Enum.map(fn chromosome ->
    if :rand.uniform() < 0.05 do
      Enum.shuffle(chromosome)
    else
      chromosome
    end
  end)
end

algorithm = fn population, algorithm ->
  best = Enum.max_by(population, &Enum.sum/1)
  IO.write("\rCurrent Best: " <> Integer.to_string(Enum.sum(best)))

  if Enum.sum(best) == 1000 do
    best
  else
    # Initial population
    population
    # Evaluate population
    |> evaluate.()
    # Select parents
    |> selection.()
    # Create children
    |> crossover.()
    # Mutate children
    |> mutation.()
    # Recurse
    |> algorithm.(algorithm)
  end
end

solution = algorithm.(population, algorithm)

IO.write("\n Answer is: ")
IO.inspect(solution)
