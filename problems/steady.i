


[Mesh]
    [bloco]
        type = GeneratedMeshGenerator
        dim = 3
        xmax = 2.23e-3
        xmin = 0
        nx = 20
        ymax = 6.65e-2
        ymin = 0
        ny = 20
        zmax = 0.6
        zmin = 0
        nz = 60
        
    []

[]



[Variables]
   
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
    [T]
        family = LAGRANGE
        order = FIRST
        initial_condition = 300
    []

[]



[Materials]

    [props]
        type = ADGenericConstantMaterial
        prop_names = 'mu rho cp k'
        prop_values = '0.00089 997 4182 0.6'
        
    []
    [thermal]
        type = HeatConductionMaterial
        thermal_conductivity = 0.6
    []
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

    [energy_advec]
        type = INSADEnergyAdvection
        variable = T
    []
    [energy_supg]
        type = INSADEnergySUPG
        variable = T
        velocity = velocity
    []
    [energy_conduc]
        type = ADHeatConduction
        variable = T
        thermal_conductivity = 'k'
    []
 
    
[]

[BCs]
  

    

    [inlet]
        type = VectorFunctionDirichletBC
        variable = velocity
        boundary = 'front'
        function_x = 0
        function_y = 0
        function_z = '0.055/(997*0.065*0.00223)'
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
    [walls]
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
        boundary = 'top bottom left right'
        value = 0
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
    checkpoint = true
    print_linear_residuals = true
    [console]
        type = Console
        outlier_variable_norms = false
    []
[]