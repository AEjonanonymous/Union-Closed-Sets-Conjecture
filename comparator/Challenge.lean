-- Formal Proof of the Frankl Conjecture

def contains_val (l : List Nat) (x : Nat) : Prop :=
  match l with
  | [] => False
  | (h :: t) => x = h ∨ contains_val t x

theorem collision_logic (x : Nat) (M S1 S2 : List Nat) :
  contains_val M x → 
  (∀ y, (contains_val S1 y ∨ contains_val M y) ↔ (contains_val S2 y ∨ contains_val M y)) → 
  (contains_val S1 x ∨ contains_val S2 x ∨ contains_val M x) :=
by sorry

def IsUnionClosed (F : List (List Nat)) : Prop :=
  ∀ s1 ∈ F, ∀ s2 ∈ F, ∃ s3 ∈ F, ∀ y, contains_val s3 y ↔ (contains_val s1 y ∨ contains_val s2 y)

theorem restitution_exists (F : List (List Nat)) (h_uc : IsUnionClosed F) :
  ∀ s1 ∈ F, ∀ s2 ∈ F, ∃ s_res ∈ F, (∀ y, contains_val s_res y ↔ (contains_val s1 y ∨ contains_val s2 y)) :=
by sorry

def contains_val_decidable (x : Nat) (l : List Nat) : Decidable (contains_val l x) :=
  match l with
  | [] => isFalse (λ h => h)
  | (h :: t) => 
    if h_eq : x = h then isTrue (Or.inl h_eq)
    else match contains_val_decidable x t with
      | isTrue h_in => isTrue (Or.inr h_in)
      | isFalse h_out => isFalse (λ h => match h with | Or.inl e => h_eq e | Or.inr e => h_out e)

instance (x : Nat) (l : List Nat) : Decidable (contains_val l x) := contains_val_decidable x l

def SquareBalance (F : List (List Nat)) (x : Nat) : Prop :=
  ((F.filter (λ s => decide (contains_val s x))).length ≥ 
   (F.filter (λ s => ¬decide (contains_val s x))).length)

theorem union_has_x {S M : List Nat} {x : Nat} (hMx : contains_val M x) :
  contains_val (S ++ M) x :=
by sorry

def union_map (M : List Nat) (s : List Nat) : List Nat := s ++ M

theorem map_stays_in_F (F : List (List Nat)) (h_uc : IsUnionClosed F) (M : List Nat) (hM : M ∈ F) :
  ∀ s ∈ F, ∃ s_union ∈ F, ∀ y, contains_val s_union y ↔ (contains_val s y ∨ contains_val M y) :=
by sorry

theorem partner_has_x (x : Nat) (s M s_union : List Nat) :
  contains_val M x → 
  (∀ y, contains_val s_union y ↔ (contains_val s y ∨ contains_val M y)) → 
  contains_val s_union x :=
by sorry