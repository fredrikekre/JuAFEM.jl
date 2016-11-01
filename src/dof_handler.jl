# DoFHandler
export DoFHandler#, isopen

# Utility
export add_field!, finalize!

immutable Field{FECV <: FECellValues}
    name::Symbol
    fecv::FECV
end

type DoFHandler{dim, FECV <: FECellValues}
    grid::Grid{dim}
    fields::Dict{Symbol, FECV}
    edof::Vector{Vector{Int}}
    open::Ref{Bool}
end

DoFHandler(grid::Grid) = DoFHandler(grid, Field[], Vector{Int}[], Ref(true))

Base.isopen(df::DoFHandler) = df.open[]

function getndofspercell{dim}(df::DoFHandler{dim})
    isopen(df) && throw(ArgumentError("the DoFHandler is open"))
    ndofs = 0
    for field in df.fields
        isa(field.fecv, FECellScalarValues) ?
            ndofs +=     getnbasefunctions(field.fecv.function_space) :
            ndofs += dim*getnbasefunctions(field.fecv.function_space)
    end
    return ndofs
end

function getndofspercell{dim}(df::DoFHandler{dim}, field::Int)
    isopen(df) && throw(ArgumentError("the DoFHandler is open"))

    isa(df.fields[field].fecv, FECellScalarValues) ?
        return     getnbasefunctions(field.fecv.function_space) :
        return dim*getnbasefunctions(field.fecv.function_space)
end



function add_field!(df::DoFHandler, field::Field)
    iscompatible(typeof(field.fecv.function_space), getcelltype(df.grid)) || throw(ArgumentError("field is not compatible with the grid"))
    push!(df.fields,field)
    nothing
end

"""
Finalizes the `DoFHandler` and enumerate all the dofs for the grid.
"""
function finalize!(df::DoFHandler)
    # Close it
    df.closed[] = true

    # Loop over all cells and distribute dofs
    next_dof = 1
    for cell in getcells(df.grid)
        cell_dofs = Int[]
        for field in fields(df)

            push!(cell_dofs, next_dof)
        end
        push!(df.edof, cell_dofs)
    end
end
