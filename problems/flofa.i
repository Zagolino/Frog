


[Mesh]
    [bloco]
        type = GeneratedMeshGenerator
        dim = 3
        xmax = 0.076
        xmin = 0
        nx = 15
        ymax = 0.08
        ymin = 0
        ny = 15
        zmax = 0.6
        zmin = 0
        nz = 40
        
    []

[]



[Variables]
    # [T]
    #     family = LAGRANGE
    #     order = FIRST
    #     initial_condition = 300
    #     block = 0
    # []
    [velocity]
        family = LAGRANGE_VEC
        order = FIRST
        initial_condition = '0 0 0'
    []
    [p]
        family = LAGRANGE
        order = FIRST
        block = 0
        initial_condition = 0
    []
    

[]



[Materials]

    [props]
        type = ADGenericConstantMaterial
        prop_names = 'mu rho cp k'
        prop_values = '0.00089 997 4182 0.6'
        
    []
    # [thermal]
    #     type = HeatConductionMaterial
    #     thermal_conductivity = 0.6
    # []
    [ins_mat]
        type = INSADStabilized3Eqn
        velocity = velocity
        pressure = p
        temperature = 300
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

 
    # [temp_time]
    #     type = CoefTimeDerivative
    #     variable = T
    #     Coefficient = ${fparse 997*4182}
    # []

    # [conduc]
    #     type = HeatConduction
    #     variable = T
        
    # []

    # [fonte]
    #     type = BodyForce
    #     variable = T
    #     value = '1000'
    # []
[]

[BCs]
    # [entrada]
    #     type = DirichletBC
    #     boundary = 'front'
    #     value = 300
    #     variable = T
    # []

    

    [inlet]
        type = VectorFunctionDirichletBC
        variable = velocity
        boundary = 'front'
        function_x = 0
        function_y = 0
        function_z = '0.055/(997*0.076*0.08)'
    []


   
    [pressure_pin]
        type = DirichletBC  
        variable = p
        boundary = 'back'
        value = 0
        
    []
    # [Tf]
    #     type = NeumannBC
    #     variable = T
    #     boundary = 'back'
    # []



    # Paredes
    [walls]
        type = VectorFunctionDirichletBC
        variable = velocity
        boundary = 'top bottom left right'
        function_x = 0
        function_y = 0
        function_z = 0
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
    type = Transient  # Start transient even for steady flow
    start_time = 0
    end_time = 50
    dt = 0.5
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -pc_factor_shift_type'
    petsc_options_value = 'lu NONZERO'
    nl_abs_tol = 1e-8
    nl_rel_tol = 1e-6
    line_search = 'bt'  # Backtracking line search
    automatic_scaling = true
    [TimeStepper]
        type = IterationAdaptiveDT
        optimal_iterations = 6
        dt = 0.1
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