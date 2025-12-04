cd(@__DIR__)
rot =  readlines("utils_01_1.txt")

function mathify_rotations(rot_str::AbstractArray{<:AbstractString}) 
    #* takes a string vector containing rotation instructions and converts it to a integer vector with positivve and negative distances
    @assert all(s -> length(s) >= 2, rot_str) "Not all strings have length >= 2 therefore this can't be a valid rotation encoding" # error handling 
    dir_ind = first.(rot_str) # extracting the direction Letters
    dist_str = chop.(rot_str, head=1, tail=0) # remofing the first char of each string, aka extracting the distance numbers
    @assert all(s -> s ∈ ['R', 'L'], dir_ind) "the direction Indicator (first value) does not follow santas R / L Standarts" # error handling directions
    dir = [i == 'R' ? 1 : -1 for i ∈ dir_ind] # direction encoding
    dist = tryparse.(Int, dist_str) # distances encoding (tryparse doesn't fail if not a number string, but returns nothing)
    @assert !any(isnothing, dist) "Vector contains something that cant be interpreted as a Natural number after the direction Indicators" # error handling distances 
    return dir .* dist
end

movements = mathify_rotations(rot) # integer encoded rotation instructions
dial_positions = cumsum(movements) # the time when we apply mod does not matter so we dont do it every step
#! this works as long as we dont have instructions that would bring us over the integer limit, because then the overflow is in base 2 and not base 100 and this is not that much combatible
dial_positions .+= 50 #we start at position 50
dial_positions .%= 100 # and finally its a dial, not a line

zero_hits = sum(dial_positions .== 0) # check how often we land on 0

print(zero_hits)