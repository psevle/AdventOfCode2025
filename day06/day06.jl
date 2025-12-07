function parse_file(infile)
    lines = readlines(infile)
    m = [split(l) for l in lines]
    ops = pop!(m)
    m = reduce(vcat, [reshape(parse.(Int, r), 1, :) for r in m])
    return m, ops
end

function task1(file="input.txt")
    cols, operations = parse_file(file)
    Σ = 0
    for (idx, op) in enumerate(operations)
        if op == "*"
            Σ += prod(cols[:, idx])
        elseif op == "+"
            Σ += sum(cols[:, idx])
        else
            println("Unknown operator: $(op)")
        end
    end
    return Σ
end

""" Whitespace hell!!!"""
function task2(file="input.txt")
    grid = [line[1:end] for line in readlines(file)]
    maxlen = maximum(length.(grid))
    grid_padded = [rpad(line, maxlen, ' ') for line in grid]

    cols = [collect(grid_padded[j][i] for j in 1:length(grid_padded)) for i in 1:maxlen]
    groups = Vector{Vector{Vector{Char}}}()
    group = Vector{Vector{Char}}()
    cols
    for col in cols
        col_vec = collect(col)
        if Set(col_vec) == Set(' ')
            if !isempty(group)
                push!(groups, group)
            end
            group = Vector{Vector{Char}}()
        else
            push!(group, col_vec)
        end
    end
    if !isempty(group)
        push!(groups, group)
    end

    group

    ∑ = 0
    for group in groups
        expr_str = join([join(line[1:end-1]) for line in group[1:end]], group[1][end])
        ∑ += eval(Meta.parse(expr_str))
    end
    return ∑
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end