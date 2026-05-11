//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "GrainBoundaryDrift.h"

/**
 * All MOOSE based object classes you create must be registered using this macro.  The first
 * argument is the name of the App you entered in when running the stork.sh script with an "App"
 * suffix. If you ran "stork.sh Example", then the argument here becomes "ExampleApp". The second
 * argument is the name of the C++ class you created.
 */
registerMooseObject("irr_gb_oxidationApp", GrainBoundaryDrift);

/**
 * This function defines the valid parameters for
 * this Kernel and their default values
 */
InputParameters
GrainBoundaryDrift::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addParam<Real>("Vatom",9.9E-30, "Volume per atom in m3");
  params.addParam<Real>("T",300 , "Temperature");
  params.addParam<Real>("k",1.380649E-23, "Boltzmann Constant m2kgs-2K-1");
  params.addRequiredCoupledVar("grain_boundary_normal_stress", "Normal Component of the grain boundary Stress");
  return params;
}

GrainBoundaryDrift::GrainBoundaryDrift(const InputParameters & parameters)
  : // You must call the constructor of the base class first
    Kernel(parameters),
    _coeff(0.0),
    _Vatom(getParam<Real>("Vatom")),
    _k(getParam<Real>("k")),
    _T(getParam<Real>("T")),
    _gbNormalStress(coupledValue("grain_boundary_normal_stress")),
    _gbNormalStressGradient(coupledGradient("grain_boundary_normal_stress"))
{
    _coeff = _Vatom /(_k *_T);
}

Real
GrainBoundaryDrift::computeQpResidual()
{
  // velocity * _grad_u[_qp] is actually doing a dot product
  return _coeff * (_u[_qp] * (_gbNormalStressGradient[_qp] * _grad_test[_i][_qp]));
}

Real
GrainBoundaryDrift::computeQpJacobian()
{
  // the partial derivative of _grad_u is just _grad_phi[_j]
  return _coeff * (_phi[_j][_qp] * (_gbNormalStressGradient[_qp] * _grad_test[_i][_qp]));
}
