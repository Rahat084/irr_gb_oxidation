//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "gbDiffusionFluxBC.h"

registerMooseObject("irr_gb_oxidationApp", gbDiffusionFluxBC);

InputParameters
gbDiffusionFluxBC::validParams()
{
  InputParameters params = FluxBC::validParams();
  params.addClassDescription(
      "Computes a boundary residual contribution consistent with the Diffusion Kernel. "
      "Does not impose a boundary condition; instead computes the boundary "
      "contribution corresponding to the current value of grad(u) and accumulates "
      "it in the residual vector.");
  params.addRequiredParam<Real>("Vatom",9.9E-30, "Volume per atom in m3");
  params.addRequiredParam<Real>("T",300, "Temperature");
  params.addRequiredParam<Real>("k",1.380649E-23, "Boltzmann Constant m2kgs-2K-1");
  return params;
}

gbDiffusionFluxBC::gbDiffusionFluxBC(const InputParameters & parameters) : 
    FluxBC(parameters), 
    _coeff(0.0),
    _Vatom(getParam<Real>("Vatom")),
    _k(getParam<Real>("k")),
    _T(getParam<Real>("T")),
    _gbNormalStress(coupledValue("grain_boundary_normal_stress")),
    _gbNormalStressGradient(coupledGradient("grain_boundary_normal_stress"))
{
    _coeff = _Vatom / (_k * _T);
}

RealGradient
gbDiffusionFluxBC::computeQpFluxResidual()
{
  return  -_grad_u[_qp] + _coeff * _u[_qp] * _gbNormalStressGradient[_qp];
}

RealGradient
gbDiffusionFluxBC::computeQpFluxJacobian()
{
  return -_grad_phi[_j][_qp] + _coeff * _phi[_j][_qp] * _gbNormalStressGradient[_qp];
}
