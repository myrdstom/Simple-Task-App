# users/users.jl
module Users

export square, hello

using HTTP, JSON3, UUIDs

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

        users = InMemoryDB.get_users()

        json_body = JSON3.read(req.body)


        # Validate and extract the number
        # Destructure and validate the JSON body for required fields: email and password
        if !haskey(json_body, "username") || !haskey(json_body, "password")
            return HTTP.Response(
                400,
                JSON3.write("error" => "Username or password not provided check values"),
            )
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


        users = InMemoryDB.get_users()
        json_body = JSON3.read(req.body)

        if !haskey(json_body, "username") ||
           !haskey(json_body, "password") ||
           !haskey(json_body, "email") ||
           !haskey(json_body, "firstname")
            !haskey(json_body, "lastname")
            return HTTP.Response(
                400,
                JSON3.write("error" => "Required values are missing, check your inputs"),
            )
        end

        user_id = uuid4()
        username = json_body["username"]
        password = json_body["password"]
        email = json_body["email"]
        firstname = json_body["firstname"]
        lastname = json_body["lastname"]

        user_found = false
        email_found = false
        for user in users
            if user["username"] == username
                user_found = true
                if user["email"] === email
                    email_found == true
                end
                break
            end
        end

        if user_found
            return HTTP.Response(
                400,
                JSON3.write(
                    "error" => "A user with this username has already been registered",
                ),
            )
        elseif email_found
            return HTTP.Response(
                400,
                JSON3.write(
                    "error" => "A user with this email has already been registered",
                ),
            )
        else
            new_user = Dict(
                "user_id" => string(user_id),
                "username" => username,
                "email" => email,
                "firstname" => firstname,
                "lastname" => lastname,
                "message" => "User Registered",
            )

            response_body = JSON3.write(new_user)

            InMemoryDB.add_user(new_user)

            return HTTP.Response(201, response_body)
        end


    catch ex
        println("Error processing request: $ex")
        return HTTP.Response(500, "Internal Server Error")
    end
end



end  # module Users
