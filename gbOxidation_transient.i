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
  [cdot]
    type = CoefTimeDerivative
    variable = C_ox
    Coefficient = -1
  []
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

# Transient (time-dependent) details for simulations go here:
[Executioner]
  type = Transient   # Here we use the Transient Executioner (instead of steady)
  solve_type = 'PJFNK'
  num_steps = 75 # Run for 75 time steps, solving the system each step.
  dt = 1E-6 # each time step will have duration "1"
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
