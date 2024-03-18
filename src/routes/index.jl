# File: setup_router.jl

module RouterConfig

using HTTP
include("../features/users/user_route.jl")  # Adjust path as necessary

using .Routes

export setup_router

function setup_router()
    router = HTTP.Router()

    # User routes
    Routes.get_all_users(router)
    Routes.login(router)
    Routes.register_user(router)
    return router
end

end
