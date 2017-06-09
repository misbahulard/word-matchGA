module WordMatch
  ALLOWED_LETTER = (32..122).to_a.map {|i| i.chr}
  TOURNAMENT_ROUND = 3

  class Chromosome
    attr_accessor :gen, :gen_arr, :target_arr

    class << self

      def set_target(target)
        @@target = target
      end

      def rand_gen
        str = ''
        @@target.size.times do
          str << ALLOWED_LETTER[rand(ALLOWED_LETTER.size - 1)]
        end
        Chromosome.new(str)
      end

      def to_int_array(str)
        out = []
        str.each_byte do |c|
          out << c
        end
        out
      end
    end

    def initialize(str = '')
      @gen = str
      @gen == '' ? Chromosome.rand_gen : str
      @gen_arr ||= Chromosome.to_int_array(@gen)
      @target_arr ||= Chromosome.to_int_array(@@target)
    end

    def fitness
      @fitness ||=
      begin
        diff = 0
        gen_arr.size.times do |i|
          diff += (gen_arr[i].to_i - target_arr[i].to_i).abs
        end
        diff
      end
    end

    def mate partner
      pivot = rand(gen_arr.size - 1)
      newGen1 = (gen[0..pivot] + partner.gen[pivot+1..-1])
      newGen2 = (partner.gen[0..pivot] + gen[pivot+1..-1])
      [Chromosome.new(newGen1), Chromosome.new(newGen2)]
    end

    def mutate
      new_str = gen.clone
      new_str[rand(@gen.size)] = ALLOWED_LETTER[rand(ALLOWED_LETTER.size)]
      Chromosome.new(new_str)
    end
  end

  class Population
    attr_accessor :population

    def initialize(size, crossover, mutation, elitism)
      @size = size
      @crossover = crossover
      @mutation = mutation
      @elitism = elitism

      buf = []
      @size.times do
        buf << Chromosome.rand_gen
      end

      @population = buf.sort! {|a, b| a.fitness <=> b.fitness}
    end

    def tournament_selection
      best = @population[rand(@population.size)]
      TOURNAMENT_ROUND.times do |i|
        enemy = @population[rand(@population.size)]
        best = enemy if enemy.fitness < best.fitness
      end
      best
    end

    def evolve
      elitism_mark = (@elitism * @population.size)
      buf = @population[0..elitism_mark]
      sub_pop = @population[elitism_mark+1..-1]
      sub_pop.each_with_index do |chrom, index|
        if rand <= @crossover
          parent1 = tournament_selection
          parent2 = tournament_selection
          children = parent1.mate parent2
          children[0] = children[0].mutate if rand < @mutation
          children[1] = children[1].mutate if rand < @mutation
          buf += children
        else
          chrom = chrom.mutate if rand < @mutation
          buf << chrom
        end
        break if buf.size >= @size
      end
      @population = (buf + @population[elitism_mark+1..@size]).sort! {|a, b| a.fitness <=> b.fitness}
    end
  end
end