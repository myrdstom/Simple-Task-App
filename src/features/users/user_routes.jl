module UserRoutes

using HTTP

# Import necessary modules. Adjust the path based on your project structure.
include("../../middleware/cors.jl")
include("./user_controller.jl")
using .CORS

function get_all_users(router::HTTP.Router)
    get_users = cors_middleware(Users.get_all_users)
    HTTP.register!(router, "GET", "/api/users", get_users)
end


function login(router::HTTP.Router)
    login_user = cors_middleware(Users.login)
    HTTP.register!(router, "POST", "/api/login", login_user)
end

function register_user(router::HTTP.Router)
    register = cors_middleware(Users.register_user)
    HTTP.register!(router, "POST", "/api/register", register)
end


end
