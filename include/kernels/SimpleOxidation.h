//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Reaction.h"

/**
 *  Implements a simple consuming reaction term with weak form $(\\psi_i, \\lambda u_h)$.
 */

class SimpleOxidation : public Reaction
{
public:
  static InputParameters validParams();

  SimpleOxidation(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;

  /// Scalar coefficient representing the relative amount consumed per unit time
  const Real & _rate;
  const Real & _D;
  Real _coeff;

};

