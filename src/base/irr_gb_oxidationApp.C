#include "irr_gb_oxidationApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
irr_gb_oxidationApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

irr_gb_oxidationApp::irr_gb_oxidationApp(const InputParameters & parameters) : MooseApp(parameters)
{
  irr_gb_oxidationApp::registerAll(_factory, _action_factory, _syntax);
}

irr_gb_oxidationApp::~irr_gb_oxidationApp() {}

void
irr_gb_oxidationApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<irr_gb_oxidationApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"irr_gb_oxidationApp"});
  Registry::registerActionsTo(af, {"irr_gb_oxidationApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
irr_gb_oxidationApp::registerApps()
{
  registerApp(irr_gb_oxidationApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
irr_gb_oxidationApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  irr_gb_oxidationApp::registerAll(f, af, s);
}
extern "C" void
irr_gb_oxidationApp__registerApps()
{
  irr_gb_oxidationApp::registerApps();
}
