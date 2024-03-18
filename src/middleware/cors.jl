module CORS

export cors_middleware

using HTTP

function cors_middleware(handler)
    function (req::HTTP.Request)
        # Define CORS headers
        headers = [
            "Access-Control-Allow-Origin" => "*",
            "Access-Control-Allow-Methods" => "GET, POST, OPTIONS",
            "Access-Control-Allow-Headers" => "Accept, Content-Type",
            "Content-Type" => "application/json"  # This line is typically not necessary here.
        ]

        # Handle OPTIONS preflight request
        if HTTP.method(req) == "OPTIONS"
            return HTTP.Response(200, "application/json", headers)
        end

        # For non-OPTIONS requests, call the original handler and add CORS headers to the response
        response = handler(req)
        for (header, value) in headers
            push!(response.headers, header => value)
        end
        return response
    end
end

end