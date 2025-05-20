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
    []
    [p]
    []
    [V]
    []
[]

[Materials]
    [thermal_props]
        type = GenericConstantMaterial
        prop_names = 'rho c k'
        prop_values = '997 4184 0.6'
    []
[]

[Functions]
    [heat_source]
        type = ParsedFunction
        expression = '1e3'
    []
[]

[Kernels]
    [transiente]
        type = TimeDerivative
        variable = T
    []
    [difussao]
        type = Diffusion
        
        variable = T
    []
    [fonte_calor]
        type = BodyForce
        variable = T
        function = 'heat_source'
    []
[]

[BCs]
    [entrada]
        type = DirichletBC
        boundary = 'front'
        value = 300
        variable = T
    []
    [saida]
        type = NeumannBC
        variable = T
        boundary = 'back'
        value = 1e3
    []
    
[]

[Executioner]
    type = Transient
    dt = 0.01
    end_time = 10
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
    petsc_options_value = 'hypre boomeramg 100'
    l_max_its = 50
    nl_max_its = 25
    nl_rel_tol = 1e-6
    [TimeStepper]
        type = IterationAdaptiveDT
        dt = 0.01
        optimal_iterations = 10
    []
[]

[Outputs]
    exodus = true
[]