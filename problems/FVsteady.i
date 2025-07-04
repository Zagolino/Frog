# rho = 'rho'
rho = 997

velocity_interp_method = 'rc'
advected_interp_method = 'upwind'


k = 0.6
cp = 4182
mu = 0.00089


# inlet_temp = 300



[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 3
    xmin = 0
    xmax = 2.23e-3
    ymin = 0
    ymax = 6.65e-2
    zmin = 0
    zmax = 0.6
    nx = 15
    ny = 15
    nz = 60 
  []
[]

[GlobalParams]
  rhie_chow_user_object = 'rc'
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = vel_x
    v = vel_y
    w = vel_z
    pressure = pressure
  []
[]

[Variables]
  [vel_x]
    type = INSFVVelocityVariable
    initial_condition = 0
  []
  [vel_y]
    type = INSFVVelocityVariable
    initial_condition = 0
  []
  [vel_z]
    type = INSFVVelocityVariable
    initial_condition = 0
  []
  [pressure]
    type = INSFVPressureVariable
    initial_condition = 1e5
  []
  # [T_fluid]
  #   type = INSFVEnergyVariable
  #   initial_condition = ${inlet_temp}
  # []
[]

# [AuxVariables]
#   # [mixing_length]
#   #   type = MooseVariableFVReal
#   # []
#   [power_density]
#     type = MooseVariableFVReal
#     initial_condition = 1e4
#   []
# []

[Functions]
  [wall_flux]
    type = ParsedFunction
    expression = '4.104e5 * cos(2 * pi * z / 0.7)'
  []

[]

[FVKernels]
  # inactive = 'u_turb v_turb temp_turb'
  # [mass_time]
  #   type = WCNSFVMassTimeDerivative
  #   variable = pressure
  #   drho_dt = drho_dt
  # []
  [mass]
    type = WCNSFVMassAdvection
    variable = pressure
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
  []

  # [u_time]
  #   type = WCNSFVMomentumTimeDerivative
  #   variable = vel_x
  #   drho_dt = drho_dt
  #   rho = rho
  #   momentum_component = 'x'
  # []
  [u_advection]
    type = INSFVMomentumAdvection
    variable = vel_x
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    rho = ${rho}
    momentum_component = 'x'
  []
  [u_viscosity]
    type = INSFVMomentumDiffusion
    variable = vel_x
    mu = ${mu}
    momentum_component = 'x'
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = vel_x
    momentum_component = 'x'
    pressure = pressure
  []
  # [u_turb]
  #   type = INSFVMixingLengthReynoldsStress
  #   variable = vel_x
  #   rho = ${rho}
  #   mixing_length = 'mixing_length'
  #   momentum_component = 'x'
  #   u = vel_x
  #   v = vel_y
  #   w = vel_z
  # []

  # [w_time]
  #   type = WCNSFVMomentumTimeDerivative
  #   variable = vel_z
  #   drho_dt = drho_dt
  #   rho = rho
  #   momentum_component = 'z'
  # []
  [w_advection]
    type = INSFVMomentumAdvection
    variable = vel_z
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    rho = ${rho}
    momentum_component = 'z'
  []
  [w_viscosity]
    type = INSFVMomentumDiffusion
    variable = vel_z
    momentum_component = 'z'
    mu = ${mu}
  []
  [w_pressure]
    type = INSFVMomentumPressure
    variable = vel_z
    momentum_component = 'z'
    pressure = pressure
  []
  # [w_turb]
  #   type = INSFVMixingLengthReynoldsStress
  #   variable = vel_z
  #   rho = ${rho}
  #   mixing_length = 'mixing_length'
  #   momentum_component = 'z'
  #   u = vel_x
  #   v = vel_y
  #   w = vel_z
  # []

  # [v_time]
  #   type = WCNSFVMomentumTimeDerivative
  #   variable = vel_y
  #   drho_dt = drho_dt
  #   rho = rho
  #   momentum_component = 'y'
  # []
  [v_advection]
    type = INSFVMomentumAdvection
    variable = vel_y
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_viscosity]
    type = INSFVMomentumDiffusion
    variable = vel_y
    momentum_component = 'y'
    mu = ${mu}
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = vel_y
    momentum_component = 'y'
    pressure = pressure
  []
  # [v_turb]
  #   type = INSFVMixingLengthReynoldsStress
  #   variable = vel_y
  #   rho = ${rho}
  #   mixing_length = 'mixing_length'
  #   momentum_component = 'y'
  #   u = vel_x
  #   v = vel_y
  #   w = vel_z
  # []

  # [temp_time]
  #   type = WCNSFVEnergyTimeDerivative
  #   variable = T_fluid
  #   rho = rho
  #   drho_dt = drho_dt
  #   h = h
  #   dh_dt = dh_dt
  # []
  # [temp_conduction]
  #   type = FVDiffusion
  #   coeff = 'k'
  #   variable = T_fluid
  # []
  # [temp_advection]
  #   type = INSFVEnergyAdvection
  #   variable = T_fluid
  #   velocity_interp_method = ${velocity_interp_method}
  #   advected_interp_method = ${advected_interp_method}
  # []
  # [heat_source]
  #   type = FVCoupledForce
  #   variable = T_fluid
  #   v = power_density
  # []
  # [temp_turb]
  #   type = WCNSFVMixingLengthEnergyDiffusion
  #   variable = T_fluid
  #   rho = rho
  #   cp = cp
  #   mixing_length = 'mixing_length'
  #   schmidt_number = 1
  #   u = vel_x
  #   v = vel_y
  # []
