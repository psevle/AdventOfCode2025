using Distances
using DataStructures

function parse_file(infile)
    rows = [permutedims(parse.(Int, split(line, ","))) for line in readlines(infile)]
    return vcat(rows...)   # rows are 1×3 matrices → stacked into 20×3
end

function task1(file="input.txt")
    m = parse_file(file)
    D = []
    for (i, rowi) in enumerate(eachrow(m))
        for (j, rowj) in enumerate(eachrow(m))
            dist = euclidean(rowi, rowj)
            if i > j
                push!(D, (dist, i, j))
            end
        end
    end
    UF = Dict(i => i for i in 1:length(m[:,1]))
    function find(x)
        if x == UF[x]
            return x
        end
        UF[x] = find(UF[x])
        return UF[x]
    end
    function mix(x, y)
        UF[find(x)] = find(y)
    end
    sort!(D)
    for (_d, i, j) in D[1:1000]
        mix(i,j)
    end
    SZ = DefaultDict{Int, Int}(0)
    for x in 1:length(m[:, 1])
        SZ[find(x)] += 1
    end
    S = sort(collect(values(SZ)))
    return S[end]*S[end-1]*S[end-2]
end

function task2(file="input.txt")
    m = parse_file(file)
    D = []
    for (i, rowi) in enumerate(eachrow(m))
        for (j, rowj) in enumerate(eachrow(m))
            dist = euclidean(rowi, rowj)
            if i > j
                push!(D, (dist, i, j))
            end
        end
    end
    UF = Dict(i => i for i in 1:length(m[:,1]))
    function find(x)
        if x == UF[x]
            return x
        end
        UF[x] = find(UF[x])
        return UF[x]
    end
    function mix(x, y)
        UF[find(x)] = find(y)
    end
    sort!(D)
    connections = 0
    sort(D)
    for (_d, i, j) in D[1:end]
        if find(i) != find(j)
            connections += 1
            if connections == length(m[:,1])-1
                return (m[i, 1] * m[j, 1])
            end
            mix(i,j)
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end