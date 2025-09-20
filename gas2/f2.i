T_in = 300. # K
press = 30e5 # Pa
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
    block = 'core1 '
  []
  [T_w]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 400
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
    position = '-0 0 0'
    orientation = '0 0 1'
    length = 0.55
    n_elems = 10
    A = 1.9635e-5
    D_h = 0.005
  []
  [jct1]
    type = VolumeJunction1Phase
    position = '0 0 0'
    connections = 'up_pipe_1:out core1:in'
    volume = 1e-4
    use_scalar_variables = false
  []
  [jct2]
    type =VolumeJunction1Phase
    position = '0 0 0.55'
    connections = 'core1:out up_pipe_2:in'
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
  [jct3]
    type =VolumeJunction1Phase
    position = '0 0 1.05'
    connections = 'up_pipe_2:out top_pipe:in'
    volume = 1e-4
    use_scalar_variables = false
  []
  [top_pipe]
    type = FlowChannel1Phase
    position = '0 0 1.05'
    orientation = '1 0 0'
    length = 0.5
    n_elems = 20
    A = ${A_pipe}
    D_h = ${pipe_dia}
  []
  # boundry condition
  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'up_pipe_1:in'
    m_dot = ${m_dot_in}
    T = ${T_in}
  []
  [outlet]
    type = Outlet1Phase
    p = ${press}
    input = 'top_pipe:out'
  []
  [bc1]
    type = HeatTransferFromSpecifiedTemperature1Phase
    T_wall = 400
    flow_channel= core1 
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
  end_time =2
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


  

    

