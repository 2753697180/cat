T_in = 300. # K
press = 10e5 # Pa
m_dot_in = 1e-2 # kg/s
# core parameters
# pipe parameters
pipe_dia = '${units 10. cm -> m}'
A_pipe = '${fparse 0.25 * pi * pipe_dia^2}'
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel=0.0001
  gravity_vector = '0 0 0'
  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
  fp=he
  initial_vel_x = 0
  initial_vel_y = 0
  initial_vel_z = 0
  scaling_factor_rhoV = 1
  scaling_factor_rhouV = 1e-2
  scaling_factor_rhovV = 1e-2
  scaling_factor_rhowV = 1e-2
  scaling_factor_rhoEV = 1e-4
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
  [htc]
    family = MONOMIAL
    order = CONSTANT
    block = 'core1 core2 core3 core4 core5 core6 core7 core8 core9 core10 core11 core12'
  []
  [T_w]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 400
  []
[]
[AuxKernels]
  [hw]
    type = ADMaterialRealAux
    variable = htc
    property = 'Hw'
  []
[]
[Components]
  [up_pipe_1]
    type = FlowChannel1Phase
    position = '0 0 -0.5'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A =3.14e-4 
    D_h = 0.02
  []
  [core1]
    type = FlowChannel1Phase
    position = '-0.010 0.01732 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core2]
    type = FlowChannel1Phase
    position = '-0.02 0 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core3]
    type = FlowChannel1Phase
    position = '-0.010 -0.01732 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core4]
    type = FlowChannel1Phase
    position = '0.010 -0.01732 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core5]
    type = FlowChannel1Phase
    position = '0.02 0 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core6]
    type = FlowChannel1Phase
    position = '0.010 0.01732 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core7]
    type = FlowChannel1Phase
    position = '-0.020 0.03464 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core8]
    type = FlowChannel1Phase
    position = '-0.04 0 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core9]
    type = FlowChannel1Phase
    position = '-0.020 -0.03464 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core10]
    type = FlowChannel1Phase
    position = '0.020 -0.03464 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core11]
    type = FlowChannel1Phase
    position = '0.040 0 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [core12]
    type = FlowChannel1Phase
    position = '0.020 0.03464 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5 
    D_h = 0.005
  []
  [jct1]
    type = VolumeJunction1Phase
    position = '0 0 0'
    connections = 'up_pipe_1:out core1:in core2:in core3:in core4:in core5:in core6:in core7:in core8:in core9:in core10:in core11:in core12:in'
    volume = 1e-4
    use_scalar_variables = false
  []
  [up_pipe_2]
    type = FlowChannel1Phase
    position = '0 0 0.55'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A =3.14e-4 
    D_h = 0.02
  []
  [jct2]
    type =VolumeJunction1Phase
    position = '0 0 0.55'
    connections = 'core1:out core2:out core3:out core4:out core5:out core6:out core7:out core8:out core9:out core10:out core11:out core12:out up_pipe_2:in'
    volume = 1e-4
    use_scalar_variables = false
  []
  [jct3]
    type =VolumeJunction1Phase
    position = '0 0 1.05'
    volume = 1e-4
    connections = 'up_pipe_2:out top_pipe_1:in'
    use_scalar_variables = false  
  []
  [top_pipe_1]
    type = FlowChannel1Phase
    position = '0 0 1.05'
    orientation = '1 0 0'
    length = 0.5
    n_elems = 10
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [top_pipe_2]
    type = FlowChannel1Phase
    position = '0.5 0 1.05'
    orientation = '1 0 0'
    length = 0.5
    n_elems = 20
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [press_pipe]
    type = FlowChannel1Phase
    position = '0.5 0 1.05'
    orientation = '0 0 1'
    length = 0.2
    n_elems = 5
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [pressurizer]
    type = Outlet1Phase
    p = ${press}
    input = press_pipe:out
  []
  [jct4]
    type = VolumeJunction1Phase
    position = '0.5 0 1.05'
    volume = 1e-3
    connections = 'top_pipe_1:out top_pipe_2:in press_pipe:in'
    use_scalar_variables = false
  []
  [jct5]
    type = VolumeJunction1Phase
    position = '1 0 1.05'
    volume = 1e-3
    connections = 'top_pipe_2:out down_pipe_1:in '
   use_scalar_variables = false
  []
  [down_pipe_1]
    type = FlowChannel1Phase
    position = '1 0 1.05'
    orientation = '0 0 -1'
    length = 0.25
    A = ${A_pipe}
    n_elems = 5
  []
  [jct6]
    type = VolumeJunction1Phase
    position = '1 0 0.8'
    volume = 1e-5
    connections = 'down_pipe_1:out cooling_pipe:in'
    use_scalar_variables = false
  []
  [cooling_pipe]
    type = FlowChannel1Phase
    position = '1 0 0.8'
    orientation = '0 0 -1'
    length = 1.1
    n_elems = 25
    A = ${A_pipe}
  []
  [jct7]
    type = VolumeJunction1Phase
    position = '1 0 -0.3'
    volume = 1e-5
    connections = 'cooling_pipe:out down_pipe_2:in'
    use_scalar_variables = false
  []
  [down_pipe_2]
    type = FlowChannel1Phase
    position = '1 0 -0.3'
    orientation = '0 0 -1'
    length = 0.2
    n_elems = 10
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [jct8]
    type = VolumeJunction1Phase
    position = '1 0 -0.5'
    volume = 1e-5
    connections = 'down_pipe_2:out bottom_1:in'
    use_scalar_variables = false
  []
  [bottom_1]
    type = FlowChannel1Phase
    position = '1 0 -0.5'
    orientation = '-1 0 0'
    length = 0.5
    n_elems = 10
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
 [pump]
    type = Pump1Phase
    position = '0.5 0 0'
    connections = 'bottom_1:out bottom_2:in'
    volume = 1e-4
    A_ref = ${A_pipe}
    head = 0
    use_scalar_variables = false
  []
  [bottom_2]
    type = FlowChannel1Phase
    position = '0.5 0 -0.5'
    orientation = '-1 0 0'
    length = 0.5
    n_elems = 10
    A = ${ fparse A_pipe/4}
    D_h = ${fparse pipe_dia/2}
  []
  [jct9]
    type = VolumeJunction1Phase
    position = '0 0 -0.5'
    volume = 1e-5
    connections = 'bottom_2:out up_pipe_1:in'
    use_scalar_variables = false
  []
  #############boundry condition
  [cold_wall]
    type = HeatTransferFromSpecifiedTemperature1Phase
    flow_channel = cooling_pipe
    T_wall = ${T_in}
    P_hf = '${fparse pi * pipe_dia}'
    var_type = ELEMENTAL
  []
  [bc1]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core1 
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc2]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core2
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc3]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core3
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc4]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core4
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc5]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core5
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc6]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core6
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc7]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core7
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc8]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core8
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc9]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core9 
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc10]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core10 
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc11]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core11
    T_ext = T_wall
    var_type = ELEMENTAL
  []
  [bc12]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel= core12
    T_ext = T_wall
    var_type = ELEMENTAL
  []
