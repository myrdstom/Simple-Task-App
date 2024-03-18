using HTTP

include("routes/index.jl")     # Include the Routes module
using .RouterConfig

const ROUTER = setup_router()

# Serve the router on port 8080; the server runs in the background
server = HTTP.serve(ROUTER, 8080; verbose = true, async = true)
