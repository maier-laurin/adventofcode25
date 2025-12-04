#---- reading data -------------------------------------------------------------

bb = [  "987654321111111", "811111111111119", "234234234234278", "818181911112111"]
cd(@__DIR__)
bb =  readlines("data_03.txt")
#---- function defenitions -----------------------------------------------------

function preab_baterie_banks(bb_str::AbstractVector{<:AbstractString})
    return [parse.(Int16, collect(i)) for i ∈ bb_str] # split each batterie bank into a vector of batteries
end

#---- Task 1 -------------------------------------------------------------------

batteries = preab_baterie_banks(bb)
first_bat = [argmax(b[1:(end-1)]) for b ∈ batteries] # finding the best canditate for the first batterie
#// second_bat = zeros(Int, length(first_bat)) # placeholder array for the second batterie, this one isn't possible with array comprehension anymore
bank_joltage = zeros(Int, length(first_bat)) #stores the total joltage of each bank
for i ∈ eachindex(bank_joltage) # finding the best capazity for each bank by using the allready decided first batterie and the best choce for the second one
    #//second_bat[i] = argmax(batteries[i][(first_bat[i]+1):end])+first_bat[i]
    bank_joltage[i] = batteries[i][first_bat[i]] * 10 + maximum(batteries[i][(first_bat[i]+1):end]) # we don't need the position just the value of the second batterie
end
print(sum(bank_joltage))

