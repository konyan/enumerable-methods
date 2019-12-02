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
        return to_enum(:my_each_with_index)  unless block_given?
        i=0
        while i< self.size
            yield(self[i],i)
            i+=1
        end
        self
    end

    def my_select
        i=0
        new_array = []
        while i< self.size
            if yield(self[i] )== true
                new_array << self[i]
            end
            i+=1
        end
        new_array
    end

    def my_all
        i = 0 
        while i < self.size
            # break something wrong
            if yield(self[i]) == false || yield(self[i]) == nil
                return false
            end
            i +=1
        end
        true
    end

end

my_n_array = [1, 2, 3, 4]


my_n_array.my_each_with_index

# my_n_array.select { |x| puts x == 1}


# TEST for my_select
# numbers = [1, 2, 3, 4, 5, 6]
# p numbers.my_select { |x| x.even? }
# p numbers.my_select { |x| x.odd?}

# p numbers.my_all { |x| x > 2}
# p [nil, true, 9].my_all { |x| x == true}