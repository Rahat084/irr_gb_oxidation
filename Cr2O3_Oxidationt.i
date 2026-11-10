# General Parameters 
D_Cr_Cr2O3 =5E-12
D_O_Cr2O3 = 2E-6
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
  [./C_Cr]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.2
  [../]
  [./C_Cr2O3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_Cr2O3_form]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_Cr_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_Cr_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./R_Cr2O3_form]
    type = ADMaterialRealAux
    variable = R_Cr2O3_form
    property = "form_rate_Cr2O3"
  [../]
  [./R_Cr_consume]
    type = ADMaterialRealAux
    variable = R_Cr_consume
    property = "consump_rate_Cr"
  [../]
  [./C_Cr2O3_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_Cr2O3_form
    variable = C_Cr2O3
  [../]
  [./C_Cr_consume]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_Cr_consume
    variable = C_Cr_consume
  [../]
  [./C_Cr_update]
    type = ParsedAux
    variable = C_Cr
    coupled_variables = 'C_Cr C_Cr_consume'
    expression = 'if(C_Cr - C_Cr_consume > 0.0, C_Cr - C_Cr_consume, 0.0)'
  [../]
[]

[Variables]
  [C_ox]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  []
[]

[Kernels]
  [C_Ox_dot]
    type = ADTimeDerivative
    variable = C_ox
  []
  [C_Ox_diffuse]
    type = ADOxyDiffusion
    variable = C_ox
    eff_diff_coef_pp = eff_diff_coef
  []
  [C_ox_consumption]
    type = ADMatBodyForce
    variable = C_ox
    material_property = 'consump_rate_O'
  []
[]

[ICs]
  [C_Cr2O3_initial]
    type = ConstantIC
    variable = C_Cr2O3
    value = 0.000001
  []
[]

[BCs]
  [O_Source]
    type = DirichletBC
    variable = C_ox
    boundary = 'left'
    value = 1
  []
 [O_Sink]
   type = DiffusionFluxBC
   variable = C_ox
   boundary = 'right'
 []
  [sym_bc]
    type = NeumannBC
    variable = C_ox
    boundary = 'top bottom'
    value = 0 
  []
[]

[Materials]
  [oxidation_rates]
    type = multiCompOxidationRates
    oxide_phases = 'Cr2O3'
    oxidation_rate_coeffs = '${fparse (1.5 * D_Cr_Cr2O3 + D_O_Cr2O3) * 49.32}'
    oxide_elements = 'O Cr'
    stoichometric_coeffs = '3.0 2.0' 
    element_concs = 'C_ox C_Cr'
  []
[]

[Postprocessors]
  [C_Cr2O3_avg]
    type = ElementAverageValue  
    variable = C_Cr2O3
  []
  [eff_diff_coef]
    type = ParsedPostprocessor
    #expression = '(D_Cr2O3 * C_Cr2O3 + D_Fe3O4 * C_Fe3O4 + D_SiO2 * C_SiO2 + D_FeCr2O4 * C_FeCr2O4) / (C_Cr2O3 + C_Fe3O4 + C_SiO2 + C_FeCr2O4)'
    expression = '(D_Cr2O3 * C_Cr2O3 ) / (C_Cr2O3 )'
    pp_names = 'C_Cr2O3_avg'
    pp_symbols = 'C_Cr2O3'
    constant_names = 'D_Cr2O3'
    constant_expressions = '2E-6'
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
