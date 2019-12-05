# frozen_string_literal: true

module Enumerable #:nodoc:
  def my_each
    return to_enum(:my_each) unless block_given?

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

  def my_all?(arg = nil)
    if block_given?
      my_each { |x| return false unless yield(x) }
    elsif !arg.nil?
      if arg.is_a?(Regexp)
        my_each { |x| return false unless arg =~ x.to_s }
      else
        my_each { |x| return false unless x.is_a?(arg) }
      end
    else
      my_each { |x| return false unless x }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given? && arg.nil?
      my_each { |x| return true if yield(x) }
    elsif arg.nil?
      my_each { |x| return true if x }
    elsif arg
      my_each { |x| return true if class_regex(x, arg) }
    elsif !block_given? && arg.nil?
      my_each { |x| return true if x }
    else
      my_each { |x| return true if arg == x }
    end
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
        counter += 1 if yield(x)
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

  def my_inject(arg = nil)
    acc = nil
    nxt = nil
    start = nil
    if arg.nil?
      acc = self[0]
      nxt = self[1]
      start = 1
    else
      acc = arg
      nxt = self[0]
      start = 0
    end

    return unless block_given?
      [start...size].each do |i|
        acc = yield(acc, nxt)
        nxt = self[i + 1]
      end
      acc
    end
  end

  def class_regex(alpha, arg)
    if arg.is_a?(Regexp)
      return true if alpha.to_s.match(arg)
    elsif arg.is_a?(String) || arg.is_a?(Integer) || arg.is_a?(Symbol)
      return true if alpha == arg
    elsif arg.is_a?(Class)
      return true if alpha.instance_of? arg
    end
  end
end

def multiply_els(arr)
  arr.my_inject { |a, b| a * b }
end
