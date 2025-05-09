[Mesh]
  file = gas2.e
[]
#!include z_dev.i
[Variables]
  [T]
    family = LAGRANGE
    order  = FIRST
    initial_condition = '400' 
  []
[]
[MeshDivisions]
  [z_dev]
    type = CartesianGridDivision
    nx =1 
    ny = 1
    nz = 11
    widths = '0 0 0.05'
  []
[]
[AuxVariables]
  [T_fluid_3]
    family = LAGRANGE
    order  = FIRST
    initial_condition = '300'
  []
  [htcp]
    family = MONOMIAL
    order  = CONSTANT
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
    value = 3e7
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
    htc = htcp
    T_infinity = 'T_fluid_3'
    alpha = '1.0'
    scale_factor = '1.0'
  []
[]
[UserObjects]
  [T_wall1]
    type = LayeredSideAverage
    num_layers = 11
    boundary = '1'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_fluid_uo]
    type = LayeredSideAverage
    num_layers = 11
    boundary = '1'
    variable = 'T_fluid_3'
    direction = z
    execute_on = 'timestep_end'
  []
[]
[Materials]
  [fuel_material]
    type = fuel
    block = '1'  # 应用于块 ID 为 1 的区域，即燃料区域
  []
  [shimo_material]
    type = shimo
    block = '2'  # 应用于块 ID 为 2 的区域，即石墨基体区域
  []
[]
[MultiApps]
  [sub_app]
    # poistion='0,0,1'
    type = TransientMultiApp
    input_files = 'f.i'
    execute_on = 'TIMESTEP_BEGIN'
    sub_cycling = true
  []
[]
[Executioner]
  #fixed_point_max_its = 10
  type = Transient
  solve_type = PJFNK
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 20
  dt = 0.1
  dtmin = 1e-4
  start_time = -0.1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]
[Postprocessors]
  [T_f]
    type = SideAverageValue
    boundary = '1'
    variable = T_fluid_3
    execute_on='timestep_end'
   []
  [T_wall]
    type = SideAverageValue
    boundary ='1'
    variable = T
    execute_on='timestep_end'
  [] 
  [htc]
    type = SideAverageValue
    boundary ='1'
    variable = htcp
    execute_on='timestep_end'
  []
  [q]
    type=ConvectiveHeatTransferSideIntegral
    T_solid = T
    boundary = 1
    T_fluid_var = T_fluid_3
    htc_var = htcp
  []
[t]
  type = s


[]
[Outputs]
  exodus = true
   [csv]
  type = CSV
  append_date = true
  []
[]
[Transfers]
  [T_fluid1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T_fluid_1
    variable = T_fluid_3
    execute_on = 'TIMESTEP_BEGIN'
    from_blocks = core1
    to_boundaries = '1'
    num_nearest_points = 2
  []
  [htc1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    execute_on = 'TIMESTEP_BEGIN '
    from_blocks= core1
    to_boundaries='1'
    num_nearest_points = 2
  []
  [Tw1]
     type = MultiAppGeneralFieldUserObjectTransfer
     source_user_object = T_wall1
     variable = T_wall
     to_multi_app = sub_app
     execute_on ='TIMESTEP_BEGIN '
     to_blocks = core1
  []
[]

