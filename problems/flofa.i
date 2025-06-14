


[Mesh]
    # [bloco]
    #   type = GeneratedMeshGenerator
        # dim = 3
        # xmax = 2.23e-3
        # xmin = 0
        # nx = 30
        # ymax = 6.65e-2
        # ymin = 0
        # ny = 30
        # zmax = 0.6
        # zmin = 0
        # nz = 80
        
    # []

    file = 'steady_out.e'

[]



[Variables]
   
    [velocity]
        family = LAGRANGE_VEC
        order = FIRST
        initial_condition = '1e-15 1e-15 1e-15'
    []
    [p]
        family = LAGRANGE
        order = FIRST
        block = 0
        initial_condition = 0
    []
    [T]
        family = LAGRANGE
        order = FIRST
        initial_condition = 300
    []

[]

# [Problem]
#     type = FEProblem
#     solve = false
# []

# [ICs]
#     [initial_block_T]
#         type = ConstantIC
#         variable = T
#         value = 300
#     []
# []

[Functions]
    [wall_flux]
        type = ParsedFunction
        expression = '4.104e5 * cos(2 * pi * z / 0.7)'
    []
[]

[Materials]

    [props]
        type = ADGenericConstantMaterial
        prop_names = 'mu rho cp k'
        prop_values = '0.00089 997 4182 0.6'
        
    []

    [ins_mat]
        type = INSADStabilized3Eqn
        velocity = velocity
        pressure = p
        temperature = T
        cp_name = 'cp'
        k_name = 'k'
        mu_name = 'mu'
        rho_name = 'rho'
    []

[]

[Kernels]
    [massa]
        type = INSADMass
        variable = p
    []
    [massa_stab]
        type = INSADMassPSPG
        variable = p
        rho_name = rho
    []
    [momentum_time]
        type = INSADMomentumTimeDerivative
        variable = velocity
    []
    [momentum_advec]
        type = INSADMomentumAdvection
        variable = velocity
    []
    [momentum_visc]
        type = INSADMomentumViscous
        variable = velocity
    []

    [momentum_pressure]
        type = INSADMomentumPressure
        variable = velocity
        pressure = p
    []
    [momentum_supg]
        type = INSADMomentumSUPG
        variable = velocity
        velocity = velocity
    []
    [momentum_gravity]
        type = INSADGravityForce
        variable = velocity
        gravity = '0 0 -9.8'
    []

    [energy_advec]
        type = INSADEnergyAdvection
        variable = T
    []
    [energy_advec_time]
        type = INSADHeatConductionTimeDerivative
        variable = T
    []
    [energy_supg]
        type = INSADEnergySUPG
        variable = T
        velocity = velocity
    []

    # [energy_source]
    #     type = INSADEnergySource
    #     variable = T
    #     source_function = 10e7
    # []
    # [energy_conduc]
    #     type = ADHeatConduction
    #     variable = T
    #     thermal_conductivity = 'k'
    # []

    
[]

[BCs]
  

    

    [inlet_vel]
        type = VectorFunctionDirichletBC
        variable = velocity
        boundary = 'front'
        function_x = 0
        function_y = 0
        function_z = '0.055/(997*0.063*0.00223)'
    []
    [inlet_T]
        type = DirichletBC
        variable = T
        boundary = 'front'
        value = 300
    []

   
    [pressure_pin]
        type = DirichletBC  
        variable = p
        boundary = 'back'
        value = 0
        
    []

    # Paredes
    [walls_vel]
        type = VectorFunctionDirichletBC
        variable = velocity
        boundary = 'top bottom left right'
        function_x = 0
        function_y = 0
        function_z = 0
    []
    [walls_T]
        type = NeumannBC
        variable = T
        boundary = 'top bottom'
        value = 0
    []
    [walls_Tflux]
        type = FunctionNeumannBC
        variable = T
        boundary = 'left right'
        function = wall_flux
    []

[]

[Preconditioning]
    [SMP]
        type = SMP
        full = true
        petsc_options_iname = '-pc_type -pc_factor_mat_solver_type -pc_factor_shift_type -ksp_type -ksp_rtol -ksp_atol'
        petsc_options_value = 'lu       superlu_dist             NONZERO               gmres     1e-6     1e-8'
    []
[]


[Executioner]
    type = Transient  
    start_time = 0
    end_time = 5
    dt = 1e-7
    nl_max_its = 150
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_type'
    petsc_options_value = 'lu NONZERO gmres'
    nl_abs_tol = 1e-7
    nl_rel_tol = 1e-5
    line_search = 'bt'  
    automatic_scaling = true
    [TimeStepper]
        type = IterationAdaptiveDT
        optimal_iterations = 6
        dt = 1e-6
        cutback_factor = 0.5
    []
[]

[Outputs]
    exodus = true
    print_linear_residuals = true
    [console]
        type = Console
        outlier_variable_norms = false
    []
[]