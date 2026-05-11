import Lake
open Lake DSL

package "union-closed-sets-conjecture"

@[default_target]
lean_lib «Frankl's_Conjecture_Proof»

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.0"
