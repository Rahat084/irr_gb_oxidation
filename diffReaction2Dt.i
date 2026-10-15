# Global Params
Diff_coef = 1
Reac_rate = 1

[Mesh]
  [rectangle]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 40
    ny = 80
    #elem_type = Quad
    xmax = 7E-2
    xmin = 0
    ymax = 1E-3
    ymin = 0 
  []
[]

[AuxVariables]
  [./grainBoundaryNormalStress]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./grainBoundaryStress]
    type = ConstantAux
    variable = grainBoundaryNormalStress
    value = 0.0
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
  [gb_diff]
    type = Diffusion
    variable = C_ox
  []
#  [oxidation]
#    type = CoefReaction
#    variable = C_ox
#    Diffusion_coefficient = '${Diff_coef}'
#    Reaction_rate = '${Reac_rate}'
#  []
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
    boundary = 'left'
    value = 72.47
  []
# [sinks]
#   type = DiffusionFluxBC
#   variable = C_ox
#   boundary = 'right'
# []
  [sinks]
    type = gbDiffusionFluxBC
    variable = C_ox
    grain_boundary_normal_stress = grainBoundaryNormalStress
    boundary = 'right'
  []
  [sym_bc]
    type = NeumannBC
    variable = C_ox
    boundary = 'top bottom'
    value = 0 
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
