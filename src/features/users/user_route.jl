module Routes

export square_route, hello_route

using HTTP

# Import necessary modules. Adjust the path based on your project structure.
include("../../middleware/cors.jl")
include("./user_controller.jl")
using .CORS

function get_all_users(router::HTTP.Router)
    wrapped_hello = cors_middleware(Users.get_all_users)
    HTTP.register!(router, "GET", "/api/users", wrapped_hello)
end


function login(router::HTTP.Router)
    wrapped_square = cors_middleware(Users.login)
    HTTP.register!(router, "POST", "/api/login", wrapped_square)
end

function register_user(router::HTTP.Router)
    wrapped_square = cors_middleware(Users.register_user)
    HTTP.register!(router, "POST", "/api/register", wrapped_square)
end


end
