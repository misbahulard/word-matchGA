# Misbahul Ardani - 2110151002
# Word Match with Genetics Algorithm
# Artificial Intelligence Project 2017
# Politeknik Elektronika Negeri Surabaya
# Informatics Engineering

require './wordmatch'

if ARGV.empty? || ARGV.include?("-h") || ARGV.include?("--help")
  puts "Program Algoritma Genetika 'Word Matching' oleh Misbahul Ardani, 2017"
  puts "Penggunaan: ruby main.rb"
  puts "  --help"
  puts "  --text<=string>     String to match"
  puts "  --size=<number>     population size"
  puts " --crossover=<float>  portion each generation subject to replacement by new combination of two parents (ex: 0.3)"
  puts " --mutation=<number>  chance that a newly crossed over child will mutate (ex: 0.4)"
  puts " --elitism=<float>    portion each generation that will be preserved"
end

target = ARGV.find {|i| i.include? ("--text")}
target = target.split("=")[1].to_s if target
target ||= 'Hello World!'

WordMatch::Chromosome.set_target(target)

size = ARGV.find {|i| i.include? ("--size")}
size = size.split("=")[1].to_s if size
size ||= 2048

crossover = ARGV.find {|i| i.include?("--crossover")}
crossover = crossover.split('=')[1].to_i if crossover
crossover ||= 0.8

mutation = ARGV.find {|i| i.include?("--mutation")}
mutation = mutation.split('=')[1].to_i if mutation
mutation ||= 0.3

elitism = ARGV.find {|i| i.include?("--elitism")}
elitism = elitism.split("=")[1].to_f if elitism
elitism ||= 0.1

puts "\nTarget: #{target}, Size: #{size}, Crossover: #{crossover}, Mutation: #{mutation}, Elitism: #{elitism}"

# Create new population
pop = WordMatch::Population.new(size, crossover, mutation, elitism)
# Current Generation
cur_gen = 0
# Max Generation
max_gen = 14045
# Flag for check condition
finished = false

while cur_gen <= max_gen && !finished
  finished = false
  puts "Gen: #{cur_gen}: #{pop.population[0].gen} fitness: #{pop.population[0].fitness}"

  if pop.population[0].fitness == 0
    puts "Finished! Gen: #{cur_gen}: #{pop.population[0].gen}"
    finished = true
  else
    # Evolve the population
    pop.evolve
  end
  cur_gen += 1
  puts "Reach max! The best generation: #{pop.population[0].gen}" if cur_gen > max_gen
end