[]

[FVBCs]
  [no_slip_x]
    type = INSFVNoSlipWallBC
    variable = vel_x
    boundary = 'top bottom right left'
    function = 0
  []
  [no_slip_y]
    type = INSFVNoSlipWallBC
    variable = vel_y
    boundary = 'top bottom right left'
    function = 0
  []
  [no_slip_z]
    type = INSFVNoSlipWallBC
    variable = vel_z
    boundary = 'top bottom right left'
    function = 0
  []

  # [walls_T]
  #   type = FVNeumannBC
  #   variable = T_fluid
  #   boundary = 'top bottom'
  #   value = 0
  # []
  # [walls_Tflux]
  #   type = FVFunctionNeumannBC
  #   variable = T_fluid
  #   boundary = 'left right'
  #   function = wall_flux
  # []

  # Inlet
  [inlet_u]
    type = INSFVInletVelocityBC
    variable = vel_x
    boundary = 'front'
    functor = 0
  []
  [inlet_v]
    type = INSFVInletVelocityBC
    variable = vel_y
    boundary = 'front'
    functor = 0
  []
  [inlet_w]
    type = INSFVInletVelocityBC
    variable = vel_z
    boundary = 'front'
    functor = 0.38
  []
  # [inlet_T]
  #   type = FVDirichletBC
  #   variable = T_fluid
  #   boundary = 'front'
  #   value = ${inlet_temp}
  # []

  [inlet_p]
    type = FVDirichletBC
    variable = pressure
    boundary = 'front'
    value = 1e5
  []

  [outlet_p]
    type = FVNeumannBC
    variable = pressure
    boundary = 'back'
    value = 0
  []


[]

[FluidProperties]
  [fp]
    type = Water97FluidProperties 
  []
[]

[FunctorMaterials]
  [const_functor]
    type = ADGenericFunctorMaterial
    prop_names = 'cp k rho'
    prop_values = '${cp} ${k} ${rho}'
  []
  # [rho]
  #   type = RhoFromPTFunctorMaterial
  #   fp = fp
  #   temperature = T_fluid
  #   pressure = pressure
  # []
  # [ins_fv]
  #   type = INSFVEnthalpyFunctorMaterial
  #   temperature = 'T_fluid'
  #   rho = ${rho}
  # []
[]

# [AuxKernels]
#   inactive = 'mixing_len'
#   [mixing_len]
#     type = WallDistanceMixingLengthAux
#     walls = 'top'
#     variable = mixing_length
#     execute_on = 'initial'
#     delta = 0.5
#   []
# []

[Preconditioning]
  [SMP]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_type -pc_factor_shift_type -ksp_type -ksp_rtol -ksp_atol'
    petsc_options_value = 'lu       superlu_dist             NONZERO               gmres     1e-6     1e-8'
  []
[]

[Executioner]
  type = Steady


  nl_max_its = 800
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-4
  line_search = 'bt' 
  automatic_scaling = true
  
[]


[Outputs]
  exodus = true
[]