module TaskRoutes

using HTTP

include("../../middleware/cors.jl")
include("./tasks_controller.jl")
using .CORS


function get_all_tasks(router::HTTP.Router)
    get_tasks = cors_middleware(Tasks.get_all_tasks)
    HTTP.register!(router, "GET", "/api/tasks", get_tasks)
end

end
