module Enumerable
    def my_each
        i=0;
        while i < self.size
            yield(self[i])
            i+=1
        end
        self
    end

    def my_each_with_index
        return to_enum(:my_each_with_index) unless block_given?
        i=0
        while i< self.size
            yield(self[i],i)
            i+=1
        end
        self
    end

    def my_select
        return to_enum(:my_select) unless block_given?
        i=0
        new_array = []
        my_each{ |x| new_array << x if yield(x)}
        # while i< self.size
        #     if yield(self[i] )== true
        #         new_array << self[i]
        #     end
        #     i+=1
        # end
        new_array
    end

    def my_all?
        # return false unless block_given? && self.nil?
        # i = 0 
        # while i < self.size
        #     # break something wrong
        #     puts self[i]
        #     if yield(self[i]) == false || yield(self[i]) == nil || self[i] == nil
        #         return false
        #     end
        #     i +=1
        # end
        return true if self.size < 1 
        return false if block_given? && self.nil? || !block_given?
        my_each{ |x| return false unless yield(x)}
        
        true
    end

    def my_any?
        return false if self.size < 1 
        return true unless block_given?
        my_each { |x| return true if yield(x)}
        false
    end

end

my_n_array = [1, 2, 3, 4]


# my_n_array.my_each_with_index { |x , index| puts "#{x},#{index}" }

# my_n_array.select { |x| puts x == 1}


# TEST for my_select
numbers = [1, 2, 3, 4, 5, 6]
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

p %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
p %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
p %w[ant bear cat].any?(/d/)                        #=> false
p [nil, true, 99].any?(Integer)                     #=> true
p [nil, true, 99].any?                              #=> true
p [].any?                                           #=> false