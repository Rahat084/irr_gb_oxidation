# Gloal Parameters
Diff_coef = 0.0001
Reac_rate = 100

[Mesh]
  [./fmg]
    type = FileMeshGenerator
    file = six_grain_poly_gb.msh
    allow_renumbering = False
  []
  [scale_down]
    type = TransformGenerator
    input = fmg
    transform = SCALE
    vector_value = '1.49e-3 1.49e-3 1.49e-3'
  []
[]

[UserObjects]
  [./soln]
    type = SolutionUserObject
    mesh = "gb_normal_stress.e"
    system_variables = stress_hydro
    timestep = 30 
  [../]
[]

[AuxVariables]
  [./grainBoundaryNormalStress]
    order = FIRST
    family = LAGRANGE
  [../]
  [./mdot]
    order = FIRST
    family = LAGRANGE
  [../]
  [./m]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./grainBoundaryStress]
    type = SolutionAux
    variable = grainBoundaryNormalStress
    solution = soln
    from_variable = stress_hydro
  [../]
  [./mdot]
    type = ParsedAux
    variable = mdot
    expression = 'C_ox * ${fparse Reac_rate}'
    coupled_variables = 'C_ox'
  [../]
  [./ TrapazoidalTimeIntegrator]
    type = VariableTimeIntegrationAux
    variable_to_integrate = mdot
    variable = m
    order = 1 
  [../]
[]

[Variables]
  [C_ox]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [timeDerive]
    type = DiffTimeDerivative
    variable = C_ox
    Diffusion_coefficient = '${Diff_coef}'
  []
  [diff]
    type = Diffusion
    variable = C_ox
  []
  [drift]
    type = GrainBoundaryDrift
    variable = C_ox
    #Vatom = 2.703E-30  # Volume per atom
    #T = 300          # Temperature
    grain_boundary_normal_stress = grainBoundaryNormalStress
  []
  [oxidation]
    type = SimpleOxidation
    variable = C_ox
    Diffusion_coefficient = '${Diff_coef}'
    Reaction_rate = '${Reac_rate}'
  []
[]

[BCs]
  [sources]
    type = DirichletBC
    variable = C_ox
    boundary = 'source'
    value =  1.0
  []
  [sinks]
    type = gbDiffusionFluxBC
    variable = C_ox
    grain_boundary_normal_stress = grainBoundaryNormalStress
    boundary = 'sink'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  start_time = 0.0
  end_time = 1.0
  dt = 0.025
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-8
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
