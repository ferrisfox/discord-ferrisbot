require './command.rb'

# roll a dice
class Roll < Command
  @@all += [self]

  def self.execute(event, args)
    super(event, args)

    sides = 6 unless (sides = args[0].to_i) >= 1
    "Rolled a #{(rand(sides) + 1)}."
  end
end

# flips a coin
class Coin < Command
  @@all += [self]

  def self.execute(event, args)
    super(event, args)
    "Landed on #{%w[heads tails][rand(2)]}."
  end
end
