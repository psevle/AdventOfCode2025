using Combinatorics
using JuMP, HiGHS

function task1(file="input.txt")
    ∑ = 0
    for line in eachline(file)
        m = match(r"^\[([.#]+)\] ([()\d, ]+) \{([\d,]+)\}$", strip(line))
        m === nothing && continue
        target, buttons, _ = m.captures
        target = Set(idx - 1 for (idx, l) in enumerate(target) if l == '#')
        buttons = [Set(parse.(Int, split(b[2:end-1], ','))) for b in split(buttons)]
        found = false
        for count in 1:length(buttons)
            for attempt in combinations(buttons, count)
                lights = Set{Int}()
                for button in attempt
                    for x in button
                        x in lights ? delete!(lights, x) : push!(lights, x)
                    end
                end
                if lights == target
                    ∑ += count
                    found = true
                    break
                end
            end
            found && break
        end
    end
    return ∑
end

function task2(file="input.txt")
    ∑ = 0
    for line in eachline(file)
        m = match(r"^\[([.#]+)\] ([()\d, ]+) \{([\d,]+)\}$", strip(line))
        m === nothing && continue
        _, buttons, jolts = m.captures
        buttons = [Set(parse.(Int, split(b[2:end-1], ','))) for b in split(buttons)]
        jolts = parse.(Int, split(jolts, ','))

        num_buttons = length(buttons)

        model = Model(HiGHS.Optimizer)
        @variable(model, n[1:num_buttons] >= 0, Int)

        for (i, jolt) in enumerate(jolts)
            idx = i - 1
            covering_buttons = [b for (b, button) in enumerate(buttons) if idx in button]
            @constraint(model, sum(n[b] for b in covering_buttons) == jolt)
        end
        
        @objective(model, Min, sum(n))
        optimize!(model)

        if termination_status(model) == MOI.OPTIMAL
            ∑ += Int(sum(value.(n)))
        else
            error("No solution found for line: $line")
        end
    end
    return ∑
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end