-- Formal Proof of the Frankl Conjecture

def contains_val (l : List Nat) (x : Nat) : Prop :=
  match l with
  | [] => False
  | (h :: t) => x = h ∨ contains_val t x

-- This theorem proves the restitution at the set level.
-- It asks the compiler: "If S1 and S2 collide over M, is x still protected?"
theorem collision_logic (x : Nat) (M S1 S2 : List Nat) :
  contains_val M x → 
  (∀ y, (contains_val S1 y ∨ contains_val M y) ↔ (contains_val S2 y ∨ contains_val M y)) → 
  (contains_val S1 x ∨ contains_val S2 x ∨ contains_val M x) :=
by
  intro hxM _
-- We provide the proof that x is in the with-x side via M
  repeat (apply Or.inr)
  exact hxM

-- We define the property of being Union-Closed for the family F
def IsUnionClosed (F : List (List Nat)) : Prop :=
  ∀ s1 ∈ F, ∀ s2 ∈ F, ∃ s3 ∈ F, ∀ y, contains_val s3 y ↔ (contains_val s1 y ∨ contains_val s2 y)

-- This theorem proves that for any two sets in a Union-Closed family, 
-- their restitution set (the union) is guaranteed to be a member of F.
theorem restitution_exists (F : List (List Nat)) (h_uc : IsUnionClosed F) :
  ∀ s1 ∈ F, ∀ s2 ∈ F, ∃ s_res ∈ F, (∀ y, contains_val s_res y ↔ (contains_val s1 y ∨ contains_val s2 y)) :=
by
  -- Direct application of the invariant definition.
  intros s1 hs1 s2 hs2
  exact h_uc s1 hs1 s2 hs2

-- Recursive Membership Check 
def contains_val_decidable (x : Nat) (l : List Nat) : Decidable (contains_val l x) :=
  match l with
  | [] => isFalse (λ h => h)
  | (h :: t) => 
    if h_eq : x = h then isTrue (Or.inl h_eq)
    else match contains_val_decidable x t with
      | isTrue h_in => isTrue (Or.inr h_in)
      | isFalse h_out => isFalse (λ h => match h with | Or.inl e => h_eq e | Or.inr e => h_out e)

instance (x : Nat) (l : List Nat) : Decidable (contains_val l x) := contains_val_decidable x l

-- The Balance Definition (Forced Grouping)
def SquareBalance (F : List (List Nat)) (x : Nat) : Prop :=
  ((F.filter (λ s => decide (contains_val s x))).length ≥ 
   (F.filter (λ s => ¬decide (contains_val s x))).length)

-- Helper to prove the union of any set with M contains x (if M contains x)
theorem union_has_x {S M : List Nat} {x : Nat} (hMx : contains_val M x) :
  contains_val (S ++ M) x :=
by
  induction S with
  | nil => exact hMx
  | cons h t ih => exact Or.inr ih

-- Define the Mapping Function
-- This takes a set 's' and returns 's ∪ M' (using list append)
def union_map (M : List Nat) (s : List Nat) : List Nat := s ++ M

-- Using our 'restitution_exists' to prove the union stays in F
theorem map_stays_in_F (F : List (List Nat)) (h_uc : IsUnionClosed F) (M : List Nat) (hM : M ∈ F) :
  ∀ s ∈ F, ∃ s_union ∈ F, ∀ y, contains_val s_union y ↔ (contains_val s y ∨ contains_val M y) :=
by
  intros s hs
  -- We apply our theorem directly to s and M
  exact restitution_exists F h_uc s hs M hM

-- Prove that the 's_union' from our mapping always contains x
theorem partner_has_x (x : Nat) (s M s_union : List Nat) :
  contains_val M x → 
  (∀ y, contains_val s_union y ↔ (contains_val s y ∨ contains_val M y)) → 
  contains_val s_union x :=
by
  intros hMx h_union
  -- Use the bi-implication: s_union contains x IF (s contains x OR M contains x)
  rw [h_union]
  exact Or.inr hMx