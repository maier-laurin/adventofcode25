#---- reading data -------------------------------------------------------------

bb = [ "987654321111111", "811111111111119", "234234234234278", "818181911112111"]
cd(@__DIR__)
bb =  readlines("data_03.txt")
#---- function defenitions -----------------------------------------------------

function preab_baterie_banks(bb_str::AbstractVector{<:AbstractString})
    return [parse.(Int16, collect(i)) for i ∈ bb_str] # split each batterie bank into a vector of batteries
end

function dezimalisicinator(arr)
    num = 0
    pow = 0
    for i ∈ reverse(arr)
        num += i * 10^pow
        pow += 1
    end
    return num 
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

#---- Task 2 -------------------------------------------------------------------

#* the same concept on a larger scale

q = 12 # the number of batteries we can turn on per bank

bat_cands = [zeros(Int16, q) for _ ∈ 1:length(batteries)]
bank_joltage = zeros(Int, length(batteries))
for i ∈ eachindex(batteries)
    bat_cands[i][1] = argmax(batteries[i][1:(end-q)]) # find the first canditate
    for j ∈ 2:q
        bat_cands[i][j] = argmax(batteries[i][(bat_cands[i][j-1]+1):(end-q+j)]) + bat_cands[i][j-1] # find all the other canditates on the batteries that are left
    end
    bank_joltage[i] = dezimalisicinator(batteries[i][bat_cands[i]])
end

sum(bank_joltage)
