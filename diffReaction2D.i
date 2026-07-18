[GlobalParams]
  Diffusion_coefficient = 1
  Reaction_rate = 1
[]

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
  [gb_diff]
    type = Diffusion
    variable = C_ox
  []
#  [oxidation]
#    type = CoefReaction
#    variable = C_ox
#    #coefficient = 6.1802E8 # -1
#    coefficient = 1.89E4 # -1
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
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
