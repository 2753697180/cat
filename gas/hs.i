[Mesh]
  file = gas.e
[]
[Variables]
  [T]
    family = LAGRANGE
    order = FIRST
    initial_condition = '300' # Start at room temperature
  []
[]
[AuxVariables]
  [T_fluid]
    family = LAGRANGE
    order = FIRST
    initial_condition = '300'
  []
  [htcp]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [heat_conduction]
    type = ADHeatConduction
    variable = T
  []
  [heat_source]
    type = HeatSource
    variable = T
    value = 3e6
    block = '1'
  []
  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = T
  []
[]
[BCs]
  [heat_q]
    type = NeumannBC
    variable = T
    boundary = '13'
    value = 0 # (q)
  []
  [uo]
    type = CoupledConvectiveHeatFluxBC
    boundary = '1 2 3 4 5 6 7 8 9 10 11 12'
    variable = T
    htc = 0
    T_infinity = 'T_fluid'
    alpha = '1.0'
    scale_factor = '1.0'
  []
[]
[UserObjects]
  [T_wall1]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '1'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall2]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '2'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall3]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '3'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall4]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '4'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall5]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '5'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall6]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '6'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall7]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '7'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall8]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '8'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall9]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '9'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall10]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '10'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_wall11]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '11'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []  
  [T_wall12]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '12'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_fluid_uo]
    type = LayeredSideAverage
    num_layers = 15
    boundary = '2'
    variable = 'T_fluid'
    direction = z
    execute_on = 'timestep_end'
  []
[]
[Materials]
  [fuel_material]
    type = fuel
    block = '1'                  # 应用于块 ID 为 1 的区域，即燃料区域
  []
  [shimo_material]
    type = shimo
    block = '2'                  # 应用于块 ID 为 2 的区域，即石墨基体区域
  []
[]
[Executioner]
  #fixed_point_max_its = 10
  type = Transient
  solve_type = PJFNK
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 50
  dt = 2
  dtmin = 1e-4
  start_time = 0
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]
[Outputs]
  exodus = true
[]
[VectorPostprocessors]
  [T_fluid_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = T_fluid_uo
  []
  [T_wall_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = T_wall1
  []
[]
