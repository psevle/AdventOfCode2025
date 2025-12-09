using Memoize

function parse_file(infile)
    points = [Tuple(parse.(Int, split(line, ','))) for line in readlines(infile)]
    return points
end

function task1(file="input.txt")
    points = parse_file(file)
    largest = 0
    for (idx, (x1, y1)) in enumerate(points)
        for (jdx, (x2, y2)) in enumerate(points)
            if idx < jdx
                area = (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
                largest = max(largest, area)
            end
        end
    end
    return largest
end

function task2(file="input.txt")
    points = parse_file(file)
    @memoize function point_in_poly(x, y)
        inside = false
        for ((x1, y1), (x2, y2)) in zip(points, circshift(points, -1))
            if (x == x1 == x2 && min(y1, y2) <= y <= max(y1, y2)) || 
                (y == y1 == y2) && min(x1, x2) <= x <= max(x1, x2)
                return true
            end
            if ((y1 > y) != (y2 > y)) && (x < (x2 - x1) * (y - y1) / (y2 - y1) + x1)
                inside = !inside
            end
        end
        return inside
    end
    function edge_intersects_rect(x1, y1, x2, y2, rx1, ry1, rx2, ry2)
        if y1 == y2
            if ry1 < y1 < ry2
                if max(x1, x2) >= rx1 && min(x1, x2) <= rx2
                    return true
                end
            end
        else
            if rx1 < x1 < rx2
                if max(y1, y2) > ry1 && min(y1, y2) < ry2
                    return true
                end
            end
        end
        return false
    end
    function square_valid(x1, y1, x2, y2)
        x1, x2 = sort([x1, x2])
        y1, y2 = sort([y1, y2])
        for (x, y) in [(x1, y1), (x1, y2), (x2, y1), (x2, y2)]
            if !point_in_poly(x, y)
                return false
            end
        end
        for ((ex1, ey1), (ex2, ey2)) in zip(points, circshift(points, -1))
            if edge_intersects_rect(ex1, ey1, ex2, ey2, x1, y1, x2, y2)
                return false
            end
        end
        return true
    end
    largest = 0
    for (idx, (x1, y1)) in enumerate(points)
        for (jdx, (x2, y2)) in enumerate(points)
            if idx < jdx
                area = (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
                if area > largest && square_valid(x1, y1, x2, y2)
                    largest = area
                end
            end
        end
    end
    return largest
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end