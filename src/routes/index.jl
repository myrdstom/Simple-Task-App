module Routes

export setup_routes

using HTTP

# Import necessary modules. Adjust the path based on your project structure.
include("../middleware/cors.jl")
include("../controllers/users/users.jl")
using .CORS  # This now refers to the CORS module you've included.

function setup_routes(router::HTTP.Router)
    wrapped_square = cors_middleware(Users.square)
    HTTP.register!(router, "POST", "/api/square", wrapped_square)
end

end
