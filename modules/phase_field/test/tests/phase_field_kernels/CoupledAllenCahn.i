#
# Test the coupled Allen-Cahn Bulk kernel
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  nz = 0
  xmin = 0
  xmax = 50
  ymin = 0
  ymax = 50
  zmin = 0
  zmax = 50
  elem_type = QUAD4

  uniform_refine = 1
[]

[Variables]
  [./w]
  [../]
  [./eta]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = SmoothCircleIC
      x1 = 25.0
      y1 = 25.0
      radius = 6.0
      invalue = 0.9
      outvalue = 0.1
      int_width = 3.0
    [../]
  [../]
[]

[Kernels]
  [./detadt]
    type = TimeDerivative
    variable = eta
  [../]

  [./ACBulk]
    type = CoupledAllenCahn
    variable = w
    v = eta
    f_name = F
  [../]

  [./W]
    type = Reaction
    variable = w
  [../]

  [./CoupledBulk]
    type = MatReaction
    variable = eta
    v = w
  [../]

  [./ACInterface]
    type = ACInterface
    variable = eta
    kappa_name = 1
  [../]
[]

[Materials]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'L'
    prop_values = '1'
  [../]

  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = F
    args = 'eta'
    function = '2 * eta^2 * (1-eta)^2 - 0.2*eta'
    derivative_order = 2
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'

  solve_type = 'PJFNK'

  l_max_its = 15
  l_tol = 1.0e-4

  nl_max_its = 10
  nl_rel_tol = 1.0e-11

  start_time = 0.0
  num_steps = 2
  dt = 0.5
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  hide = w
  file_base = AllenCahn_out
  exodus = true
[]
