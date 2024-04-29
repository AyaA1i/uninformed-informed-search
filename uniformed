search(Open, Closed, _, M, _):-
    getState(Open, [CurrentState,Parent], _),
    checkGoalState(CurrentState, M), !, 
    write("Search is complete!"), nl,
    printSolution([CurrentState,Parent], Closed).

search(Open, Closed, N, M, Input):-
    getState(Open, CurrentNode, TmpOpen),
    getAllValidChildren(CurrentNode, TmpOpen, Closed, N, M, Input, Children), 
    addChildren(Children, TmpOpen, NewOpen),
    append(Closed, [CurrentNode], NewClosed),
    search(NewOpen, NewClosed, N, M, Input).

getAllValidChildren(Node, Open, Closed, N, M, Input, Children):-
    findall(Next, getNextState(Node, Open, Closed, Next, N, M, Input), Children).

getNextState([State,_], Open, Closed, [Next,State], N, M, Input):-
    move(Input, State, Next, M, N),
    \+ member([Next,_], Open),
    \+ member([Next,_], Closed).

getState([CurrentNode|Rest], CurrentNode, Rest).

addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).

printSolution([State, null], _):-
    write(State), nl.
printSolution([State, Parent], Closed):-
    member([Parent, GrandParent], Closed),
    printSolution([Parent, GrandParent], Closed),
    write(State), nl.

checkGoalState(CurrentState, M):-
    length(CurrentState, Length),
    Length2 is Length - 1,
    nth0(Length2, CurrentState, Element1),
    nth0(0, CurrentState, Element2),
    Element2 =:= Element1 - M.

% MOVES 

move(Input, State, Next, M, N):-
    left(Input, State, Next, M);
    right(Input, State, Next, M);
    up(Input, State, Next, M);
    down(Input, State, Next, M, N).

left(Input, State, Next, M):-
    last(State, Index),
    NewIndex is Index - 1,
    \+ NewIndex < 0,
    \+ 0 is ((Index) mod M),
    nth0(NewIndex, Input, Element),
    nth0(Index, Input, OldElement),
    Element = OldElement,
    append(State, [NewIndex], Next).

right(Input, State, Next, M):-
    last(State, Index),
    NewIndex is Index + 1,
    \+ 0 is ((NewIndex+1) mod M),
    nth0(NewIndex, Input, Element),
    nth0(Index, Input, OldElement),
    Element = OldElement,
    append(State, [NewIndex], Next).

up(Input, State, Next, M):-
    last(State, Index),
    NewIndex is Index - M,
    NewIndex > -1,
    nth0(NewIndex, Input, Element),
    nth0(Index, Input, OldElement),
    Element = OldElement,
    append(State, [NewIndex], Next).

down(Input, State, Next, M, N):-
    last(State, Index),
    NewIndex is Index + M,
    NewIndex < M*N,
    nth0(NewIndex, Input, Element),
    nth0(Index, Input, OldElement),
    Element= OldElement,
    append(State, [NewIndex], Next).
