#global params
T_in = 300. # K
press = 30e5 # Pa
m_dot_in=1e-2 # kg/s
# core parameters
core_length=0.5 #m
core_elems=10
# core parameters
# pipe parameters
core_dia = '${units  2 cm -> m}'
core_A_pipe = '${fparse 0.25 * pi * core_dia^2}'
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel=0.001
  gravity_vector = '0 0 0'
  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
  fp=he
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
  [core1]
    type = FlowChannel1Phase
    position = '-0.010 0.01732 0'
    orientation = '0 0 1'
    length = ${core_length}
    n_elems = ${core_elems}
    A = ${core_A_pipe}
    D_h = ${core_dia}
  []
  #############boundry condition
  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'core1:in'
    m_dot = ${m_dot_in}
    T = ${T_in}
  []
  [outlet]
    type = Outlet1Phase
    p = ${press}
    input = 'core1:out'
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
[Postprocessors]
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


  

    

