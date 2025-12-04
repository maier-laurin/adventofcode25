#---- reading data -------------------------------------------------------------

#//val_id = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
cd(@__DIR__)
val_id = read("data_02.txt", String)

#---- function defenitions -----------------------------------------------------

function is_sillypattern(num::Int)
    #* checks if a number is silly pattern as described in the taskdescription
    @assert num > 0 "ids can't be negative" # the task falls appart for negative numbers
    digs = digits(num) #split the number into its digits
    n = length(digs)
    if isodd(n)
        return false # if the number of digits is not even how can the number repeat
    end
    return digs[1:n÷2] == digs[(n÷2+1):end] # check if first and second half of the digits are the same
end

function find_spsum_in_range(min, max)
    #* loops throug a range and summs up all the silly patterns in there
    sum = 0
    for i ∈ min:max
        if is_sillypattern(i)
            sum += i
        end
    end
    return sum
end

function read_input(inp)
    #* reads the input string and parses it
    str_arr = split(inp, ",") # split string at separators
    rang_arr = [parse.(Int, split(line, "-")) for line ∈ str_arr] #split pairs and parse them as integers
    return rang_arr
end

#---- Task 1 -------------------------------------------------------------------

valid_ranges = read_input(val_id) # preparin the ranges we will investigate
overallsum = 0 # container for the overall sum
for rngs ∈ valid_ranges # loop through all the ranges
    overallsum += find_spsum_in_range(rngs[1], rngs[2])
end
print(overallsum)
