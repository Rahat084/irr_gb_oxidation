//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Material.h"

class multiCompOxidationRates : public Material
{
public:
  multiCompOxidationRates(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual void computeQpProperties() override;
  void computeQpOxideFormationRates();
  void computeQpElementConsumptionRates();

private:
  /// Reaction rate coefficients
  const Real _k_Cr2O3;
  const Real _k_Fe3O4;
  const Real _k_SiO2;
  const Real _k_FeCr2O4;
/// Coupled field variables
  const VariableValue _C_O;
  VariableValue _C_Fe;
  VariableValue _C_Cr;
  VariableValue _C_Si;
  /// Oxid Formation rate properties
  MaterialProperty<Real> & _R_Cr2O3;
  MaterialProperty<Real> & _R_Fe3O4;
  MaterialProperty<Real> & _R_SiO2;
  MaterialProperty<Real> & _R_FeCr2O4;
  /// Element consumption rate properties
  MaterialProperty<Real> & _R_O;
  MaterialProperty<Real> & _R_Fe;
  MaterialProperty<Real> & _R_Cr;
  MaterialProperty<Real> & _R_Si;
 
};
