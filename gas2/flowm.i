T_in = 300. # K
m_dot_in = 0.01# kg/s
press = 10e5 # Pa
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel=0.
  gravity_vector = '0 0 0'
  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
[]
[FluidProperties]
  [he]
    type = IdealGasFluidProperties
    molar_mass = 4e-3
    gamma = 1.67
    k = 0.2556
    mu = 3.22639e-5
  []
[]
[Closures]
  [thm_closures]
    type = Closures1PhaseTHM
  []
[]
[AuxVariables]
  [Hw]
    family = MONOMIAL
    order = CONSTANT
    block = core_chan
  []
[]
[AuxKernels]
  [hw]
    type = ADMaterialRealAux
    variable = Hw
    property = 'Hw'
  []
[]
[Components]
  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'pipe1:in'
    m_dot = ${m_dot_in}
    T = ${T_in}
  []
  [pipe1]
    type = FlowChannel1Phase
    position = '0 0 0'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A =1.2566e-3 
    D_h =1.25664e-1
  []
  [core1]
    type = FlowChannel1Phase
    position = '0.25 0 0.5 '
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A = 1.9635e-5
    D_h = 1.5707e-2
  []
  [core2]
    type = FlowChannel1Phase
    position = '-0.25 0 0.5 '
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A = 1.9635e-5
    D_h = 1.5707e-2
  []
  [core3]
    type = FlowChannel1Phase
    position = '0 0.25 0.5 '
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A = 1.9635e-5
    D_h = 1.5707e-2
  []
  [core4]
    type = FlowChannel1Phase
    position = '0 -0.25 0.5 '
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A = 1.9635e-5
    D_h = 1.5707e-2
  []
  [jct1]
    type = JunctionParallelChannels1Phase
    position = '0 0 0.5'
    connections = 'pipe1:out core1:in core2:in core3:in core4:in'
    volume = 1e-5
    use_scalar_variables = false
  []
  [pipe2]
    type = FlowChannel1Phase
    position = '0 0 1.5'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A =1.2566e-3 
    D_h =1.25664e-1
  []
  [jct2]
    type = JunctionParallelChannels1Phase
    position = '0 0 0.5'
    connections = 'core1:out core2:out core3:out core4:out pipe2:in'
    volume = 1e-5
    use_scalar_variables = false
  []
  [core_bc]
    type=HeatTransferFromSpecifiedTemperature1Phase
    flow_channel= 'core1'
    T_wall= 500
  []
  [outlet]
    type = Outlet1Phase
    input = 'pipe2:out'
    p = ${press}
  []
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]
[UserObjects]
  [T_uo]
    type = LayeredAverage
    direction = z
    variable = T
    num_layers = 25
    block = core1
  []
[]
[Postprocessors]
  [T_out]
    type = PointValue
    variable = T
    point='0 0 1'
    execute_on = 'INITIAL TIMESTEP_END'
  []  
  [Q_W]
    type =  ADHeatRateConvection1Phase
    block = core1
    P_hf = 0.0314
  []
  [T_in_8]
    type = PointValue
    variable = T
    point='0 0 0.08'
    execute_on = 'INITIAL TIMESTEP_END'
  []  
  [T_in_6]
    type = PointValue
    variable = T
    point='0 0 0.06'
    execute_on = 'INITIAL TIMESTEP_END'
  [] 
  [T_in_0]
    type = PointValue
    variable = T
    point='0 0 0'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_in_4]
    type = PointValue
    variable = T
    point='0 0 0.04'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_in_25]
    type = PointValue
    variable = T
    point='0 0 0.025'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_in_3]
    type = PointValue
    variable = T
    point='0 0 0.03'
    execute_on = 'INITIAL TIMESTEP_END'
  [] 
  [T_in_2]
    type = PointValue
    variable = T
    point='0 0 0.02'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [average]
    type = ElementAverageValue
    variable = T
  []
  [hw_out]
    type = PointValue
    variable = Hw
    point='0 0 1'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [core_T_in]
    type = SideAverageValue
    boundary = core_chan:in
    variable = T
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time =0.1
  dt = 0.001
  dtmin=1e-4
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  nl_max_its = 25
[]
[Outputs]
  exodus = true
  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
[]  

