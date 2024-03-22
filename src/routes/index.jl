# File: setup_router.jl

module RouterConfig

using HTTP
include("../features/users/user_routes.jl")
include("../features/tasks/task_routes.jl")

using .UserRoutes
using .TaskRoutes

export setup_router

function setup_router()
    router = HTTP.Router()

    # User routes
    UserRoutes.get_all_users(router)
    UserRoutes.login(router)
    UserRoutes.register_user(router)

    #Task routes
    TaskRoutes.get_all_tasks(router)

    return router
end

end
