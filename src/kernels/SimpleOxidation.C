//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "SimpleOxidation.h"

registerMooseObject("irr_gb_oxidationApp", SimpleOxidation);

InputParameters
SimpleOxidation::validParams()
{
  InputParameters params = Reaction::validParams();
  params.addClassDescription(
      "Implements a simple consuming reaction term with weak form $(\\psi_i, \\lambda u_h^2)$.");
  params.addParam<Real>(
      "Reaction_rate", 1.0, "The $(\\lambda)$ multiplier, the relative amount consumed per unit time.");
  params.declareControllable("Reaction_rate");
  params.addParam<Real>(
      "Diffusion_coefficient", 1.0, "The Diffiusion Coefficient of Oxygen in SI unit ");
  return params;
}

SimpleOxidation::SimpleOxidation(const InputParameters & parameters)
  : Reaction(parameters), 
    _rate(getParam<Real>("Reaction_rate")),
    _D(getParam<Real>("Diffusion_coefficient")),
    _coeff(0.0)
{
    _coeff = _rate/_D;
}

Real
SimpleOxidation::computeQpResidual()
{
  return _test[_i][_qp] * _coeff * _u[_qp] * _u[_qp];
}

Real
SimpleOxidation::computeQpJacobian()
{
  return _test[_i][_qp] * _coeff * 2 * _u[_qp] * _phi[_j][_qp];
}

