using Memoize

function  parse_input(infile)
    graph = Dict{String, Vector{String}}()
    for line in eachline(infile)
        src, dsts = split(line, ':')
        graph[src] = split(dsts)
    end
    return graph
end

@memoize count(graph, src, dst) = 
    src == dst ? 1 : 
    sum(count(graph, x, dst) for x in get(graph, src, []); init=0)

function task1(file="input.txt")
    graph = parse_input(file)
    return count(graph, "you", "out")
end

function task2(file="input.txt")
    graph = parse_input(file)
    dac_first = count(graph, "svr", "dac") * count(graph, "dac", "fft") * count(graph, "fft", "out")
    fft_first = count(graph, "svr", "fft") * count(graph, "fft", "dac") * count(graph, "dac", "out")
    return dac_first + fft_first
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end