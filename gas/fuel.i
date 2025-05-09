[Mesh]
   file = 'gas13.e' 
[]

[Variables]
  [T]
   order = FIRST
   family = LAGRANGE  # 若变量特定支持自定义家族
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
                 0.05 2700000
                 0.1  3000000
                 0.15 3255000
                 0.2 3360000
                 0.25 3570000
                 0.3 3360000
                 0.35 3255000
                 0.4 3000000
                 0.45 2700000
                 0.5 2400000'
    [../]
[]



[Kernels]
  [heat_conduction_1]
    type = HeatConduction
    variable = T
  []
  [heat_source]
    type = HeatSource
    variable = T
    #value = 3e6
    function = axial_heat_source
    block = '1'
  []
[]

[BCs]
  [./coolant_boundary]
    type = ConvectiveHeatFluxBC
    variable = T # 温度变量
    boundary = '4' # 冷却剂通道外壁的边界名称
    T_infinity = T_infinity # 引用材料属性T_infinity
    heat_transfer_coefficient = heat_transfer_coefficient # 引用材料属性传热系数
  [../]
  [heat_q]
    type= NeumannBC
    variable = T
    boundary = "1 2 3"
    value = 0 # (q)
  []
[]

[Materials]
  [./fuel_material]
    type = HeatConductionMaterial
    thermal_conductivity = 7  # 燃料的热导率 (W/m·K)，替换为实际值
    #specific_heat = 200.0        # 燃料的比热容 (J/kg·K)，替换为实际值
    #density = 1e-5            # 燃料的密度 (kg/m^3)，替换为实际值
    block = '1'                  # 应用于块 ID 为 1 的区域，即燃料区域
  [../]
  [./graphite_material]
    type = HeatConductionMaterial
    thermal_conductivity = 60 # 石墨基体的热导率 (W/m·K)，替换为实际值
    #specific_heat = 710.0  # 石墨的比热容 (J/kg·K)，替换为实际值
    #density = 1.8e-6 # 石墨基体的密度 (kg/m^3)，替换为实际值
    block = '2'  # 应用于块 ID 为 2 的区域，即石墨基体区域
 [../]
[] 

[Problem]
  type = FEProblem
[]

[Executioner]
  type = Steady                      # 使用稳态求解器
  solve_type = NEWTON                # 使用牛顿法进行非线性求解
  automatic_scaling = true           # 启用自动缩放以帮助变量稳定求解
  compute_scaling_once = false       # 在每一步重新计算缩放比例

  petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart -ksp_max_it -pc_hypre_type'
  petsc_options_value = 'hypre gmres 50 1000 boomeramg'  # 增加GMRES的重启次数，最大迭代次数为1000

  nl_max_its = 100                   # 最大非线性迭代次数增加到100
  nl_abs_tol = 1e-8                  # 更严格的非线性绝对收敛容差
  nl_rel_tol = 1e-5                  # 更严格的非线性相对收敛容差
  line_search = bt                   # 启用回溯线搜索                    # 启用阻尼因子，降低每次更新幅度
[]





[Outputs]
  exodus = true
  file_base = 'steady_output'
[]
