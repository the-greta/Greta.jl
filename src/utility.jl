"""
For each element of vector, find the first element which is equal to element of 'index_vector', and get index value.

Parameters
----------
vector : Vector{T} where T<:Integer

index_vector : Vector{T} where T<:Integer

ignore_error : Bool
"""
function get_index_vector(vector::Vector{T}, index_vector::Vector{T}; ignore_error::Bool=false) where T<:Integer
    result = Vector{T}(undef, length(vector))
    
    for (index, value) in enumerate(vector)
        new_value = findfirst(index_vector .== value)
        if isnothing(new_value)
            if ignore_error
                result[index] = 0
            else
                error("Must be choosed within the 'index_vector'. $value is not in $index_vector (Output 0 for this case)")
            end
        else
            result[index] = new_value            
        end
    end
    
    return result
end