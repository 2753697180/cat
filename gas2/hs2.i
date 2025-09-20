[Mesh]
  file = gas2.e
[]
[Variables]
  [T]
    family = LAGRANGE
    order  = FIRST
    initial_condition = '500' # Start at room temperature
  []
[]
[AuxVariables]
  [T_fluid]
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
    block = '2'  # 应用于块 ID 为 2 的区域，即石墨基体区域
  []
[]
[MultiApps]
  [sub_app]
    # poistion='0,0,1'
    type = TransientMultiApp
    input_files = 'flow.i'
    execute_on = 'timestep_end INITIAL'
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
  end_time = 1
  dt = 0.5
  dtmin = 1e-4
  start_time = 0
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]
[Postprocessors]
  [T_fluid]
   type = SideAverageValue
   boundary = '1'
   variable = T_fluid
  []
  [T]
    type = SideAverageValue
    boundary = '1'
    variable = T
  []
[]
[Outputs]
  exodus = true
  [csv]
    type=CSV
  []
[]
[Transfers]
  [T_fluid1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core1
    to_boundaries='1'
  []
  [T_fluid2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core2
    to_boundaries='2'
  []
  [T_fluid3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core3
    to_boundaries='3'
  []
  [T_fluid4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core4
    to_boundaries='4'
  []
  [T_fluid5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core5
    to_boundaries='5'
  []
  [T_fluid6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core6
    to_boundaries='6'
  []
  [T_fluid7]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core7
    to_boundaries='7'
  []
  [T_fluid8]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core8
    to_boundaries='8'
  []
  [T_fluid9]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core9
    to_boundaries='9'
  []
  [T_fluid10]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core10
    to_boundaries='10'
  []
  [T_fluid11]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core11
    to_boundaries='11'
  []
  [T_fluid12]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T_fluid'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core12
    to_boundaries='12'
  []
  [htc1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core1
    to_boundaries='1'
  []
  [htc2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core2
    to_boundaries='2'
  []
  [htc3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core3
    to_boundaries='3'
  []
  [htc4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core4
    to_boundaries='4'
  []
  [htc5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core5
    to_boundaries='5'
  []
  [htc6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core6
    to_boundaries='6'
  []
  [htc7]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core7
    to_boundaries='7'
  []
  [htc8]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core8
    to_boundaries='8'
  []
  [htc9]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core9
    to_boundaries='9'
  []
  [htc10]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core10
    to_boundaries='10'
  []
  [htc11]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core11
    to_boundaries='11'
  []
  [htc12]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
    from_blocks= core12
    to_boundaries='12'
  []
  [T_wall1]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall1
    execute_on = 'timestep_end INITIAL'
    to_blocks = core1
  []
  [T_wall2]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = T_wall
    source_user_object = T_wall2
    execute_on = 'timestep_end INITIAL'
    to_blocks= core2
  []
  [T_wall3]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall3
    execute_on = 'timestep_end INITIAL'
    to_blocks= core3
  []
  [T_wall4]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall4
    execute_on = 'timestep_end INITIAL'
    to_blocks= core4
  []
  [T_wall5]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall5
    execute_on = 'timestep_end INITIAL'
    to_blocks= core5
  []
  [T_wall6]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall6
    execute_on = 'timestep_end INITIAL'
    to_blocks= core6
  []
  [T_wall7]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall7
    execute_on = 'timestep_end INITIAL'
    to_blocks= core7
  []
  [T_wall8]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall8
    execute_on = 'timestep_end INITIAL'
    to_blocks= core8
  []
  [T_wall9]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall9
    execute_on = 'timestep_end INITIAL'
    to_blocks= core9
  []
  [T_wall10]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall10
    execute_on = 'timestep_end INITIAL'
    to_blocks= core10
  []
  [T_wall11]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall11
    execute_on = 'timestep_end INITIAL'
    to_blocks= core11
  []
  [T_wall12]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall12
    execute_on = 'timestep_end INITIAL'
    to_blocks= core12
  []
[]
[VectorPostprocessors]
  [T_wall_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = T_wall1
  []
[]
