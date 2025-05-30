# Define constants at top
rho_value = 997
mu_value = 0.00089
inlet_velocity_value = 0.055/(rho_value*0.076*0.08)  # Precomputed value: 0.00905 m/s

[Mesh]
  [bloco]
    type = GeneratedMeshGenerator
    dim = 3
    xmin = 0
    xmax = 0.076
    nx = 12
    ymin = 0
    ymax = 0.08
    ny = 12
    zmin = 0
    zmax = 0.6
    nz = 30
  []
[]

[Problem]
  type = FEProblem
[]

[Physics]
  [NavierStokes]
    [Flow]
      compressibility = 'incompressible'
      add_energy_equation = false
      
      # Variables
      velocity_variable = 'vel_x vel_y vel_z'
      pressure_variable = 'p'
      
      # Material properties
      density = ${rho_value}  # Constant density
      dynamic_viscosity = ${mu_value}  # Constant viscosity
      
      # Boundary conditions
      inlet_boundaries = 'front'
      momentum_inlet_types = 'fixed-velocity fixed-velocity fixed-velocity'
      momentum_inlet_function = '0 0 ${inlet_velocity_value}'
      
      wall_boundaries = 'top bottom left right'
      momentum_wall_types = 'noslip noslip noslip'
      
      outlet_boundaries = 'back'
      pressure_function = '0'  # Pressure at outlet
      
      # Pressure pinning
      pin_pressure = true
      pinned_pressure_type = point-value
      pinned_pressure_point = '0 0 0'
      
      # Rhie-Chow interpolation
      rhie_chow_user_object = 'rc'
      
      # Initial conditions
      initial_velocity = '0 0 0'
      initial_pressure = 0
      
      # Advection scheme
      advected_interp_method = 'upwind'
      velocity_interp_method = 'rc'
    []
  []
[]

[Variables]
  [vel_x]
    type = INSFVVelocityVariable
  []
  [vel_y]
    type = INSFVVelocityVariable
  []
  [vel_z]
    type = INSFVVelocityVariable
  []
  [p]
    type = INSFVPressureVariable
  []
[]

[AuxVariables]
  [vel_mag]
    type = MooseVariableFVReal
  []
[]

[AuxKernels]
  [vel_mag]
    type = VectorMagnitudeAux
    variable = vel_mag
    x = vel_x
    y = vel_y
    z = vel_z
    execute_on = 'TIMESTEP_END'
  []
[]

[Executioner]
  type = Transient
  dt = 0.1
  end_time = 10
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_type -ksp_rtol'
  petsc_options_value = 'lu NONZERO gmres 1e-5'
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-6
  l_tol = 1e-4
  automatic_scaling = true
  scaling_group_variables = 'vel_x vel_y vel_z p'
  
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
    optimal_iterations = 6
    iteration_window = 2
    growth_factor = 1.2
    cutback_factor = 0.5
  []
[]

[Outputs]
  exodus = true
  print_linear_residuals = true
[]