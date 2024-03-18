using HTTP

function hello_world_handler(req)
    return HTTP.Response(200, "Hello, world!")
end

# Define a route table as an array of tuples. Each tuple represents a route with a method, path, and handler.
routes = [
    HTTP.request("GET", "/", hello_world_handler)
]

# Start the server on localhost at port 8000
function start_server()
    HTTP.serve(routes; host="localhost", port=8000, verbose=true)
    println("Server is running at http://localhost:8000")
end

start_server()
