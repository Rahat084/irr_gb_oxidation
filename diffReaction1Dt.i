[GlobalParams]
  Diffusion_coefficient = 1
  Reaction_rate = 1
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
  [timeDerive]
    type = DiffTimeDerivative
    variable = C_ox
#    Diffusion_coefficient = 1
  []
  [gb_diff]
    type = Diffusion
    variable = C_ox
  []
  [oxidation]
    type = CoefReaction
    variable = C_ox
    coefficient = 1
#  []
#  [oxidation]
#    type = SimpleOxidation
#    variable = C_ox
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
