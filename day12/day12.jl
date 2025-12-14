function parse_input(infile)
    return split(split(chomp(read(infile, String)), "\n\n")[end], "\n")
end

function task1(file="input.txt")
    lines = parse_input(file)
    ∑ = 0
    for line in lines
        matches = [line[r] for r in findall(r"\d+", line)]
        x = parse(Int, matches[1])
        y = parse(Int, matches[2])
        counts = parse.(Int, matches[3:end])
        if div(x, 3) * div(y, 3) >= sum(counts)
            ∑ += 1
        end
    end
    return ∑
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Merry Xmas!!!")
end