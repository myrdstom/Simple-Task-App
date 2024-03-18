module CORS

export cors_middleware

using HTTP

function cors_middleware(handler)
    function (req::HTTP.Request)
        # Define CORS headers
        headers = [
            "Access-Control-Allow-Origin" => "*",
            "Access-Control-Allow-Methods" => "POST, OPTIONS",
            "Access-Control-Allow-Headers" => "Content-Type"
        ]

        # Handle OPTIONS preflight request
        if HTTP.method(req) == "OPTIONS"
            return HTTP.Response(200, headers)
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
