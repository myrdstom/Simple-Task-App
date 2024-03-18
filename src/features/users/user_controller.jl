# users/users.jl
module Users

export square, hello

using HTTP, JSON3

function square(req::HTTP.Request)
    try
        # Ensure the content type is JSON
        content_type = HTTP.header(req, "Content-Type")
        if content_type != "application/json"
            return HTTP.Response(400, "Content-Type must be application/json")
        end

        # Parse the JSON body
        body = String(req.body)

        json_body = JSON3.read(body)

        # Validate and extract the number
        if !haskey(json_body, "squared_number")
            return HTTP.Response(400, "Missing 'squared_number' in JSON payload")
        end

        num = json_body.squared_number
        # println("The value of num $num")

        # Calculate the square
        square_result = num^2

        # Create JSON response
        response_body = JSON3.write(Dict("squared_result" => square_result))

        return HTTP.Response(201, response_body)
    catch ex
        println("Error processing request: $ex")
        return HTTP.Response(500, "Internal Server Error")
    end
end

function hello(req::HTTP.Request)
    try
        # Create JSON response
        response_body = JSON3.write(Dict("data" => "hello world again"))

        return HTTP.Response(200, response_body)
    catch ex
        println("Error processing request: $ex")
        return HTTP.Response(500, "Internal Server Error")
    end
end

end  # module Users
