rho = 'rho'

velocity_interp_method = 'rc'
advected_interp_method = 'upwind'






outlet_pressure = 1.7e5
inlet_value = -1.5

[Mesh]
  

  file = 'Ponte2_out.e'
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
    initial_condition = 1e-15
  []
  [vel_y]
    type = INSFVVelocityVariable
    initial_condition = 1e-15
  []
  [vel_z]
    type = INSFVVelocityVariable
    initial_condition = ${inlet_value}
  []
  [pressure]
    type = INSFVPressureVariable
    initial_condition = ${outlet_pressure}
  []
  [T_fluid]
    type = INSFVEnergyVariable
    initial_condition = 311.15
  []
[]

[AuxVariables]
  [mixing_length]
    type = MooseVariableFVReal
  []

  [k]
    type = MooseVariableFVReal
  []
  [cp]
    type = MooseVariableFVReal
  []
  [mu]
    type = MooseVariableFVReal
  []

[]

[Functions]
  [wall_flux]
    type = ParsedFunction
    expression = '5.51e5 * cos(pi * z / 0.7)' #5.51*2
    
  []
  [flow_decay_function]
    type = ParsedFunction
    # expression = 'if(t <= 1 , -0.39 , (-(0.055 * exp(-(t-1)/1.4375)))/(997*0.063*0.00223))'
    expression = ${inlet_value}
  []
[]

[AuxKernels]
  
  [mixing_len]
    type = WallDistanceMixingLengthAux
    walls = 'top bottom right left'
    variable = mixing_length
    execute_on = 'TIMESTEP_END'
    delta = 0.5
  []
  [k]
    type = MaterialRealAux
    variable = k
    property = k
  []
  [mu]
    type = MaterialRealAux
    variable = mu
    property = viscosity
  []
  [cp]
    type = MaterialRealAux
    variable = cp
    property = cp
  []

[]

[FVKernels]
  inactive = ''
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

  [g]
    type = INSFVMomentumGravity
    gravity = '0 0 -1'
    variable = vel_z
    rho = ${rho}
    momentum_component = 'z'
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
    mu = mu
    momentum_component = 'x'
    variable_interp_method = 'skewness-corrected'
    limit_interpolation = true
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = vel_x
    momentum_component = 'x'
    pressure = pressure
  []
  [u_turb]
    type = INSFVMixingLengthReynoldsStress
    variable = vel_x
    rho = ${rho}
    mixing_length = 'mixing_length'
    momentum_component = 'x'
    u = vel_x
    v = vel_y
    w = vel_z
  []

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
    mu = mu
    variable_interp_method = 'skewness-corrected'
    limit_interpolation = true
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = vel_y
    momentum_component = 'y'
    pressure = pressure
  []
  [v_turb]
    type = INSFVMixingLengthReynoldsStress
    variable = vel_y
    rho = ${rho}
    mixing_length = 'mixing_length'
    momentum_component = 'y'
    u = vel_x
    v = vel_y
    w = vel_z
  []

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
    mu = mu
    variable_interp_method = 'skewness-corrected'
    limit_interpolation = true
  []
  [w_pressure]
    type = INSFVMomentumPressure
    variable = vel_z
    momentum_component = 'z'
    pressure = pressure
  []
  [w_turb]
    type = INSFVMixingLengthReynoldsStress
    variable = vel_z
    rho = ${rho}
    mixing_length = 'mixing_length'
    momentum_component = 'z'
    u = vel_x
    v = vel_y
    w = vel_z
  []

  

  # [temp_time]
  #   type = WCNSFVEnergyTimeDerivative
  #   variable = T_fluid
  #   rho = rho
  #   drho_dt = drho_dt
  #   h = h
  #   dh_dt = dh_dt
  # []
  [temp_conduction]
    type = FVDiffusion
    coeff = k
    variable = T_fluid
  []
  [temp_advection]
    type = INSFVEnergyAdvection
    variable = T_fluid
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []

  [temp_turb]
    type = WCNSFVMixingLengthEnergyDiffusion
    variable = T_fluid
    rho = rho
    cp = cp
    mixing_length = 'mixing_length'
    schmidt_number = 1
    u = vel_x
    v = vel_y
    w = vel_z
  []
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

  [walls_T]
    type = FVNeumannBC
    variable = T_fluid
    boundary = 'left right'
    value = 0
  []
  [walls_Tflux]
    type = FVFunctionNeumannBC
    variable = T_fluid
    boundary = 'top bottom'
    function = wall_flux
    # function = 0
    
  []

  [walls_convecflux]
    type = FVFunctionNeumannBC
    variable = T_fluid
    boundary = 'top bottom'
    # function = enable_convec
    function = 0
    
  []

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
  [inlet_z]
    type = INSFVInletVelocityBC
    variable = vel_z
    boundary = 'front'
    # functor = flow_decay_function
    functor = -1.5
  []
  [inlet_T]
    type = FVDirichletBC
    variable = T_fluid
    boundary = 'front'
    value = 311.15
  []

  [outlet_p]
    type = INSFVOutletPressureBC
    variable = pressure
    boundary = 'back'
    functor = ${outlet_pressure}
  []
[]

[FluidProperties]
  [water_prop]
    type = Water97FluidProperties
  []
[]

[Materials]
  [fluid_props_material]
    type = FluidPropertiesMaterialPT
    block = 0
    fp = water_prop
    temperature = T_fluid
    pressure = pressure
    
  []

[]

[FunctorMaterials]

  [rho]
    type = RhoFromPTFunctorMaterial
    fp = water_prop
    temperature = T_fluid
    pressure = pressure
    block = 0
  []
  [ins_fv]
    type = INSFVEnthalpyFunctorMaterial
    temperature = 'T_fluid'
    rho = ${rho}
    fp = water_prop

    pressure = pressure
    assumed_constant_cp = false
    block = 0
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]


[Executioner]
  type = Steady


  nl_max_its = 50
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = 'lu       NONZERO               mumps                  gmres    300'
  line_search = 'basic'
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-6
  scaling_group_variables = 'vel_x vel_y vel_z; pressure; T_fluid'
  automatic_scaling = true
  relaxation_factor = 0.5
[]


[Outputs]
  exodus = true
  checkpoint = true
[]




