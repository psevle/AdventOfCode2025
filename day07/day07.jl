using Memoize

function parse_file(infile)
    grid = [collect(strip(line)) for line in eachline(infile)]
    return grid
end

function task1(file="input.txt")
    grid = parse_file(file)
    S = [(r, c) for (r, row) in enumerate(grid) for (c, char) in enumerate(row) if char == 'S'][1]
    beams = [S]
    seen = Set([S])

    function add(r, c)
        (r, c) in seen && return
        push!(seen, (r, c))
        push!(beams, (r, c))
    end

    ∑ = 0
    while length(beams) > 0
        (r, c) = popfirst!(beams)
        if grid[r][c] == '.' || grid[r][c] == 'S'
            r == length(grid) - 1 && continue
            add(r + 1, c)
        elseif grid[r][c] == '^'
            ∑ += 1
            add(r, c-1)
            add(r, c+1)
        end
    end
    return ∑
end

function task2(file="input.txt")
    grid = parse_file(file)
    S = [(r, c) for (r, row) in enumerate(grid) for (c, char) in enumerate(row) if char == 'S'][1]
    @memoize function solve(r, c)
        r >= length(grid) && return 1

        if grid[r][c] == '.' || grid[r][c] == 'S'
            return solve(r + 1, c)
        elseif grid[r][c] == '^'
            return solve(r, c - 1) + solve(r, c + 1)
        end
    end
    return solve(S...)
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end