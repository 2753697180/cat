[Mesh]
  file = gas2.e

[]
[Functions]
  [heat_source1]
    type = ParsedFunction
    expression = '
      if(z < 0.05, 2.4e6,
        if(z < 0.1, 2.7e6,
         if(z < 0.15, 3e6,
           if(z < 0.2, 3.255e6,
              if(z < 0.25, 3.36e6,
                if(z < 0.3, 3.57e6,
                   if(z < 0.35, 3.57e6,
                     if(z < 0.4, 3.36e6,
      if(z < 0.45, 3.255e6,
      if(z < 0.55, 2.7e6, 2.4e6))))))))))'
  []
[]
[Variables]
  [T]
    family = LAGRANGE
    order = FIRST
    initial_condition = '300' # Start at room temperature
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
    #value = 3e6
    function = heat_source1
    block = '13'
  []
  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = T
  []
[]

[BCs]
  [heat_q]
    type = NeumannBC
    variable = T
    boundary = '2'
    value = 0 # (q)
  []
  [uo]
    type = ConvectiveHeatFluxBC
    T_infinity = 300
    boundary = ' 1 ' 
    heat_transfer_coefficient = 150
    variable = T
  []
[]

[Materials]
  [column]
    type = PackedColumn
  []
[]

[Executioner]
  # fixed_point_max_its = 10
  type = Transient
  solve_type = PJFNK
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 20
  dt = 1
  dtmin = 1e-7
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]

[Outputs]
  exodus = true
  file_base = heatflux
[]
