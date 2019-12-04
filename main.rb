# frozen_string_literal: true

module Enumerable #:nodoc:
  def my_each
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_array = []
    my_each { |x| new_array << x if yield(x) }
    new_array
  end

  def my_all?
    return true if size < 1
    return false if block_given? && nil? || !block_given?

    my_each { |x| return false unless yield(x) }
    true
  end

  def my_any?
    return false if size < 1
    return true unless block_given?

    my_each { |x| return true if yield(x) }
    false
  end

  def my_none?(arg = nil)
    if block_given?
      my_each { |x| return false if yield(x) }
    elsif !arg.nil?
      if arg.is_a?(Regexp)
        my_each { |x| return false if pattern =~ x.to_s }
      else
        my_each { |x| return false if x.is_a?(pattern) }
      end
    else
      my_each { |x| return false if x }
    end
    true
  end

  def my_count(arg = nil)
    counter = 0
    my_each do |x|
      if block_given? && arg.nil?
        counter += 1 if yield (x)
      elsif !block_given? && arg
        counter += 1 if x == arg
      elsif !block_given? && arg.nil?
        counter += 1
      end
    end
    counter
  end

  def my_map(arg = nil)
    return to_enum(:my_map) unless block_given?

    arr = []
    if arg.nil?
      my_each { |x| arr << yield(x) }
    else
      my_each { |x| arr << arg.call(x) }
    end
    arr
  end

  def my_inject(*args)
    init = args.size.positive?
    acc = init ? args[0] : self[0]
    drop(init ? 0 : 1).my_each { |item| acc = yield(acc, item) }
    acc
  end
end

def multiply_els(arr)
  multiplied_arr = arr
  multiplied_arr.my_inject do |x, y|
    x * y
  end
end
