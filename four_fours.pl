/* Four Fours - Prolog
 * Author: Madison Sanchez-Forman | Version: 3.8.21 */

 /* Main Predicates*/
/* Filters the large list of possible expressions to the ones the evaluate to Val
 * params: E - Expresssion to be evaluated, Val - Value that E is expected to evaluate to (float) */
expr(E, Val) :-  expr_tree([4,4,4,4], E), Val is float(E).
%expr(E, Val) :- expr_tree([44,4,4], E), Val is float(E).
%expr(E, Val) :- expr_tree([444,4], E), Val is float(E). 	%concatenation possibilities: i worked hard at getting this to generate all expressions, and i know it can but i don't have time to continue with finals
/* Will print the number of all possible answers found and a possible solution for each number from 0 to Bound
 * params: Bound - number to stop printing results after. 0 -> Bound inclusive
 */
solve(Bound) :- print_boilerplate(0.0, Bound).

/* Builds an expression tree of all possible expressions using 4 4's */

expr_tree([Root], Root).				%root of the tree is singular operand
expr_tree(Nodes, L + R) :-
    append([L1|Left], [R1|Right], Nodes),
    expr_tree([L1|Left], L), 
    expr_tree([R1|Right], R).
expr_tree(Nodes, L - R) :-
    append([L1|Left], [R1|Right], Nodes),
    expr_tree([L1|Left], L), 
    expr_tree([R1|Right], R).
expr_tree(Nodes, L * R) :-
    append([L1|Left], [R1|Right], Nodes),
    expr_tree([L1|Left], L), 
    expr_tree([R1|Right], R).
expr_tree(Nodes, L / R) :- 
    append([L1|Left], [R1|Right], Nodes),
    expr_tree([L1|Left], L),
    expr_tree([R1|Right], R),
    Zero_check is R, Zero_check \= 0.

/* Helper predicates */
/* Used to find the number of solutions found for a particular number
 * params: N: number for solutions to be found for; L: number of solutions associated
 * */
len([],0).
len([_|Xs], N) :- len(Xs, N1), plus(N1, 1, N).
count_solns(N,L) :- findall(Results, expr(Results, N), Results), len(Results, L).

/* Used to take the head of the list of solutions for printing
 * params: N: number being evaluated evaluated; S: head of list of solutions found by findall
 * */ 
head([H|_], 1, H). 									%i only take the head of the list for simplicity 
take_head(N,S) :- findall(Results, expr(Results, N), Results), head(Results, 1,S).             

/* Used for 'solve(Bound)' predicate */
/* params: N - number currently being printed; Bound - number to stop printing at
 * */
print_boilerplate(N, Bound) :- 
    N =< Bound, 									%base case N =< Bound
    count_solns(N,0), 								% this rule of print_boilerplate is for handling cases where 0 solns are found
    write('I found '), write('0'), write(' solutions for '), write(N), write('.'), nl,
    N1 is N +1, print_boilerplate(N1, Bound),!. %recur & red cut, no solns found -> go to next number (N+1)
print_boilerplate(N, Bound) :-
    N =< Bound, count_solns(N, L), take_head(N, S), %repeat process for cases where solutions were found for a nunber
    write('I found '), write(L), write(' solutions for '),
    write(N), write(' one of which is: '), write(S), nl,
    N1 is N + 1, print_boilerplate(N1,Bound).



    
