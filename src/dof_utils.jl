# internal helper functions for dof handler
iscompatible{FS <: FunctionSpace, C <: Cell, }(fs::Type{FS}, cell::Type{C}) = false
iscompatible{order}(::Type{Lagrange{1, RefCube, order}}, ::AllLines) = true
iscompatible{order}(::Type{Lagrange{2, RefTetrahedron, order}}, ::AllTriangles) = true
iscompatible{order}(::Type{Lagrange{2, RefCube, order}}, ::AllQuadrilaterals) = true
iscompatible{order}(::Type{Lagrange{3, RefTetrahedron, order}}, ::AllTetrahedrons) = true
iscompatible{order}(::Type{Lagrange{3, RefCube, order}}, ::AllHexahedrons) = true

apply_info(::Type{Lagrange{1, RefCube, 1}}, ::Line) = (0, 0, 0, 1)
apply_info(::Type{Lagrange{1, RefCube, 2}}, ::Line) = (0, 0, 1, 1)
apply_info(::Type{Lagrange{1, RefCube, 1}}, ::QuadraticLine) = (0, 0, 0, 1)



apply_info{order}(::Type{Lagrange{2, RefTetrahedron, order}}, ::AllTriangles) = true
apply_info{order}(::Type{Lagrange{2, RefCube, order}}, ::AllQuadrilaterals) = true
apply_info{order}(::Type{Lagrange{3, RefTetrahedron, order}}, ::AllTetrahedrons) = true
apply_info{order}(::Type{Lagrange{3, RefCube, order}}, ::AllHexahedrons) = true
