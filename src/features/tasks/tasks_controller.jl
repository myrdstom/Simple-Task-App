module Tasks

using HTTP, JSON3


include("../../db/db.jl")
using .InMemoryDB

function get_all_tasks(req::HTTP.Request)
    try
        tasks = InMemoryDB.get_tasks()
        response_body = JSON3.write(tasks)

        return HTTP.Response(200, response_body)
    catch ex
        println("Error processing request $ex")
        return HTTP.Response(500, "Internal Server Error")
    end
end


end
