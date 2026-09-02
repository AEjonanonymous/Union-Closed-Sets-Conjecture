import Lake
open Lake DSL

package «UnionClosedSetsConjecture» where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib «VizingDescentProof» where
  srcDir := "."
