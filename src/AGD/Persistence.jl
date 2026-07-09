module Persistence

using Serialization

export save_state
export load_state
export state_exists

############################################################
# SAVE
############################################################

function save_state(filename::String,obj)

    open(filename,"w") do io
        serialize(io,obj)
    end

    return filename

end

############################################################
# LOAD
############################################################

function load_state(filename::String)

    open(filename,"r") do io
        return deserialize(io)
    end

end

############################################################
# EXISTS
############################################################

function state_exists(filename::String)

    return isfile(filename)

end

end
