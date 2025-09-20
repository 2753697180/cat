T_in = 300. # K
m_dot_in = 1e-2# kg/s
press = 10e5 # Pa

[GlobalParams]
  initial_p = ${press}
  initial_vel = 0.0001
  initial_T = ${T_in}
  gravity_vector = '0 0 0'

  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
  fp = he
[]
[AuxVariables]
  [hw]
     family = MONOMIAL
     order = CONSTANT
  []
  [h]
    family = MONOMIAL
    order = CONSTANT
  []
[]
[AuxKernels]
  [hw]
    type = ADMaterialRealAux
    variable = hw
    property = 'Hw'
  []
  [h]
    type = ADMaterialRealAux
    variable = h
    property = 'h'
  []
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
    wall_htc_closure =wolf_mccarthy
  []
[]
[Components]
  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'core_chan:in'
    m_dot = ${m_dot_in}
    T = ${T_in}
  []
  [core_chan]
    type = FlowChannel1Phase
    position = '0 0 0'
    orientation = '0 0 1'
    length = 1
    n_elems = 20
    A = 3.14e-4
    D_h = 0.02
    f=2e-2
  []
  [outlet]
    type = Outlet1Phase
    input = 'core_chan:out'
    p = ${press}
  []
  [bc]
    type=HeatTransferFromSpecifiedTemperature1Phase
    T_wall = 400
    flow_channel =core_chan
  [] 
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]
[Postprocessors]
  [power_to_coolant]
    type = ADHeatRateConvection1Phase
    block = core_chan
    P_hf = 6.28e-2
  []
  [T]
    type = ElementAverageValue
    variable = T
    block = core_chan
  []
  [h_in]
    type=SideAverageValue
    boundary = core_chan:in
    variable = h
  []
  [h_out]
    type=SideAverageValue
    boundary = core_chan:out
    variable = h
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time = 10
  dt = 0.01
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
