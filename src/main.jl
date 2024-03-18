using HTTP

include("middleware/cors.jl")  # Include the CORS middleware
include("controllers/users/users.jl")      # Include the Users module
include("routes/index.jl")     # Include the Routes module

const ROUTER = HTTP.Router()

# Set up routes using the Routes module
Routes.setup_routes(ROUTER)

# Serve the router on port 8080; the server runs in the background
server = HTTP.serve(ROUTER, 8080; verbose = true, async = true)
