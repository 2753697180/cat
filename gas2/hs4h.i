[Mesh]
  file = gas2.e
[]
#!include z_dev.i
[Variables]
  [T]
    family = LAGRANGE
    order  = FIRST
    initial_condition = 300 
  []
[]
[AuxVariables]
  [T_fluid_3]
    family = MONOMIAL
    order  = CONSTANT
    initial_condition = 300
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
    boundary = '1 2 3 4 5 6 7 8 9 10 11 12'
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
    input_files = 'f5np.i'
    execute_on = 'TIMESTEP_END MULTIAPP_FIXED_POINT_BEGIN'
    sub_cycling = true
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type -KSP_TYPE'
  petsc_options_value = 'hypre boomeramg gmres'
  end_time = 30
  dt = 0.01
  dtmin = 1e-4
  start_time = 0
  steady_state_tolerance = 1e-5
  steady_state_detection = true
  fixed_point_max_its = 10
  fixed_point_min_its = 2
  nl_abs_tol = 1e-5
  fixed_point_rel_tol = 1e-5
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
  [T_wall2]
    type = SideAverageValue
    boundary ='2'
    variable = T
    execute_on='timestep_end'
  [] 
  [T_f2]
    type = SideAverageValue
    boundary = '2'
    variable = T_fluid_3
    execute_on='timestep_end'
  []
  [htc2]
    type = SideAverageValue
    boundary ='2'
    variable = htcp
    execute_on='timestep_end'
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
    variable = 'T_w'
    to_blocks= core1
    from_boundaries='1'
    search_value_conflicts = false
  []
  [T_fluid2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core2
    to_boundaries = '2'
    search_value_conflicts = false
  []
  [htc2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core2
    to_boundaries='2'
    search_value_conflicts = false
  []
  [Tw2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core2
    from_boundaries='2'
    search_value_conflicts = false
  []
  [T_fluid3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core3
    to_boundaries = '3'
    search_value_conflicts = false
  []
  [htc3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core3
    to_boundaries='3'
    search_value_conflicts = false
  []
  [Tw3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core3
    from_boundaries='3'
    search_value_conflicts = false
  []
  [T_fluid4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core4
    to_boundaries = '4'
    search_value_conflicts = false
  []
  [htc4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core4
    to_boundaries='4'
    search_value_conflicts = false
  []
  [Tw4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core4
    from_boundaries='4'
    search_value_conflicts = false
  []
  [T_fluid5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core5
    to_boundaries = '5'
    search_value_conflicts = false
  []
  [htc5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core5
    to_boundaries='5'
    search_value_conflicts = false
  []
  [Tw5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core5
    from_boundaries='5'
    search_value_conflicts = false
  []
  [T_fluid6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core6
    to_boundaries = '6'
    search_value_conflicts = false
  []
  [htc6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core6
    to_boundaries='6'
    search_value_conflicts = false
  []
  [Tw6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core6
    from_boundaries='6'
    search_value_conflicts = false
  []
  [T_fluid7]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core7
    to_boundaries = '7'
    search_value_conflicts = false
  []
  [htc7]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core7
    to_boundaries='7'
    search_value_conflicts = false
  []
  [Tw7]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core7
    from_boundaries='7'
    search_value_conflicts = false
  []
  [T_fluid8]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core8
    to_boundaries = '8'
    search_value_conflicts = false
  []
  [htc8]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core8
    to_boundaries='8'
    search_value_conflicts = false
  []
  [Tw8]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core8
    from_boundaries='8'
    search_value_conflicts = false
  []
  [T_fluid9]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core9
    to_boundaries = '9'
    search_value_conflicts = false
  []
  [htc9]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core9
    to_boundaries='9'
    search_value_conflicts = false
  []
  [Tw9]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core9
    from_boundaries='9'
    search_value_conflicts = false
  []
  [T_fluid10]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core10
    to_boundaries = '10'
    search_value_conflicts = false
  []
  [htc10]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core10
    to_boundaries='10'
    search_value_conflicts = false
  []
  [Tw10]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core10
    from_boundaries='10'
    search_value_conflicts = false
  []
  [T_fluid11]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core11
    to_boundaries = '11'
    search_value_conflicts = false
  []
  [htc11]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core11
    to_boundaries='11'
    search_value_conflicts = false
  []
  [Tw11]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core11
    from_boundaries='11'
    search_value_conflicts = false
  []
  [T_fluid12]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid_3
    from_blocks = core12
    to_boundaries = '12'
    search_value_conflicts = false
  []
  [htc12]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'htc'
    variable = 'htcp'
    from_blocks= core12
    to_boundaries='12'
    search_value_conflicts = false
  []
  [Tw12]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app
    source_variable = 'T_wall'
    variable = 'T_w'
    to_blocks= core12
    from_boundaries='12'
    search_value_conflicts = false
  []
[]


