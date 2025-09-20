T_in = 300. # K
m_dot_in = 0.01# kg/s
press = 30e5 # Pa
# core parameters
core_inv=0.001#m/s
core_length=0.6 #m
core_elems=30
core_dia = '${units 10. cm -> m}'
core_A_pipe = '${fparse 0.25 * pi * core_dia^2}'
#pipe parameters
pipe_dia = '${units 10. cm -> m}'
A_pipe = '${fparse 0.25 * pi * pipe_dia^2}'
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel=0.1
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
    block = 'core1'
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
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [core1]
    type = FlowChannel1Phase
    position = '-0.010 0.01732 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
    initial_vel = ${core_inv}
  []
  [jct1]
    type = VolumeJunction1Phase
    position = '0 0 0'
    connections = 'pipe1:out core1:in '
    volume = 1e-5
    use_scalar_variables = false
  []
  [pipe2]
    type = FlowChannel1Phase
    position = '0 0 0.55'
    orientation = '0 0 1'
    length = 0.5
    n_elems = 15
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  [jct2]
    type =VolumeJunction1Phase
    position = '0 0 0.55'
    connections = 'core1:out pipe2:in'
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
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time =10
  dt = 0.001
  dtmin=1e-4
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  nl_rel_tol = 1e-5
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


  

    

