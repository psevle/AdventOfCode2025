function parse_file(infile)
    lines = readlines(infile)
    nrow = length(lines)
    ncol = length(lines[1])
    m = Matrix{Int8}(undef, nrow, ncol)
    for (idx, line) in enumerate(lines)
        m[idx, :] = Int8.(collect(line) .- '0')
    end
    return m
end

function max_digits(row)
    idxs = eachindex(row)
    max_val = 0
    max_first = row[first(idxs)]
    for i in Iterators.drop(idxs, 1)
        max_val = max(max_val, 10*max_first + row[i])
        max_first = max(max_first, row[i])
    end
    return max_val
end

function max_digits(row, k::Int)
    n = length(row)
    stack = Int[]
    for (i, digit) in enumerate(row)
        while !isempty(stack) && digit > stack[end] && length(stack) - 1 + (n-i+1) >= k
            pop!(stack)
        end
        if length(stack) < k
            push!(stack, digit)
        end
    end
    return stack
end

function task1(file="input.txt")
    m = parse_file(file)
    Σ = 0
    for row in eachrow(m)
        jolts = max_digits(row)
        Σ += jolts
    end
    return Σ
end

function task2(file="input.txt", k::Int=12)
    m = parse_file(file)
    Σ = 0
    for row in eachrow(m)
        digits = max_digits(row, k)
        jolts = parse.(Int, join(string.(digits)))
        Σ += jolts
    end
    return Σ
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end