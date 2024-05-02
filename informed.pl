search(Open, Closed,M,N, Goal):-
    getBestState(Open, [Index,NumList,Parent,G,H,F], _), % Step 1
    Index = Goal, % Step 2
    write("Search is complete!"), nl,
    printSolution([Index,NumList,Parent,G,H,F],M,N, Closed), !.

search(Open, Closed,M,N, Goal):-
    getBestState(Open, CurrentNode, TmpOpen),
    getAllValidChildren(CurrentNode,TmpOpen,Closed,M,N,Goal,Children), % Step 3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % Step 5.1
    search(NewOpen, NewClosed,M,N, Goal). % Step 5.2

% Implementation of step 3 to get the next states
getAllValidChildren(Node, Open, Closed,M,N, Goal, Children):-
    findall(Next, getNextState(Node,Open,Closed,M,N,Goal,Next),Children).
getNextState([Index,NumList,_,G,_,_],Open,Closed,M,N,Goal,[Next,NumList,Index,NewG,NewH,NewF]):-
    move(Index, NumList,M,N, Next, MoveCost),
    calculateH(Next,Goal,N, NewH),
    NewG is G + MoveCost,
    NewF is NewG + NewH,
    ( not(member([Next,_,_,_,_,_], Open)) ; memberButBetter(Next,Open,NewF)),
    ( not(member([Next,_,_,_,_,_],Closed)); memberButBetter(Next,Closed,NewF)).
calculateH(Next, Goal,N, NewH):-
    Row1 is Next // N,
    Col1 is Next mod N,
    Row2 is Goal // N,
    Col2 is Goal mod N,
    NewH is abs(Row1 - Row2) + abs(Col1 - Col2).

memberButBetter(Next, List, NewF):-
    findall(F, member([Next,_,_,_,_,F], List), Numbers),
    min_list(Numbers, MinOldF),
    MinOldF > NewF.
% Implementation of addChildren and getBestState
addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).
getBestState(Open, BestChild, Rest):-
    findMin(Open, BestChild),
    delete(Open, BestChild, Rest).
% Implementation of findMin in getBestState determines the search alg.
% Greedy best-first search
findMin([X], X):- !.
findMin([Head|T], Min):-
    findMin(T, TmpMin),
    Head = [_,_,_,_,_,HeadF],
    TmpMin = [_,_,_,_,_,TmpF],
    (TmpF < HeadF -> Min = TmpMin ; Min = Head).
% Instead of adding children at the end and searching for the best
% each time using getBestState, we can make addChildren add in the
% right place (sorted open list) and getBestState just returns the
% head of open.

% Implementation of printSolution to print the actual solution path
printSolution([Index,_, null, _, _, _],_,N,_):-
    Row is Index // N,
    Col is Index mod N,
    write([Row,Col]), nl.
printSolution([Index, _, Parent, _, _, _],M,N, Closed):-
    member([Parent,_, GrandParent, PrevG, Ph, Pf], Closed),
    printSolution([Parent,_, GrandParent, PrevG, Ph, Pf],M,N, Closed),
    Row is Index // N,
    Col is Index mod N,
    write([Row,Col]), nl.
move(Index, NumList,M,N,Next,1):-
    left(Index, NumList,M,N,Next); right(Index, NumList,M,N,Next);
    up(Index, NumList,M,N,Next); down(Index, NumList,M,N,Next).
left(Index, NumList,M,_,Next):-
    nth0(Index, NumList, Color),
    not(0 is Index mod M),
    NewIndex is Index - 1,
    nth0(NewIndex, NumList,NewColor),
    Color = NewColor,
    Next is NewIndex.

right(Index, NumList,M,N,Next):-
    nth0(Index, NumList, Color),
    not(N-1 is Index mod M),
    NewIndex is Index + 1,
    nth0(NewIndex, NumList,NewColor),
    Color = NewColor,
    Next is NewIndex.

up(Index, NumList,_,N,Next):-
    nth0(Index, NumList, Color),
    Index >= N,
    NewIndex is Index - N,
    nth0(NewIndex, NumList,NewColor),
    Color = NewColor,
    Next is NewIndex.

down(Index, NumList,M,N,Next):-
    nth0(Index, NumList, Color),
    Index < (M*N)-N,
    NewIndex is Index + N,
    nth0(NewIndex, NumList,NewColor),
    Color = NewColor,
    Next is NewIndex.
