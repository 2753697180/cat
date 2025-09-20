# Solid domain heat conduction with internal heat generation from fission
# Coupled to fluid domain through matched boundary condition
# This input file is for the solid domain only    
inlet_T= 300# K
[Mesh]
  type = FileMesh
  file = vtb.e
[]
[Variables]
  [T]
    initial_condition = ${inlet_T}
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
[BCs]
  [pin_outer]
    type = MatchedValueBC
    variable = T
    v = thm_temp
    boundary = '1'
  []
[]
[Materials]
  [fuel_material]
    type = fuel
    block = '1'  # 应用于块 ID 为 1 的区域，即燃料区域
  []
[]
[Postprocessors]
  [flux_integral] # evaluate the total heat flux for normalization
   type = ADSideDiffusiveFluxIntegral
    diffusivity = thermal_conductivity
    variable = T
    boundary = '1'
  []
[]
[AuxVariables]
  [thm_temp]
  []
  [flux]
    family = MONOMIAL
    order = CONSTANT
  []
  [power]
    family = MONOMIAL
    order = CONSTANT
  []
[]
[MultiApps]
  [sub_app]
    type = TransientMultiApp
    input_files = 'thm.i'
    execute_on = 'timestep_begin'
  []
[]
[AuxKernels]
  [flux]
    type = DiffusionFluxAux
    diffusion_variable = T
    component = normal
    diffusivity = thermal_conductivity
    variable = flux
    boundary = '1'
    check_boundary_restricted = false
  []
[]
[Executioner]
  type = Transient
  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-16
  petsc_options_value = 'hypre boomeramg'
  petsc_options_iname = '-pc_type -pc_hypre_type'
[]
[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
[]
[Transfers]
  [q_to_thm]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable =flux 
    variable =q_wall 
    to_multi_app = sub_app
    from_boundaries = '1'
    to_blocks  = core1
    search_value_conflicts = false
  []
  [T_to_solid]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = T_wall
    variable = thm_temp
    from_blocks  = core1
    to_boundaries = '1'
    search_value_conflicts = false
  []
[]