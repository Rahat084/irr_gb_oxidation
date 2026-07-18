[GlobalParams]
  Diffusion_coefficient = 1
  Reaction_rate = 6.1802E8
[]

[Mesh]
  [rectangle]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 100
    elem_type = EDGE2
    xmax = 5E-4
    xmin = 0
  []
[]

[AuxVariables]
  [./grainBoundaryNormalStress]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Variables]
  [C_ox]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [gb_diff]
    type = Diffusion
    variable = C_ox
  []
#  [oxidation]
#    type = CoefReaction
#    variable = C_ox
#    coefficient = 6.1802E8
#  []
  [oxidation]
    type = SimpleOxidation
    variable = C_ox
#    Diffusion_coefficient = 1
#    Reaction_rate = 1
  []
[]

[BCs]
  [sources]
    type = DirichletBC
    variable = C_ox
    boundary = 'left'
    value = 72.47
  []
  [sinks]
    type = gbDiffusionFluxBC
    variable = C_ox
    grain_boundary_normal_stress = grainBoundaryNormalStress
    boundary = 'right'
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
