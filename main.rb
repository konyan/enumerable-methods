module Enumerable
    def my_each
        i=0;
        while i < self.size
            # yield to_a[i] if block_given
            yield(self[i])
            i+=1
        end
        self
    end
end

my_n_array = [1, 2, 3, 4]


my_n_array.my_each do |x|
    puts x
end