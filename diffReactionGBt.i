[GlobalParams]
  Diffusion_coefficient = 1
  Reaction_rate = 1
[]

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
#    Diffusion_coefficient = 1
  []
  [diff]
    type = Diffusion
    variable = C_ox
#    Diffusion_coefficient = 1
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
#    Diffusion_coefficient = 1
#    Reaction_rate = 1
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
