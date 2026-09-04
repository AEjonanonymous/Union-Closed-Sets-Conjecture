import Lake
open Lake DSL

package «UnionClosedSetsConjecture» where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.0"

@[default_target]
lean_lib «Frankl's_Conjecture_Proof» where
  srcDir := "."
