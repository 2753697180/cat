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
[AuxVariables]
  [T_fluid_3]
    family = MONOMIAL
    order  = CONSTANT
    initial_condition = '300'
  []
  [htcp]
    family = MONOMIAL
    order  = CONSTANT
  []
  [T_wall]
    family=MONOMIAL
    order=CONSTANT
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
[AuxKernels]
  [Twall]
    type = ProjectionAux
    v = T
    variable = T_wall
    boundary = '1'
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
    num_layers = 10
    boundary = '1'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_fluid_uo]
    type = LayeredSideAverage
    num_layers = 10
    boundary = '1'
    variable = 'T_fluid_3'
    direction = z
    execute_on = 'timestep_end'
  []
  [htc2]
    type = LayeredSideAverage
    num_layers = 10
    boundary = '1'
    variable = 'htcp'
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
    #app_type = ThermalHydraulicsApp
    type = TransientMultiApp
    input_files = 'f.i'
    execute_on = MULTIAPP_FIXED_POINT_BEGIN
    #sub_cycling = true
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 0.01
  dt = 0.001
  dtmin = 1e-4
  start_time = 0
  steady_state_tolerance = 1e-5
  steady_state_detection = true
  fixed_point_max_its = 10
  nl_abs_tol = 1e-6
  fixed_point_rel_tol = 1e-6
  fixed_point_abs_tol = 1e-8
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
  [q1]
    type=ConvectiveHeatTransferSideIntegral
    T_solid = T
    boundary = 1
    T_fluid_var = T_fluid_3
    htc_var = htcp
    execute_on = 'TIMESTEP_END'
  []
  [q2]
    type=ConvectiveHeatTransferSideIntegral
    T_solid = T_wall
    boundary = 1
    T_fluid_var = T_fluid_3
    htc_var = htcp
    execute_on = 'TIMESTEP_END'
  []
[]
[Outputs]
  exodus = true
[]
[Transfers]
  [T_fluid1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core1
    to_boundaries = '1'
    search_value_conflicts = false
  []
  [htc1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core1
    to_boundaries='1'
    search_value_conflicts = false
  []
  [Tw1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_wall'
    to_blocks= core1
    from_boundaries='1'
    search_value_conflicts = false
  []
[]
[VectorPostprocessors]
  [T_point]
   type = SideValueSampler
   boundary = '1'
   sort_by = Z
   variable =T 
  []
  [T_wall_point]
   type = SideValueSampler
   boundary = '1'
   sort_by = Z
   variable =T_wall
  []
  [T_fluid3_point]
   type = SideValueSampler
   boundary = '1'
   sort_by = Z
   variable =T_fluid_3
  []
  [htc_point]
   type = SideValueSampler
   boundary = '1'
   sort_by = Z
   variable =htcp
  []
[]

