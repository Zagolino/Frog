#include "FrogApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
FrogApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

FrogApp::FrogApp(InputParameters parameters) : MooseApp(parameters)
{
  FrogApp::registerAll(_factory, _action_factory, _syntax);
}

FrogApp::~FrogApp() {}

void
FrogApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<FrogApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"FrogApp"});
  Registry::registerActionsTo(af, {"FrogApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
FrogApp::registerApps()
{
  registerApp(FrogApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
FrogApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  FrogApp::registerAll(f, af, s);
}
extern "C" void
FrogApp__registerApps()
{
  FrogApp::registerApps();
}
