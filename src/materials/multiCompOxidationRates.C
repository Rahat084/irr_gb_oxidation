//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "multiCompOxidationRates.h"

registerMooseObject("ExampleApp", multiCompOxidationRates);

InputParameters
multiCompOxidationRates::validParams()
{
  InputParameters params = Material::validParams();

  // Allow users to specify vectors defining the points of a piecewise function formed via linear
  // interpolation.
  params.addRequiredParam<Real>(
      "rate_coef_Cr2O3",
      "Reaction Rate Coefficient of Cr2O3");
  params.addRequiredParam<Real>(
      "rate_coef_Fe3O4",
      "Reaction Rate Coefficient of Fe3O4");
  params.addRequiredParam<Real>(
      "rate_coef_SiO2",
      "Reaction Rate Coefficient of SiO2");
  params.addRequiredParam<Real>(
      "rate_coef_FeCr2O4",
      "Reaction Rate Coefficient of FeCr2O4");

  // Allow the user to specify which independent variable's gradient to use for calculating the
  // convection velocity property:
  /*
  params.addCoupledVar(
      "diffusion_gradient",
      "The gradient of this variable will be used to compute a velocity vector property.");
*/
  params.addCoupledVar(
      "O_concentration",
      "local concentration of oxygen");
  params.addCoupledVar(
      "Fe_concentration",
      "local concentration of Fe");
  params.addCoupledVar(
      "Cr_concentration",
      "local concentration of Cr");
  params.addCoupledVar(
      "Si_concentration",
      "local concentration of Si");
  return params;
}

multiCompOxidationRates::multiCompOxidationRates(const InputParameters & parameters)
  : Material(parameters),
    // Declare that this material is going to provide a Real value typed
    // material property named "diffusivity" that Kernels and other objects can use.
    // This property is "bound" to the class's "_diffusivity" member.
    // Reaction Rate Coefficients
    _k_Cr2O3(getParam<Real>("rate_coef_Cr2O3")),
    _k_Fe3O4(getParam<Real>("rate_coef_Fe3O4")),
    _k_SiO2(getParam<Real>("rate_coef_SiO2")),
    _k_FeCr2O4(getParam<Real>("rate_coef_FeCr2O4")),
    // Coupled Variables 
    _C_O(coupledValue("O_concentration")),
    _C_Fe(coupledValue("Fe_concentration")),
    _C_Cr(coupledValue("Cr_concentration")),
    _C_Si(coupledValue("Si_concentration")),
    // Formation rate of Oxides
    _R_Cr2O3(declareProperty<Real>("form_rate_Cr2O3")),
    _R_Fe3O4(declareProperty<Real>("form_rate_Fe3O4")),
    _R_SiO2(declareProperty<Real>("form_rate_SiO2")),
    _R_FeCr2O4(declareProperty<Real>("form_rate_FeCr2O4")),
    // Consumption rates of elements
    _R_O(declareProperty<Real>("consump_rate_O")),
    _R_Fe(declareProperty<Real>("consump_rate_Fe")),
    _R_Cr(declareProperty<Real>("consump_rate_Cr")),
    _R_Si(declareProperty<Real>("consump_rate_Si"))

    // Also declare a second "convection_velocity" RealGradient value typed property.
    //_convection_velocity(declareProperty<RealGradient>("convection_velocity")),

    // Get the reference to the variable coupled into this Material.
    /*_diffusion_gradient(isCoupled("diffusion_gradient") ? coupledGradient("diffusion_gradient")
                                                        : _grad_zero),
*/
    // Initialize our piecewise function helper with the user-specified interpolation points.
    /*_piecewise_func(getParam<std::vector<Real>>("independent_vals"),
                    getParam<std::vector<Real>>("dependent_vals"))
    */
{
}

void
multiCompOxidationRates::computeQpOxideFormationRates()
{
_R_Cr2O3[_qp] = _k_Cr2O3 * std::pow(_C_Cr[_qp], 2) * std::pow(_C_O[_qp], 1.5);
_R_Fe3O4[_qp] = _k_Fe3O4 * std::pow(_C_Fe[_qp], 3) * std::pow(_C_O[_qp], 2);
_R_SiO2[_qp] = _k_SiO2 * _C_Si[_qp] * _C_O[_qp];
_R_FeCr2O4[_qp] = _k_FeCr2O4 * std::pow(_C_Fe[_qp], 1) *  std::pow(_C_Cr[_qp], 2) * std::pow(_C_O[_qp], 4);
}

void
multiCompOxidationRates::computeQpElementConsumptionRates()
{
    _R_O[_qp] = 1.5 * _R_Cr2O3[_qp] + 2 * _R_Fe3O4[_qp] + _R_SiO2[_qp] + 4 * _R_FeCr2O4[_qp]; 
    _R_Cr[_qp] = 2 * _R_Cr2O3[_qp] + 2 * _R_FeCr2O4[_qp]; 
   _C_Cr[_qp] -= _R_Cr[_qp] * _dt; 
    _R_Fe[_qp] = 3 * _R_Fe3O4[_qp] + _R_FeCr2O4[_qp];
   _C_Fe[_qp] -= _R_Fe[_qp] * _dt; 
    _R_Si[_qp] = _R_SiO2[_qp];  
   _C_Si[_qp] -= _R_Si[_qp] * _dt; 

}

void
multiCompOxidationRates::computeQpProperties()
{
    computeQpOxideFormationRates();
    computeQpElementConsumptionRates();
}
