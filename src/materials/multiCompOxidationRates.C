//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "multiCompOxidationRates.h"

registerMooseObject("irr_gb_oxidationApp", multiCompOxidationRates);

InputParameters
multiCompOxidationRates::validParams()
{
  InputParameters params = Material::validParams();

  // Allow users to specify vectors defining the points of a piecewise function formed via linear
  // interpolation.
  params.addRequiredParam<std::vector<std::string>>(
      "oxide_phases",
      "Name of the oxide phases");
  params.addRequiredParam<std::vector<Real>>(
      "oxidation_rate_coeffs",  "Reaction rate coefficeint of the phases");
  params.addRequiredParam<std::vector<std::string>>(
      "oxide_elements",  "Consitutent elements in oxide phases");
  params.addRequiredParam<std::vector<std::vector<Real>>>(
      "stoichometric_coeffs",  "Stoicometric coefficients of each elements in the oxide phases");

  // Allow the user to specify which independent variable's gradient to use for calculating the
  // convection velocity property:
  /*
  params.addCoupledVar(
      "diffusion_gradient",
      "The gradient of this variable will be used to compute a velocity vector property.");
*/
  /*
  params.addRequiredCoupledVar(
      "O_concentration",
      "local concentration of oxygen");
      */
  params.addRequiredCoupledVar(
      "element_concs",
      "local concentration of the elements");
  params.addParam<bool>("reaction_order", false, "Enable reaction order consideration to calculate rate of oxide formation");
  return params;
}

multiCompOxidationRates::multiCompOxidationRates(const InputParameters & parameters)
  : Material(parameters),
    // Declare that this material is going to provide a Real value typed
    // material property named "diffusivity" that Kernels and other objects can use.
    // This property is "bound" to the class's "_diffusivity" member.
    _oxide_phases(getParam<std::vector<std::string>>("oxide_phases")),
    // Reaction Rate Coefficients
    _oxidation_rate_coeffs(getParam<std::vector<Real>>("oxidation_rate_coeffs")),
    _oxide_elements(getParam<std::vector<std::string>>("oxide_elements")),
    _stoichometric_coeffs(getParam<std::vector<std::vector<Real>>>("stoichometric_coeffs")),
    // Coupled Variables 
    _C_elements(coupledValues("element_concs")),
    _reac_order(getParam<bool>("reaction_order"))
    // Formation rate of Oxides
    /*
    _R_Cr2O3(declareProperty<Real>("form_rate_Cr2O3")),
    _R_Fe3O4(declareProperty<Real>("form_rate_Fe3O4")),
    _R_SiO2(declareProperty<Real>("form_rate_SiO2")),
    _R_FeCr2O4(declareProperty<Real>("form_rate_FeCr2O4")),
    // Consumption rates of elements
    _R_O(declareADProperty<Real>("consump_rate_O")),
    _R_Fe(declareProperty<Real>("consump_rate_Fe")),
    _R_Cr(declareProperty<Real>("consump_rate_Cr")),
    _R_Si(declareProperty<Real>("consump_rate_Si"))
    */

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
      for (const auto & name : _oxide_phases)
    _form_rate_oxides.push_back(&declareADProperty<Real>("form_rate_" + name));

      for (const auto & name : _oxide_elements)
    _consump_rate_elements.push_back(&declareADProperty<Real>("consump_rate_" + name));

      if (_stoichometric_coeffs.size() != _oxide_phases.size() || _stoichometric_coeffs[0].size() != _oxide_elements.size())
	  paramError(" Size mismatch of the stochometric coefficients");
}

void
multiCompOxidationRates::computeQpOxideFormationRates()
{
    /*
_R_Cr2O3[_qp] = _k_Cr2O3 * _C_Cr[_qp] * _C_O[_qp];
_R_Fe3O4[_qp] = _k_Fe3O4 * _C_Fe[_qp] * _C_O[_qp];
_R_SiO2[_qp] = _k_SiO2 * _C_Si[_qp] * _C_O[_qp];
_R_FeCr2O4[_qp] = _k_FeCr2O4 * _C_Fe[_qp] * _C_Cr[_qp] * _C_O[_qp];
*/
    for  (const auto i : make_range(_oxide_phases.size()))
	    {
    (*_form_rate_oxides[i])[_qp] = _oxidation_rate_coeffs[i];

	for  (const auto j : make_range(_oxide_elements.size()))
	    {
	if (_reac_order == true)
		(*_form_rate_oxides[i])[_qp] *= std::pow((*_C_elements[j])[_qp], _stoichometric_coeffs[i][j]) ;

	else
	{ //No Reaction Order
	    if ( _stoichometric_coeffs[i][j] > 0.0)
		(*_form_rate_oxides[i])[_qp] *= (*_C_elements[j])[_qp];
	    }
	    }
	    }

}

void
multiCompOxidationRates::computeQpElementConsumptionRates()
{
/*
    _R_O[_qp] = 3.0 * _R_Cr2O3[_qp] + 4.0 * _R_Fe3O4[_qp] + 2.0 * _R_SiO2[_qp] + 4.0 * _R_FeCr2O4[_qp]; 
    _R_Cr[_qp] = 2.0 * _R_Cr2O3[_qp] + 2.0 * _R_FeCr2O4[_qp]; 
    _R_Fe[_qp] = 3.0 * _R_Fe3O4[_qp] + _R_FeCr2O4[_qp];
    _R_Si[_qp] = _R_SiO2[_qp];  
    */
for (const auto i : make_range(_oxide_elements.size()))
{
    (*_consump_rate_elements[i])[_qp] = 0.0;
for (const auto j : make_range(_oxide_phases.size()))
    (*_consump_rate_elements[i])[_qp] += _stoichometric_coeffs[j][i] * (*_form_rate_oxides[j])[_qp];
}

}

void
multiCompOxidationRates::computeQpProperties()
{
    computeQpOxideFormationRates();
    computeQpElementConsumptionRates();
}
