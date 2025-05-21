/** farm.pl — pure knowledge base for Coffee‑style GOAL */

:- dynamic ready/1.      % ready(Field)
:- dynamic stored/2.     % stored(Crop,Kg)
:- dynamic harvest_all_ready/0.  % top-level goal placeholder     % stored(Crop,Kg)

% -------------------------------------------------------------
% Static domain facts (no side‑effects, no external imports)
% -------------------------------------------------------------

capacity(10000).

field(f1).
field(f2).

crop(f1, wheat).
crop(f2, barley).

% Uniform expected yield (kg) per field
est_yield(Field, 2000) :- field(Field).

% -------------------------------------------------------------
% Pure helper predicates — *never* assert/retract here!
% -------------------------------------------------------------

/* sum_qtys(+List, -Sum)
   Simple list‑sum helper with a fresh name to avoid
   clashing with built‑in predicates. */
sum_qtys([], 0).
sum_qtys([H|T], S) :-
    sum_qtys(T, Rest),
    S is H + Rest.

/* total_stock(-Kg)
   Total kilograms currently stored in the silo. */
total_stock(Kg) :-
    findall(Q, stored(_,Q), Qs),
    sum_qtys(Qs, Kg).

/* free_cap(-Cap)
   Remaining free capacity in the silo. */
free_cap(Cap) :-
    capacity(Max),
    total_stock(Used),
    Cap is Max - Used.

/* can_harvest(+Field)
   True when Field is ready and there is enough space
   for its expected yield. */
can_harvest(Field) :-
    ready(Field),
    est_yield(Field, Yield),
    free_cap(Free),
    Free >= Yield.
