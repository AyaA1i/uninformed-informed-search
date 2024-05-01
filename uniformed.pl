search(N, M, Input) :-
    TotalCells is N * M,
    for_loop(0, TotalCells, search_state(N, M, Input))
    .

for_loop(CurrentIndex, TotalCells, Predicate) :-
    CurrentIndex < TotalCells,
    not(call(Predicate, CurrentIndex)),
    NextIndex is CurrentIndex + 1,
    for_loop(NextIndex, TotalCells, Predicate),
    NextIndex = TotalCells,
    write('No cycle found'),
    !.

for_loop(_, _, _).    

search_state(N, M, Input, CurrentIndex) :-
    nth0(CurrentIndex, Input, Value),
    State = [CurrentIndex, Value],
    Goal = State,
    search([[State, [null, null]]], [], Goal, N, M, Input).



search(Open, Closed, Goal, _, M, Input):-
    getState(Open, [CurrentState, Parent], _),
    
    up(CurrentState, NextState, M),
    nth0(0, NextState, NextIndex),
    nth0(NextIndex, Input, NextColor),
    nth0(1, Goal, NextColor),
    nth0(0, CurrentState, CurrentIndex),
    nth0(0, Goal, GoalIndex),
    CurrentIndex =:= GoalIndex + M,
    \+ Parent = Goal,
    !,
    
    printSolution([CurrentState,Parent], Closed)
    .

search(Open, Closed, Goal, N, M, Input):-
    getState(Open, CurrentNode, TmpOpen),
    getAllValidChildren(CurrentNode, Closed, N, M, Input, Children), 
    addChildren(Children, TmpOpen, NewOpen),
    append(Closed, [CurrentNode], NewClosed),
    search(NewOpen, NewClosed, Goal, N, M, Input).

    

getAllValidChildren(Node, Closed, N, M, Input, Children):-
    findall(Next, (
        getNextState(Node, Closed, Next, N, M),
		nth0(0, Next, NextState),
        nth0(0, NextState, Index),
        nth0(1, NextState, Color),
        nth0(Index, Input, Color)
    ), Children)
.

getNextState([State, _], Closed, [Next,State], N, M):-
    move(State, Next, M, N),
    \+ member([Next,_], Closed).

getState([CurrentNode|Rest], CurrentNode, Rest).

addChildren(Children, Open, NewOpen):-
    append(Children, Open, NewOpen).

% MOVES 

move(State, Next, M, N):-
    left(State, Next, M);
    right(State, Next, M);
    up(State, Next, M);
    down(State, Next, M, N).

left(State, Next, M):-
    nth0(0, State, Index),
    nth0(1, State, Color),
    NewIndex is Index - 1,
    not(NewIndex < 0),
    not(0 is ((Index) mod M)),
    append([NewIndex, Color], [], Next).

right(State, Next, M):-
    nth0(0, State, Index),
    nth0(1, State, Color),
    NewIndex is Index + 1,
    not(0 is (NewIndex mod M)),
    append([NewIndex, Color], [], Next).

up(State, Next, M):-
    nth0(0, State, Index),
    nth0(1, State, Color),
    NewIndex is Index - M,
    NewIndex > -1,
    append([NewIndex, Color], [], Next).

down(State, Next, M, N):-
    nth0(0, State, Index),
    nth0(1, State, Color),
    NewIndex is Index + M,
    NewIndex < M*N,
    append([NewIndex, Color], [], Next).

printSolution([State, [null, null]],_):-
	write(State), nl.
printSolution([State, Parent], Closed):-
    member([Parent, GrandParent], Closed),
    printSolution([Parent, GrandParent], Closed),
    write(State), nl.
