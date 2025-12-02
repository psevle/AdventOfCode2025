using DelimitedFiles

function parse_file(infile)
    IDs = []
    ID_range = readdlm(infile, ',', String)
    for ID in ID_range
        min, max = parse.(Int, split(ID, '-'))
        push!(IDs, min:max)
    end
    return string.(collect(Iterators.flatten(IDs)))
end

function task1(file="input.txt")
    IDs = parse_file(file)
    Σ = 0
    for ID in IDs
        ID_length = length(ID)
        if ID_length % 2 != 0
            continue
        end
        if ID[1:div(ID_length,2)] == ID[div(ID_length,2)+1:end]
            Σ += parse(Int, ID)
        end
    end
    return Σ
end

function task2(file="input.txt")
    IDs = parse_file(file)
    Σ = 0
    for ID in IDs
        repeated = occursin(r"^(.+)\1+$", ID)
        if repeated
            Σ += parse(Int, ID)
        end
    end
    return Σ
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end