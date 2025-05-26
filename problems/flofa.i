


[Mesh]
    [bloco]
        type = GeneratedMeshGenerator
        dim = 3
        xmax = 0.076
        xmin = 0
        nx = 10
        ymax = 0.08
        ymin = 0
        ny = 10
        zmax = 0.6
        zmin = 0
        nz = 20
        
    []

[]



[Variables]
    [T]
        family = LAGRANGE
        order = FIRST
        initial_condition = 300
        block = 0
    []
    [vel_x]
        order = FIRST
        family = LAGRANGE
        block = 0
    []
    [vel_y]
        order = FIRST
        family = LAGRANGE
        block = 0
    []
    [vel_z]
        order = FIRST
        family = LAGRANGE
        block = 0
    []
    [p]
        block = 0
    []

[]



[Materials]

    [props]
        type = GenericConstantMaterial
        prop_names = 'mu rho k cp'
        prop_values = '0.00089 997 0.6 4182'
        
    []
    [thermal]
        type = HeatConductionMaterial
        thermal_conductivity = 0.6
    []

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
    [Mxt]
        type = INSMomentumTimeDerivative

        variable = vel_x

    []
    [Mx]
        type = INSMomentumLaplaceForm
        component = 0
        pressure = p
        u = vel_x
        variable = vel_x
        v = vel_y
        w = vel_z
    []
    [Myt]
        type = INSMomentumTimeDerivative

        variable = vel_y

    []
    [My]
        type = INSMomentumLaplaceForm
        variable = vel_y
        component = 1
        u = vel_x
        v = vel_y
        pressure = p
        w = vel_z
    []
    [Mzt]
        type = INSMomentumTimeDerivative

        variable = vel_z

    []
    [Mz]
        type = INSMomentumLaplaceForm
        variable = vel_z
        component = 2
        u = vel_x
        v = vel_y
        pressure = p
        w = vel_z
    []

    [convec]
        type = INSTemperature
        variable = T
        u = vel_x
        v = vel_y
        w = vel_z

    []
    [temp_time]
        type = CoefTimeDerivative
        variable = T
        Coefficient = ${fparse 997*4182}
    []

    [conduc]
        type = HeatConduction
        variable = T
        
    []

    [fonte]
        type = BodyForce
        variable = T
        value = '150000'
    []
[]

[BCs]
    [entrada]
        type = DirichletBC
        boundary = 'front'
        value = 300
        variable = T
    []

    [inx]
        type = DirichletBC
        variable = vel_x
        boundary = 'front'
        value = 0
    [] 

    [iny]
        type = DirichletBC
        variable = vel_y
        boundary = 'front'
        value = 0
    [] 

    [inz]
        type = DirichletBC
        variable = vel_z
        boundary = 'front'
        value = -0.1
    [] 

    [saida]
        type = DirichletBC
        variable = p
        boundary = 'back'
        value = 0
    []

    # Paredes
    [slipx]
        type = DirichletBC
        variable = vel_x
        boundary = 'top bottom left right'
        value = 0
    []
    [slipy]
        type = DirichletBC
        variable = vel_y
        boundary = 'top bottom left right'
        value = 0
    []
    [adiabatic]
        type = NeumannBC
        variable = T
        boundary = 'top bottom left right'
        value = 10000
    []
    
[]

[Executioner]
    type = Transient
    start_time = 0
    
    end_time = 10
    dtmin = 1e-4
    dtmax = 10
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_type -pc_factor_shift_type -ksp_type -ksp_rtol'
    petsc_options_value = 'lu       superlu_dist             NONZERO               gmres     1e-4'
    line_search = 'bt'
    nl_max_its = 15
    l_max_its = 50
    nl_rel_tol = 1e-6
    nl_abs_tol = 1e-8
    [TimeStepper]
        type = IterationAdaptiveDT
        dt = 0.1
        optimal_iterations = 8
        iteration_window = 2
        growth_factor = 1.2
        cutback_factor = 0.25
    []
[]

[Outputs]
    exodus = true
[]