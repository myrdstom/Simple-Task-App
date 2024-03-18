# users/users.jl
module Users

export square, hello

using HTTP, JSON3

include("../../db/db.jl")
using .InMemoryDB


function get_all_users(req::HTTP.Request)
    try
        # Create JSON response
        users = InMemoryDB.get_users()
        response_body = JSON3.write(users)

        return HTTP.Response(200, response_body)
    catch ex
        println("Error processing request: $ex")
        return HTTP.Response(500, "Internal Server Error")
    end
end

function login(req::HTTP.Request)
    try
        # Ensure the content type is JSON
        content_type = HTTP.header(req, "Content-Type")
        if content_type != "application/json"
            return HTTP.Response(400, "Content-Type must be application/json")
        end



        users = InMemoryDB.get_users()

        # Parse the JSON body
        body = String(req.body)

        json_body = JSON3.read(body)


        # Validate and extract the number
        # Destructure and validate the JSON body for required fields: email and password
        if !haskey(json_body, "username") || !haskey(json_body, "password")
            return HTTP.Response(400, JSON3.write("error" => "Username or password not provided check values"))
        end



        username = json_body["username"]
        password = json_body["password"]



        # Find user by username
        user_found = false
        password_match = false
        for user in users
            if user["username"] == username
                user_found = true
                # Check if the passwords match
                if user["password"] == password
                    password_match = true
                end
                break
            end
        end

        if !user_found
            return HTTP.Response(404, JSON3.write("message" => "User not found"))
        elseif !password_match
            return HTTP.Response(401, JSON3.write("message" => "Invalid password"))
        else
            response_body = JSON3.write("message" => "Login successful")
            return HTTP.Response(200, response_body)
        end

    catch ex
        println("Error processing request: $ex")
        return HTTP.Response(500, "Internal Server Error")
    end
end


function register_user(req::HTTP.Request)
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
