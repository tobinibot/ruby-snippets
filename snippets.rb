# ruby snippets

# >> 25.percent.of 16
# => 4.0
# >> 18.percent.of 321
# => 57.78
class Percentage  
  attr_reader :amount
  def initialize(amount)
    @amount = amount
  end
  
  def of(number)
    number * (amount / 100.0)
  end
end

class Numeric
  def percent
    Percentage.new(self)
  end
end

# ---------

# >> Date.today.at_some_point
# => Tue May 21 10:23:00 -0500 2008
# >> Date.today.at_some_point
# => Tue May 21 02:10:00 -0500 2008
# >> Date.today.at_some_point
# => Tue May 21 18:28:00 -0500 2008
# >> Date.today.at_some_point
# => Tue May 21 07:25:00 -0500 2008
class Date
  def at_some_point
    (at_midnight..tomorrow.at_midnight).to_a.rand
  end
end

# ---------

module Kernel
  def maybe(&block)
    if block_given? && maybe
      block.call
    else
      Kernel.rand(2).zero?
    end
  end
end

module Enumerable
  def some
    map do |element|
      maybe do
        element
      end
    end.compact
  end
end

# ---------

# >> 100_000.reduce_by {|number| !number.very_large?}
# => 6250
# >> 100_000.reduce_by 20.percent {|number| !number.large?}
# => 32
# >> 100_000.reduce
# => 48
class Numeric
  def reduce_by(percentage = 50.percent, &block)
    block ||= Proc.new {|number| number.small?}
    return self if block.call(self)
    reduced_to = self
    until block.call(reduced_to)
       reduced_to = reduced_to.reduce_to(percentage)
    end
    Integer(reduced_to)
  end
  alias_method :reduce, :reduce_by
end