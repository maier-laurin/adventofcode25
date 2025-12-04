#---- reading data -------------------------------------------------------------

#// rot = ["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]
cd(@__DIR__)
rot =  readlines("data_01.txt")
#---- function defenitions -----------------------------------------------------

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

#---- Task 1 -------------------------------------------------------------------

movements = mathify_rotations(rot) # integer encoded rotation instructions
dial_positions = cumsum(movements) # the time when we apply mod does not matter so we dont do it every step
#! this works as long as we dont have instructions that would bring us over the integer limit, because then the overflow is in base 2 and not base 100 and this is not that much combatible
dial_positions .+= 50 #we start at position 50
dial_positions .%= 100 # and finally its a dial, not a line

zero_hits = sum(dial_positions .== 0) # check how often we land on 0

print(zero_hits)

#---- Task 2 -------------------------------------------------------------------

cur_pos = 50 # current position on the disk
zero_clicks = 0 #counter on how oftn it clicked because of 0
for i ∈ movements  # loof overall the instructions 
    cur_pos_line = cur_pos + i # position on a numberscale not the disc
    #//print("start: " * string(cur_pos) * " , moved: " * string(i) * " , tis is on line: " * string(cur_pos_line))
    if i > 0 #figure out how often we passed 0 tepending on direction of movement 
        zeropases = fld(cur_pos_line, 100) # in case of positive rotation its exactly the hundreds digit of cur pos line
    else 
        if cur_pos_line > 0
            zeropases = 0 # if we are still positive we havn't gone over 0
        else
            if cur_pos == 0 # we allready started in 0 and can't count the first 0 pass
                zeropases = fld(abs(cur_pos_line), 100) 
            else
                zeropases = fld(abs(cur_pos_line), 100) + 1 #otherwise we went over 0 once and once more for every 100th negative

            end
        end
    end
    zero_clicks += zeropases # update zero klicks
    cur_pos = mod(cur_pos_line, 100) # map line to disk
    #//println(" which is: " * string(cur_pos) * " on disc with zeroclicks = " * string(zeropases) * ", makes a new count of " * string(zero_clicks))
end

print(zero_clicks)