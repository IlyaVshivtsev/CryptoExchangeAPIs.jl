# Okx/Utils

function Serde.deser(::Type{<:OkxData}, ::Type{<:Maybe{NanoDate}}, x::String)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.ser_ignore_field(::Type{<:OkxCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:OkxCommonQuery}, ::Val{:timestamp})::Bool
    return true
end

function Serde.SerQuery.ser_name(::Type{<:OkxCommonQuery}, ::Val{:_begin})::String
    return "begin"
end

function Serde.SerQuery.ser_name(::Type{<:OkxCommonQuery}, ::Val{:_end})::String
    return "end"
end

function Serde.SerQuery.ser_type(::Type{<:OkxCommonQuery}, x::DateTime)::Int64
    return round(Int64, 1000 * datetime2unix(x))
end