[]
[ControlLogic]
  [set_point]
    type = GetFunctionValueControl
    function = ${m_dot_in}
  []
  [pid]
    type = PIDControl
    initial_value = 550
    set_point = set_point:value
    input = m_dot_pump
    K_p = 10000
    K_i = 4000
    K_d = 0
  []
  [set_pump_head]
    type = SetComponentRealValueControl
    component = pump
    parameter = head
    value = pid:output
  []
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]
[Postprocessors]
  [m_dot_pump]
    type = ADFlowJunctionFlux1Phase
    boundary = bottom_2:out
    connection_index = 0
    equation = mass
    junction = jct9
  []
  [pump_head]
    type = RealComponentParameterValuePostprocessor
    component = pump
    parameter = head
  []
  [pump_out]
    type = SideAverageValue
    boundary = up_pipe_1:in
    variable = p
  []
  [pump_p_in]
    type = SideAverageValue
    boundary = core1:out
    variable = p
  []
  [power_to_coolant]
    type = ADHeatRateConvection1Phase
    block = cooling_pipe
    P_hf = '${fparse pi *pipe_dia}'
  []
  [p_t_h]
    type = ADHeatRateConvection1Phase
    P_hf =${fparse pi*0.005}
    block = core1 
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time =30
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
  []
[]


  

    

