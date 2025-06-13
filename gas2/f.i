T_in = 300. # K
m_dot_in = 0.01# kg/s
press = 1e5 # Pa
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel=0.
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
  [T_fluid_1]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 300
  []
  [T_wall]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 400
  []
[]
[MeshDivisions]
  [z_dev_sub]
    type = CartesianGridDivision
    nx = 1 
    ny =  1 
    nz =  11
    widths = '0 0 0.05'
    bottom_left = '-0.010 0.01732 0'
    top_right = '-0.010 0.01732 0.55'
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
  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'pipe1:in'
    m_dot = ${m_dot_in}
    T = ${T_in}
  []
  [pipe1]
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
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core3]
    type = FlowChannel1Phase
    position = '-0.010 -0.01732 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core4]
    type = FlowChannel1Phase
    position = '0.010 -0.01732 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core5]
    type = FlowChannel1Phase
    position = '0.02 0 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core6]
    type = FlowChannel1Phase
    position = '0.010 0.01732 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core7]
    type = FlowChannel1Phase
    position = '-0.020 0.03464 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core8]
    type = FlowChannel1Phase
    position = '-0.04 0 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core9]
    type = FlowChannel1Phase
    position = '-0.020 -0.03464 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core10]
    type = FlowChannel1Phase
    position = '0.020 -0.03464 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core11]
    type = FlowChannel1Phase
    position = '0.040 0 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [core12]
    type = FlowChannel1Phase
    position = '0.020 0.03464 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 15
    A = 1.9635e-5
    D_h = 0.005
  []
  [jct1]
    type = VolumeJunction1Phase
    position = '0 0 0'
    connections = 'pipe1:out core1:in core2:in core3:in core4:in core5:in core6:in core7:in core8:in core9:in core10:in core11:in core12:in'
    volume = 1e-5
    use_scalar_variables = false
  []
  [pipe2]
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
    connections = 'core1:out core2:out core3:out core4:out core5:out core6:out core7:out core8:out core9:out core10:out core11:out core12:out pipe2:in'
    volume = 1e-5
    use_scalar_variables = false  
  []
  [outlet]
    type = Outlet1Phase
    input = 'pipe2:out'
    p = ${press}
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
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]
[Postprocessors]
  [T_f]
    type = ElementAverageValue
    block = core1
    variable = T
    execute_on='timestep_end'
  []
  [T_f2]
    type = ElementAverageValue
    block = core2
    variable = T
    execute_on='timestep_end'
  []  
  [htc]
    type = ElementAverageValue
    block = core1
    variable = htc
    execute_on='timestep_end'
  []
  [htc2]
    type = ElementAverageValue
    block = core2
    variable = htc
    execute_on='timestep_end'
  []
  [T_wall]
    type = ElementAverageValue
    block = core1
    variable = T_wall
    execute_on='timestep_end'
  []
 [T_wall2]
    type = ElementAverageValue
    block = core2
    variable = T_wall
    execute_on='timestep_end'
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time =120
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


  

    

