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
    timestep = 15 
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
    variable = grainBoundaryNormalStress
    solution = soln
    from_variable = stress_hydro
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
    #Vatom = 9.9E-30  # Volume per atom
    #T = 300          # Temperature
    grain_boundary_normal_stress = grainBoundaryNormalStress
  []
  [oxidation]
    type = SimpleOxidation
    variable = C_ox
#    rate = 1 #Reaction Rate
#    D = 1    #Diffusion Cofefficient
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
    grain_boundary_normal_stress = grainBoundaryNormalStress
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
