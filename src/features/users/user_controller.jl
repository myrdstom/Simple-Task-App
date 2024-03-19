# users/users.jl
module Users

export square, hello

using HTTP, JSON3, UUIDs, JSONWebTokens

include("../../db/db.jl")
using .InMemoryDB


function generate_jwt(claims::Dict)
    encoding = JSONWebTokens.HS256("secretkey")
    token = JSONWebTokens.encode(encoding, claims)
    return token
end


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
        current_user = nothing
        user_found = false
        password_match = false
        for user in users
            if user["username"] == username
                user_found = true
                # Check if the passwords match
                if user["password"] == password
                    password_match = true
                    current_user = user
                end
                break
            end
        end

        println(current_user)

        if !user_found
            return HTTP.Response(404, JSON3.write("message" => "User not found"))
        elseif !password_match
            return HTTP.Response(401, JSON3.write("message" => "Invalid password"))
        else
            logged_in_user = Dict(
                "username" => current_user["username"],
                "email" => current_user["email"],
                "firstname" => current_user["firstname"],
                "lastname" => current_user["lastname"],
                "exp" => time() + 86400,
            )

            token = generate_jwt(logged_in_user)
            response_body =
                JSON3.write(Dict("token" => token, "message" => "Login successful"))
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

        if length(password) < 8
            return HTTP.Response(
                400,
                JSON3.write("error" => "Password must be atleast 8 characters long"),
            )
        end

        email_regex = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"

        if match(email_regex, email) === nothing
            return HTTP.Response(
                400,
                JSON3.write("error" => "Email is not well structured"),
            )
        end


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


            InMemoryDB.add_user(new_user)

            token = generate_jwt(new_user)

            response_body = JSON3.write(
                Dict(
                    "user" => new_user,
                    "token" => token,
                    "message" => "User successfully created",
                ),
            )

            return HTTP.Response(201, response_body)
        end


    catch ex
        println("Error processing request: $ex")
        return HTTP.Response(500, "Internal Server Error")
    end
end



end  # module Users
