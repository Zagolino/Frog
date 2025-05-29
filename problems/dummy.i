[Modules]
  [NavierStokesFV]
    compressibility = 'incompressible'
    add_energy_equation = false
    viscosity = 'mu'
    density = 'rho'
    pin_pressure = true  # Required for incompressible flow
    momentum_advection_interpolation = 'upwind'
    pressure_variable = 'pressure'
  []
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  xmin = 0
  xmax = 0.6
  ymin = 0
  ymax = 0.076
  zmin = 0
  zmax = 0.08
  nx = 30
  ny = 8
  nz = 8
[]

[Variables]
  [velocity]
    family = LAGRANGE_VEC
    order = FIRST
    initial_condition = 1e-6  # Small initial value
  []
  [pressure]
    family = LAGRANGE
    order = FIRST
    initial_condition = 0
  []
[]

[AuxVariables]
  [vel_mag]
    type = MooseVariableFVReal
  []
[]

[FluidProperties]
  [water]
    type = SimpleFluidProperties
    density = 1000    # kg/m³
    viscosity = 8.9e-4  # Pa·s at 25°C
  []
[]

[Materials]
  [constants]
    type = ADGenericConstantMaterial
    prop_names = 'rho mu'
    prop_values = '1000 8.9e-4'
  []
[]

[FVBCs]
  # INLET: Mass flow rate 0.055 kg/s → velocity
  [inlet_flow]
    type = INSFVInletVelocityBC
    variable = 'velocity'
    boundary = 'left'
    functor = 'inlet_func'
  []

  # OUTLET: Zero pressure gradient
  [outlet_pressure]
    type = INSFVNaturalFreeSlipBC
    variable = 'pressure'
    boundary = 'right'
  []

  # WALLS: No-slip condition
  [no_slip_x]
    type = INSFVNoSlipWallBC
    variable = 'velocity'
    boundary = 'top bottom front back'
    function = 0
  []
[]

[Functions]
  # Calculate inlet velocity: v = ṁ / (ρ·A)
  [inlet_func]
    type = ParsedVectorFunction
    expression_x = '0.055 / (1000 * 0.076 * 0.08)'  # ≈ 0.00905 m/s
    expression_y = '0'
    expression_z = '0'
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_shift_type'
    petsc_options_value = 'lu NONZERO'
  []
[]

[Executioner]
  type = Transient  # Start with transient for stability
  dt = 0.1
  end_time = 10
  solve_type = 'NEWTON'
  line_search = 'basic'
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
  l_tol = 1e-3
[]

# Pressure-velocity coupling
[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    advected_interp_method = 'upwind'
    velocity_interp_method = 'rc'
    rho = 'rho'
  []

  [mean_pressure]
    type = FVIntegralValueConstraint
    variable = pressure
    lambda = 0  # Lagr. multiplier for global constraint
  []
[]

# Stabilization
[GlobalParams]
  advected_interp_method = 'upwind'
  velocity_interp_method = 'rc'
  rhie_chow_user_object = 'rc'
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = 'velocity_x'
    v = 'velocity_y'
    w = 'velocity_z'
    pressure = pressure
  []
[]

[Postprocessors]
  [flow_in]
    type = VolumetricFlowRate
    vel_x = 'velocity_x'
    vel_y = 'velocity_y'
    vel_z = 'velocity_z'
    boundary = 'left'
    execute_on = 'timestep_end'
  []
  [flow_out]
    type = VolumetricFlowRate
    boundary = 'right'
    execute_on = 'timestep_end'
  []
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
[]