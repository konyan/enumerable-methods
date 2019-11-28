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

end

my_n_array = [1, 2, 3, 4]


my_n_array.my_each do |x|
    puts x
end

my_n_array.my_each_with_index do |x,index|
    puts "#{x} , #{index}"
end

# my_n_array.select { |x| puts x == 1}


# TEST for my_select
numbers = [1, 2, 3, 4, 5, 6]
p numbers.my_select { |x| x.even? }
p numbers.my_select { |x| x.odd?}

p numbers.my_all { |x| x > 2}
