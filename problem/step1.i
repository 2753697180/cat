[Mesh]
  [gmg]
    type = GeneratedMeshGenerator # Can generate simple lines, rectangles and rectangular prisms
    dim = 3                       # Dimension of the mesh
    nx = 4                    # Number of elements in the x direction
    ny = 4
    nz = 4                 # Number of elements in the y direction
    xmax = 0.2                 # Length of test chamber
    ymax = 0.2
    zmax = 0.2              # Test chamber radius
  []
                 # Axisymmetric RZ
                 # Which axis the symmetry is around
[]

[Variables]
  [pressure]
    # Adds a Linear Lagrange variable by default
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [diffusion]
    type = ADDiffusion  # Laplacian operator using automatic differentiation
    variable = pressure # Operate on the "pressure" variable from above
  []
[]

[BCs]
  [inlet]
     # Simple u=value BC
# Variable to be set
    # Name of a sideset in the mesh
         # (Pa) From Figure 2 from paper.  First data point for 1mm spheres.
  type =NeumannBC
  boundary = left
  variable = pressure
  value = 0
  []
  [outlet]
    type = NeumannBC
    variable = pressure
    boundary = right
    value = 0           # (Pa) Gives the correct pressure drop from Figure 2 for 1mm spheres
  []
[]

[Problem]
  type = FEProblem  # This is the "normal" type of Finite Element Problem in MOOSE
[]

[Executioner]
  type = Steady       # Steady state problem
  solve_type = NEWTON # Perform a Newton solve, uses AD to compute Jacobian terms
  petsc_options_iname = '-pc_type -pc_hypre_type' # PETSc option pairs with values below
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true # Output Exodus format
  [csv]
    type = CSV
    append_date = true
  []
[]
[VectorPostprocessors]
  [point]
   type = SideValueSampler
   boundary = left
   sort_by = Y
   variable =pressure 
  []
[]
