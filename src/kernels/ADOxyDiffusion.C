//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADOxyDiffusion.h"

registerMooseObject("MooseApp", ADOxyDiffusion);

InputParameters
ADOxyDiffusion::validParams()
{
  auto params = ADKernelGrad::validParams();
  params.addClassDescription("Same as `Diffusion` in terms of physics/residual, but the Jacobian "
                             "is computed using forward automatic differentiation");
  params.addParam<PostprocessorName>("eff_diff_coef_pp", "effective diffusivity based on effective-medium mixture of oxide phases");
  return params;
}

ADOxyDiffusion::ADOxyDiffusion(const InputParameters & parameters) : ADKernelGrad(parameters),  
        _diff_coef(getPostprocessorValue("eff_diff_coef_pp"))
{}

ADRealVectorValue
ADOxyDiffusion::precomputeQpResidual()
{
  return _diff_coef * _grad_u[_qp];
}
