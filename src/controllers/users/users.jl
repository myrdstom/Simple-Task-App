# users/users.jl
module Users

export square

# Import the HTTP module
using HTTP

function square(req::HTTP.Request)
    body = parse(Float64, String(req.body))
    square = body^2
    return HTTP.Response(200, string(square))
end

end  # module Users
