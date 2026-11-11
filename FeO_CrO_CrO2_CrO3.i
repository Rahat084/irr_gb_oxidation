
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
    initial_condition = 0.7083
  [../]
  [./C_Cr]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.2
  [../]
  [./C_FeO]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_CrO]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_CrO2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_CrO3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_FeO_form]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_CrO_form]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_CrO2_form]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./R_CrO3_form]
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
  [./C_Fe_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./C_Cr_consume]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./R_FeO_form]
    type = ADMaterialRealAux
    variable = R_FeO_form
    property = "form_rate_FeO"
  [../]
  [./R_CrO_form]
    type = ADMaterialRealAux
    variable = R_CrO_form
    property = "form_rate_CrO"
  [../]
  [./R_CrO2_form]
    type = ADMaterialRealAux
    variable = R_CrO3_form
    property = "form_rate_CrO3"
  [../]
  [./R_CrO3_form]
    type = ADMaterialRealAux
    variable = R_CrO2_form
    property = "form_rate_CrO2"
  [../]
  [./R_Fe_consume]
    type = ADMaterialRealAux
    variable = R_Fe_consume
    property = "consump_rate_Fe"
  [../]
  [./R_Cr_consume]
    type = ADMaterialRealAux
    variable = R_Cr_consume
    property = "consump_rate_Cr"
  [../]
  [./C_FeO_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_FeO_form
    variable = C_FeO
  [../]
  [./C_CrO_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_CrO_form
    variable = C_CrO
  [../]
  [./C_CrO2_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_CrO3_form
    variable = C_CrO3
  [../]
  [./C_CrO3_form]
    type = VariableTimeIntegrationAux
    variable_to_integrate = R_CrO2_form
    variable = C_CrO2
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
  [./C_Fe_update]
    type = ParsedAux
    variable = C_Fe
    coupled_variables = 'C_Fe C_Fe_consume'
    expression = 'if(C_Fe - C_Fe_consume > 0.0, C_Fe - C_Fe_consume, 0.0)'
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
  [C_CrO_initial]
    type = ConstantIC
    variable = C_CrO
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
    oxide_phases = 'FeO CrO CrO2 CrO3'
    oxidation_rate_coeffs = '6E-4 8E-5 4E-5 7E-6'
    oxide_elements = 'O Fe Cr'
    stoichometric_coeffs = '1.0 1.0 0.0; 1.0 0.0 1.0; 2.0 0.0 1.0; 3.0 0.0 1.0' 
    element_concs = 'C_ox C_Fe C_Cr'
  []
[]

[Postprocessors]
  [C_FeO_avg]
    type = ElementAverageValue  
    variable = C_FeO
  []
  [C_CrO_avg]
    type = ElementAverageValue  
    variable = C_CrO
  []
  [C_CrO3_avg]
    type = ElementAverageValue  
    variable = C_CrO3
  []
  [C_CrO2_avg]
    type = ElementAverageValue  
    variable = C_CrO2
  []
  [eff_diff_coef]
    type = ParsedPostprocessor
    expression = '(D_FeO * C_FeO + D_CrO * C_CrO + D_CrO3 * C_CrO3 + D_CrO2 * C_CrO2) / (C_FeO + C_CrO + C_CrO3 + C_CrO2)'
    pp_names = 'C_FeO_avg C_CrO_avg C_CrO3_avg C_CrO2_avg'
    pp_symbols = 'C_FeO C_CrO C_CrO3 C_CrO2'
    constant_names = 'D_FeO D_CrO D_CrO3 D_CrO2'
    constant_expressions = '2E-6 5E-4 5E-2 4.0E-3'
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
