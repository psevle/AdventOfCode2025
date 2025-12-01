function parse_file(infile)
    rotations = Int[]
    open(infile) do file
        for row in eachline(file)
            dir = row[1] == 'L' ? -1 : 1
            rotation = parse(Int, row[2:end])
            push!(rotations, dir * rotation)
        end
    end
    return rotations
end

function task1(file="input.txt")
    rots = parse_file(file)
    pos = 50
    count = 0
    for rot in rots
        d = sign(rot)
        amt = abs(rot)
        if d == -1
            pos = (pos-amt+100)%100
        else
            pos = (pos+amt)%100
        end
        if pos == 0
            count += 1
        end
    end
    return count
end

function task2(file="input.txt")
    rots = parse_file(file)
    pos = 50
    count = 0
    for rot in rots
        d = sign(rot)
        amt = abs(rot)
        for _ in 1:amt
            if d == -1
                pos = (pos-1+100)%100
            else
                pos = (pos+1)%100
            end
            if pos == 0
                count += 1
            end
        end
    end
    return count
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end