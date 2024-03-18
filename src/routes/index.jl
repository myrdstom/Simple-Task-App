# File: setup_router.jl

module RouterConfig

using HTTP
include("../features/users/user_route.jl")  # Adjust path as necessary

using .Routes

export setup_router

function setup_router()
    router = HTTP.Router()

    # User routes
    Routes.square_route(router)
    Routes.hello_route(router)
    return router
end

end
