//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "irr_gb_oxidationTestApp.h"
#include "irr_gb_oxidationApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
irr_gb_oxidationTestApp::validParams()
{
  InputParameters params = irr_gb_oxidationApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

irr_gb_oxidationTestApp::irr_gb_oxidationTestApp(const InputParameters & parameters) : MooseApp(parameters)
{
  irr_gb_oxidationTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

irr_gb_oxidationTestApp::~irr_gb_oxidationTestApp() {}

void
irr_gb_oxidationTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  irr_gb_oxidationApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"irr_gb_oxidationTestApp"});
    Registry::registerActionsTo(af, {"irr_gb_oxidationTestApp"});
  }
}

void
irr_gb_oxidationTestApp::registerApps()
{
  registerApp(irr_gb_oxidationApp);
  registerApp(irr_gb_oxidationTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
irr_gb_oxidationTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  irr_gb_oxidationTestApp::registerAll(f, af, s);
}
extern "C" void
irr_gb_oxidationTestApp__registerApps()
{
  irr_gb_oxidationTestApp::registerApps();
}
