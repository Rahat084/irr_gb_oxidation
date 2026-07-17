//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "DiffTimeDerivative.h"

registerMooseObject("MooseApp", DiffTimeDerivative);

InputParameters
DiffTimeDerivative::validParams()
{
  InputParameters params = TimeDerivative::validParams();
  params.addParam<Real>("Diffusion_coefficient", 1, "The coefficient for the time derivative kernel");
  return params;
}

DiffTimeDerivative::DiffTimeDerivative(const InputParameters & parameters)
  : TimeDerivative(parameters), _diffCoef(getParam<Real>("Diffusion_coefficient")), _coef(0.0)
{
    _coef = 1/_diffCoef;
}

Real
DiffTimeDerivative::computeQpResidual()
{
  return _coef * TimeDerivative::computeQpResidual();
}

Real
DiffTimeDerivative::computeQpJacobian()
{
  return _coef * TimeDerivative::computeQpJacobian();
}
