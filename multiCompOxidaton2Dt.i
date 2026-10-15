
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
  [./C_Fe]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.70
  [../]
  [./C_Cr]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.25
  [../]
  [./C_Si]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.05
  [../]
  [./C_Cr2O3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_Fe3O4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_SiO2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_FeCr2O4]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_Cr2O3_form]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_Fe3O4_form]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_SiO2_form]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_FeCr2O4_form]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_Fe_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_Cr_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_Si_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_Fe_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_Cr_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_Si_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./R_Cr2O3_form]
    type = MaterialRealAux
    variable = R_Cr2O3_form
    property = "form_rate_Cr2O3"
  [../]
  [./R_Fe3O4_form]
    type = MaterialRealAux
    variable = R_Fe3O4_form
    property = "form_rate_Fe3O4"
  [../]
  [./R_SiO2_form]
    type = MaterialRealAux
    variable = R_SiO2_form
    property = "form_rate_SiO2"
  [../]
  [./R_FeCr2O4_form]
    type = MaterialRealAux
    variable = R_FeCr2O4_form
    property = "form_rate_FeCr2O4"
  [../]
  [./R_Fe_consume]
    type = MaterialRealAux
    variable = R_Fe_consume
    property = "consump_rate_Fe"
  [../]
  [./R_Cr_consume]
    type = MaterialRealAux
    variable = R_Cr_consume
    property = "consump_rate_Cr"
  [../]
  [./R_Si_consume]
    type = MaterialRealAux
    variable = R_Si_consume
    property = "consump_rate_Si"
  [../]
  [./C_Cr2O3_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_Cr2O3_form
    variable = C_Cr2O3
  [../]
  [./C_Fe3O4_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_Fe3O4_form
    variable = C_Fe3O4
  [../]
  [./C_SiO2_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_SiO2_form
    variable = C_SiO2
  [../]
  [./C_FeCr2O4_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_FeCr2O4_form
    variable = C_FeCr2O4
  [../]
  [./C_Fe_consume]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_Fe_consume
    variable = C_Fe_consume
  [../]
  [./C_Cr_consume]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_Cr_consume
    variable = C_Cr_consume
  [../]
  [./C_Si_consume]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_Si_consume
    variable = C_Si_consume
  [../]
  [./C_Fe_update]
    type = ParsedAux
    variable = C_Fe
    coupled_variables = 'C_Fe C_Fe_consume'
    expression = 'C_Fe - C_Fe_consume'
  [../]
  [./C_Cr_update]
    type = ParsedAux
    variable = C_Cr
    coupled_variables = 'C_Cr C_Cr_consume'
    expression = 'C_Cr - C_Cr_consume'
  [../]
  [./C_Si_update]
    type = ParsedAux
    variable = C_Si
    coupled_variables = 'C_Si C_Si_consume'
    expression = 'C_Si - C_Si_consume'
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
    value = 0.1
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
#  [sym_bc]
#    type = NeumannBC
#    variable = C_ox
#    boundary = 'top bottom'
#    value = 0 
#  []
[]

[Materials]
  [oxidation_rates]
    type = multiCompOxidationRates
    rate_coef_Cr2O3 = 1.0
    rate_coef_Fe3O4 = 1.0
    rate_coef_SiO2 = 1.0
    rate_coef_FeCr2O4 = 1.0
    O_concentration = C_ox
    Fe_concentration = C_Fe
    Cr_concentration = C_Cr
    Si_concentration = C_Si
  []
[]

[Postprocessors]
  [C_Cr2O3_avg]
    type = ElementAverageValue  
    variable = C_Cr2O3
    execute_on = initial
  []
  [C_Fe3O4_avg]
    type = ElementAverageValue  
    variable = C_Fe3O4
    execute_on = 'initial'
  []
  [C_SiO2_avg]
    type = ElementAverageValue  
    variable = C_SiO2
    execute_on = 'initial'
  []
  [C_FeCr2O4_avg]
    type = ElementAverageValue  
    variable = C_FeCr2O4
    execute_on = 'initial'
  []
  [eff_diff_coef]
    type = ParsedPostprocessor
    expression = '(D_Cr2O3 * C_Cr2O3_avg + D_Fe3O4 * C_Fe3O4_avg + D_SiO2 * C_SiO2_avg + D_FeCr2O4 * C_FeCr2O4_avg) / (C_Cr2O3_avg + C_Fe3O4_avg + C_SiO2_avg + C_FeCr2O4_avg)'
    pp_names = 'C_Cr2O3_avg C_Fe3O4_avg C_SiO2_avg C_FeCr2O4_avg'
    constant_names = 'D_Cr2O3 D_Fe3O4 D_SiO2 D_FeCr2O4'
    constant_expressions = '1E-2 1E-2 1E-2 1E-2'
    execute_on = 'initial'
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
