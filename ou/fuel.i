[Mesh]
   file = 'ouhe.e' 
[]

[Variables]
  [T]
   order = FIRST
   family = LAGRANGE  # 若变量特定支持自定义家族
   initial_condition = '300' # Start at room temperature
  []
[]

[Functions]
  [./axial_heat_source1]
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
      if(z < 0.5, 2.7e6, 2.4e6))))))))))
    '
  [../]

      [./axial_heat_source2]
        type = ParsedFunction
        expression = '
          if(z < 0.05, 2400000,
            if(z < 0.1,  2700000,
              if(z < 0.15,  3000000,
                if(z < 0.2,  3255000,
                  if(z < 0.25, 3360000,
                    if(z < 0.3,  3570000,
                      if(z < 0.35,  3360000,
                        if(z < 0.4,  3255000,
                          if(z <0.45,  3000000,
                            if(z < 0.5,  2700000,  2400000))))))))))'
      [../]

  [./axial_heat_source]
      type = PiecewiseConstant
      axis = z
      direction = left
      xy_data = '0 2400000
                 0.0909 2700000
                 0.181  3000000
                 0.272 3255000
                 0.363 3360000
                 0.454 3570000
                 0.545 3360000
                 0.636 3255000
                 0.727 3000000
                 0.818 2700000
                 0.909 2400000'
    [../]
[]

[AuxVariables]
  [./layered_side_average]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]
 
[Kernels]
  [heat_conduction_1]
    type = ADHeatConduction
    variable = T
  []
  [heat_source]
    type = HeatSource
    variable = T
    value = 3e6
    #function = axial_heat_source
    block = '1'
  []
[]

[AuxKernels]
  [./lsia]
    type = SpatialUserObjectAux
    variable = layered_side_average
    boundary = '4'
    user_object = layered_side_average
  [../]
[]

[BCs]
   [./right]
     type = NeumannBC
     variable = T
     boundary = '4'
     value = 0
   [../]
  [heat_q]
    type= NeumannBC
    variable = T
    boundary = "1 2 3"
    value = 500 # (q)
  []
[]
[Materials]
  [fuel_material]
    type = fuel
    block = '1'  # 应用于块 ID 为 1 的区域，即燃料区域
  []
[] 

[UserObjects]
  [./layered_side_average]
    type = LayeredSideAverage
    direction = z
    num_layers = 20
    variable = T
    execute_on = 'TIMESTEP_END'
    boundary = '4'
  [../]
[]
[VectorPostprocessors]
  [abc]
    type = SpatialUserObjectVectorPostprocessor
    userobject = layered_side_average
    execute_on = 'TIMESTEP_END'
  []
[]
[Problem]
  type = FEProblem
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 10
  dt = 1
  dtmin = 1e-4
  start_time = 0
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-6

  fixed_point_rel_tol = 1e-6
  fixed_point_abs_tol = 1e-8
[]

[Outputs]
  exodus = true
  csv = true
  file_base = 'steady_output'
[]

