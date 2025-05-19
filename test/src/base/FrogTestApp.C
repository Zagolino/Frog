//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "FrogTestApp.h"
#include "FrogApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
FrogTestApp::validParams()
{
  InputParameters params = FrogApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

FrogTestApp::FrogTestApp(InputParameters parameters) : MooseApp(parameters)
{
  FrogTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

FrogTestApp::~FrogTestApp() {}

void
FrogTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  FrogApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"FrogTestApp"});
    Registry::registerActionsTo(af, {"FrogTestApp"});
  }
}

void
FrogTestApp::registerApps()
{
  registerApp(FrogApp);
  registerApp(FrogTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
FrogTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  FrogTestApp::registerAll(f, af, s);
}
extern "C" void
FrogTestApp__registerApps()
{
  FrogTestApp::registerApps();
}
