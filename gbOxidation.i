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
    vector_value = '1.5e-3 1.5e-3 1.5e-3'
  []
[]

#[UserObjects]
#  [./soln]
#    type = SolutionUserObject
#    mesh = irrFCC_poly_5dpa.e
#    system_variables = stress_hydro
#    timestep = 2500
#  [../]
#[]
#
#[AuxVariables]
#  [./grainBoundaryNormalStress]
#    order = FIRST
#    family = LAGRANGE
#  [../]
#[]
#
#[AuxKernels]
#  [./grainBoundaryStress]
#    type = SolutionAux
#    solution = soln
#    variable = grainBoundaryStress
#  [../]
#[]

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
#  [drift]
#    type = GrainBoundaryDrift
#    variable = C_ox
#    #Vatom = 9.9E-30
#    #T = 300
#    
#  []
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
#  [sinks]
#    type = gbDiffusionFluxBC
#    variable = C_ox
#    boundary = 'sink'
#  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
