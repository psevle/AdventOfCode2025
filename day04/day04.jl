function parse_file(infile)
    lines = readlines(infile)
    nrow = length(lines)
    ncol = length(lines[1])
    m = Matrix{Int}(undef, nrow, ncol)
    for (idx, line) in enumerate(lines)
        m[idx, :] = [c == '@' ? 1 : 0 for c in line]
    end
    return m
end

function neighbor_count(m, i, j)
    nrow, ncol = size(m)
    count = 0
    for di in -1:1, dj in -1:1
        if di == 0 && dj == 0
            continue
        end
        ni, nj = i + di, j + dj
        if 1 ≤ ni ≤ nrow && 1 ≤ nj ≤ ncol
            count += (m[ni, nj] == 1)
        end
    end
    return count
end

function task1(file="input.txt")
    m = parse_file(file)
    nrow, ncol = size(m)
    result = 0

    for i in 1:nrow, j in 1:ncol
        if m[i, j] == 1
            nc = neighbor_count(m, i, j)
            if nc < 4
                result += 1
            end
        end
    end
    return result
end

function task2(file="input.txt")
    m = parse_file(file)
    nrow, ncol = size(m)
    total_flipped = 0
    changed = true

    while changed
        changed = false
        to_flip = falses(nrow, ncol)
        for i in 1:nrow, j in 1:ncol
            if m[i,j] == 1
                nc = neighbor_count(m, i, j)
                if nc < 4
                    to_flip[i,j] = true
                end
            end
        end
        flipped_this_round = count(to_flip)
        if flipped_this_round > 0
            total_flipped += flipped_this_round
            m[to_flip] .= 0
            changed = true
        end
    end
    return total_flipped
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end