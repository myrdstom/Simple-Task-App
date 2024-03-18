module Routes

export square_route, hello_route

using HTTP

# Import necessary modules. Adjust the path based on your project structure.
include("../../middleware/cors.jl")
include("./user_controller.jl")
using .CORS

function square_route(router::HTTP.Router)
    wrapped_square = cors_middleware(Users.square)
    HTTP.register!(router, "POST", "/api/square", wrapped_square)
end

function hello_route(router::HTTP.Router)
    wrapped_hello = cors_middleware(Users.hello)
    HTTP.register!(router, "GET", "/api/hello", wrapped_hello)
end

end
