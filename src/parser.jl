function parse_vector_int(string::String)
    vector = tryparse.(Int, split(chop(string, head=1, tail=1), ','))
    if vector[1] == nothing
        vector = Int[]
    end
    return vector
end


"""
python dictionary(string)를 julia dictionary로 바꿔주는 함수

Parameters
----------
string : String
    string of python dictionary

Returns
-------
result : Dictionary
"""
function parse_nested_dict(string)
    if string == Dict()
        return(string)
    else
        # external dictionary: get column index
        string = String(collect(string)[2:(length(string)-2)])
        key_value_vector = collect(Iterators.flatten([split(x, "}, ") for x in split(string, ": {")]))
        column_index = key_value_vector[1:2:length(key_value_vector)]
        column_index = [parse(Int64, index) for index in column_index]
    
        # internal dictionary
        internal_dict = []
        nested_dicts = key_value_vector[2:2:length(key_value_vector)]
        for dict in nested_dicts
            dict = split(dict, ": ")
            key_value_vector1 = collect(Iterators.flatten([rsplit(x, ", ", limit = 2) for x in dict[1:length(dict)-1]]))
            key_value_vector2 = [dict[length(dict)]]
            nested_key_value_vector = [key_value_vector1; key_value_vector2]
        
            nested_keys = [recover_type(k) for k in nested_key_value_vector[1:2:length(nested_key_value_vector)]]
            nested_values = nested_key_value_vector[2:2:length(nested_key_value_vector)]
            nested_values = [
                value[1] == '[' ? [recover_type(v) for v in split(String(collect(value)[2:(length(value)-1)]), ", ")] :
                [recover_type(value)] for value in nested_values
            ]
            push!(internal_dict, Dict(zip(nested_keys, nested_values)))
        end
        return(Dict(zip(column_index, internal_dict)))
    end
end


"""
python string을 julia에서 원래 type으로 바꿔주는 함수

Parameters
----------
string : String

Returns
-------
result : Float64 or Int64 or string
"""
function recover_type(string::SubString)
    if (occursin(".", string)) & (tryparse(Float64, string) !== nothing)
        orig_type = parse(Float64, string)
    elseif tryparse(Int64, string) !== nothing
        orig_type = parse(Int64, string)
    else
        orig_type = replace(string, "'" => "" )
    end
end
