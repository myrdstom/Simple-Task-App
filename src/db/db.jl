# File: db/in_memory_db.jl

module InMemoryDB

export add_user, get_users, add_task, get_tasks, clear_data

# Initialize the in-memory storage
const DB = Dict(
    :users => [
        Dict(
            "username" => "myrdstom",
            "firstname" => "Paul",
            "lastname" => "Nsereko",
            "email" => "nserekopaul@gmail.com",
            "password" => "password",
        ),
    ],
    :tasks => [],
)

"""
    add_user(user::Dict)

Add a new user to the in-memory storage.
"""
function add_user(user::Dict)
    push!(DB[:users], user)
end

"""
    get_users() -> Array

Retrieve all users from the in-memory storage.
"""
function get_users()
    return DB[:users]
end

"""
    add_task(task::Dict)

Add a new task to the in-memory storage.
"""
function add_task(task::Dict)
    push!(DB[:tasks], task)
end

"""
    get_tasks() -> Array

Retrieve all tasks from the in-memory storage.
"""
function get_tasks()
    return DB[:tasks]
end

"""
    clear_data()

Clear all data from the in-memory storage.
"""
function clear_data()
    DB[:users] = []
    DB[:tasks] = []
end

end
