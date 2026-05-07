[Mesh]
  file = mug.e
[]

[UserObjects]
  [./soln]
    type = SolutionUserObject
    mesh = irrFCC_poly_5dpa.e
    system_variables = stress_hydro
    timestep = 2500
  [../]
[]

[AuxVariables]
  [./grainBoundaryNormalStress]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./grainBoundaryStress]
    type = SolutionAux
    solution = soln
    variable = grainBoundaryStress
  [../]
[]

[Variables]
  [C_ox]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [diff]
    type = Diffusion
    variable = C_ox
  []
  [drift]
    type = GrainBoundaryDrift
    variable = C_ox
    #Vatom = 9.9E-30
    #T = 300
    
  []
  [oxidation]
    type = SimpleOxidation
    variable = C_ox
  []
[]

[BCs]
  [sources]
    type = DirichletBC
    variable = C_ox
    boundary = 'source'
    value = 1
  []
  [sinks]
    type = gbDiffusionFluxBC
    variable = C_ox
    boundary = 'sink'
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
