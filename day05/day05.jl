function parse_file(infile)
    ranges = UnitRange{Int}[]
    available = Int[]
    space = false

    for l in eachline(infile)
        s = strip(l)
        if isempty(s)
            space = true
            continue
        end
        if !space
            a, b = parse.(Int, split(s, '-'))
            push!(ranges, a:b)
        else
            push!(available, parse(Int, s))
        end
    end

    return ranges, available
end

@inline function in_ranges(x, ranges::Vector{UnitRange{Int}})
    for r in ranges
        if first(r) <= x <= last(r)
            return true
        end
    end
    return false
end

function merge_ranges(ranges::Vector{UnitRange{Int}})
    isempty(ranges) && return UnitRange{Int}[]
    sorted = sort(ranges, by = first)
    merged = UnitRange{Int}[]
    current = sorted[1]
    for r in Iterators.rest(sorted)
        if first(r) <= last(current) + 1
            current = first(current) : max(last(current), last(r))
        else
            push!(merged, current)
            current = r
        end
    end
    push!(merged, current)
    return merged
end


function task1(file="input.txt")
    ranges, avail = parse_file(file)
    count(ing -> in_ranges(ing, ranges), avail)
end

function task2(file="input.txt")
    ranges, _ = parse_file(file)
    merged = merge_ranges(ranges)
    sum(length, merged)
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end