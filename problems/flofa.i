


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
    [vel_x]
        order = FIRST
        family = LAGRANGE
        block = 0
        initial_condition = 0
    []
    [vel_y]
        order = FIRST
        family = LAGRANGE
        block = 0
        initial_condition = 0
    []
    [vel_z]
        order = FIRST
        family = LAGRANGE
        block = 0
        initial_condition = 0
    []
    [p]
        order = FIRST
        family = LAGRANGE
        block = 0
        initial_condition = 0
    []
    

[]



[Materials]

    [props]
        type = GenericConstantMaterial
        prop_names = 'mu rho'
        prop_values = '0.00089 997'
        
    []
    # [thermal]
    #     type = HeatConductionMaterial
    #     thermal_conductivity = 0.6
    # []

[]

[Kernels]
    [massa]
        type = INSMass
        u = vel_x
        v = vel_y
        w = vel_z
        variable = p
        pressure = p
        use_displaced_mesh = false  
    []
    # [Mxt]
    #     type = INSMomentumTimeDerivative
    #     variable = vel_x
    #     rho_name = rho
    # []
    [Mx]
        type = INSMomentumLaplaceForm
        variable = vel_x
        u = vel_x
        v = vel_y
        w = vel_z
        pressure = p
        component = 0
        integrate_p_by_parts = true
        rho_name = rho
        mu_name = mu
    []

    # [Myt]
    #     type = INSMomentumTimeDerivative
    #     variable = vel_y
    #     rho_name = rho
    # []
    [My]
        type = INSMomentumLaplaceForm
        variable = vel_y
        u = vel_x
        v = vel_y
        w = vel_z
        pressure = p
        component = 1
        integrate_p_by_parts = true
        rho_name = rho
        mu_name = mu
    []

    # [Mzt]
    #     type = INSMomentumTimeDerivative
    #     variable = vel_z
    #     rho_name = rho
    # []
    [Mz]
        type = INSMomentumLaplaceForm
        variable = vel_z
        u = vel_x
        v = vel_y
        w = vel_z
        pressure = p
        component = 2
        integrate_p_by_parts = true
        rho_name = rho
        mu_name = mu
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

    

    [inlet_x]
        type = DirichletBC
        variable = vel_x
        boundary = 'front'
        value = 0
    []

    [inlet_y]
        type = DirichletBC
        variable = vel_y
        boundary = 'front'
        value = 0
    []
    [inlet_z]
        type = FunctionDirichletBC  
        variable = vel_z
        boundary = 'front'
        function = '0.055/(997*0.076*0.08)'
    [] 

   
    [pressure_pin]
        type = DirichletBC  
        variable = p
        boundary = 'front'
        value = 0
        
    []
    # [Tf]
    #     type = NeumannBC
    #     variable = T
    #     boundary = 'back'
    # []



    # Paredes
    [walls_x]
        type = DirichletBC
        variable = vel_x
        boundary = 'top bottom left right'
        value = 0
    []
    [walls_y]
        type = DirichletBC
        variable = vel_y
        boundary = 'top bottom left right'
        value = 0
    []
    [walls_z]
        type = DirichletBC
        variable = vel_z
        boundary = 'top bottom left right'
        value = 0
    []
    
    
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
    # Improved settings for incompressible flow
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_type -pc_factor_shift_type -ksp_type -ksp_rtol -ksp_atol -snes_linesearch_type'
    petsc_options_value = 'lu       superlu_dist             NONZERO               gmres     1e-4     1e-8      basic'
  []
[]

[Executioner]
    type = Steady
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_type -pc_factor_shift_type'
    petsc_options_value = 'lu       superlu_dist             NONZERO'
    nl_rel_tol = 1e-6
    nl_abs_tol = 1e-8
    relaxation_factor = 0.7
    automatic_scaling = true
[]

[Outputs]
    exodus = true
    print_linear_residuals = true
    [console]
        type = Console
        outlier_variable_norms = false
    []
[]