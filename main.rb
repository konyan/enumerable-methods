# frozen_string_literal: true

module Enumerable
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
        i=0
        new_array = []
        my_each{ |x| new_array << x if yield(x)}
        new_array
    end

    def my_all?
        return true if self.size < 1 
        return false if block_given? && self.nil? || !block_given?
        my_each{ |x| return false unless yield(x)}
        
        true
    end

    def my_any?(arg = nil)
        return false if self.size < 1 
        return true unless block_given?
        my_each { |x| return true if yield(x)}
        false
    end

    def my_none?(arg = nil)
        if block_given?
            my_each  {|x|  return false if yield(x)}
        elsif !arg.nil?
            if arg.is_a?(Regexp)
                my_each { |x| return false if pattern =~ x.to_s }
            else 
                my_each { |x| return false if x.is_a?(pattern) }
            end
        else
            my_each { |x| return false if x}
        end
        true
    end

    def my_count(arg = nil)
        counter = 0
        my_each do |x|
            if block_given? && arg.nil?
                counter +=1 if yield (x)
            elsif !block_given? && arg
                counter +=1 if x == arg
            elsif !block_given? && arg.nil?
                counter +=1
            end
        end
        counter
    end

    def my_map(arg  = nil)
        return to_enum(:my_map) unless block_given?
        arr = []
        if arg.nil?
            my_each {|x|  arr << yield(x) } 
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

# my_n_array = [1,1, 2,2, 3, 4]
# my_n_array.my_each_with_index { |x , index| puts "#{x},#{index}" }
# my_n_array.select { |x| puts x == 1}


# TEST for my_select
# numbers = [1, 2, 3, 4, 5, 6]
# p numbers.my_select { |x| x > 4 }
# p numbers.my_select { |x| x.odd?}

# p numbers.my_all? { |x| x > 0}
# p [ nil,true, 9].my_all?
# p [ nil,true, 9].all?

# p [].my_all?
# p [].all?

# p numbers.my_any? { |x| x > 0}
# p [].my_any?   

#TEST ANY?
# p %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# p %w[ant bear cat].my_any?(/d/)                        #=> false
# p [nil, true, 99].my_any?(Integer)                     #=> true
# p [nil, true, 99].my_any?                              #=> true
# p [].my_any?                                           #=> false

#TEST NONE
# p %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
# p %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
# p [].my_none?                                           #=> true
# p [nil].my_none?                                        #=> true
# p [nil, false].my_none?                                 #=> true
# p [nil, false, true].my_none?                           #=> false

#TEST COUNT
ary = [1,1,2, 2, 4, 2]
# p ary.my_count               #=> 4
# p ary.my_count(2)            #=> 2
# p ary.my_count{ |x| x%2==0 } #=> 3
# p ary.count{ |x| x%2==0 } #=> 3

#TEST MAP
p ary.my_map { |i| i*i }      #=> [1, 4, 9, 16]


#TEST INJECT
def multiply_els(arr)
    arr.my_inject { |acc, item| acc * item }
end

# p multiply_els(ary)