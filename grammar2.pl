%%
%%  Prolog grammar for MI practical.
%% runs in sictstus v4 on DICE, and swipl 7.4.
%% See end of miNew.pl for documentation on how to use this
%% to check and generate melodies according to the grammar.
%% This file should be in same directory as readfile.pl and miNew.pl
%%
%% Start prolog and consult this file:
%%
%% ?- [grammar].
%%

%% special treatment for sum_int/3

:- multifile sum_int/3.
:- dynamic sum_int/3.
:- consult( [miNew, readfile] ).

% make various grammar categories dynamic;
% need to make similar declarations for any new grammar symbols
% that are introduced.

:- dynamic tune/2, line/2, bar1/2, bar/2, bar4/2, tonic/2, dominant/2.
:- dynamic tonicA/2,tonicB/2,tonicC/2,tonicD/2.
:- dynamic subdominant/2, ton/3, by_ton/3, dom/3, by_dom/3, subd/3, by_subd/3.
:- dynamic tonicA/1, tonicB/2, tonicC/2, tonicD/2.

% grammar allowing rhythmic variation

tune --> line, line.
line --> bar1, bar, bar, bar4.

bar1 --> tonic.
bar  --> tonic.
bar  --> subdominant.
bar  --> dominant.
bar4 --> tonic.

tonic --> tonicA.
tonic --> tonicB.
tonic --> tonicC.
tonic --> tonicD.

% parametrised by duration;
% unary notation allows randomisation of output to work:
% " s(1) " for 2, "s(s(1))" for 3, etc (up to 6).
%
%  Use constraints on durations using special sum_int/2 predicate as shown
%  in curly braces " {..} ". 

tonicA --> ton(1),by_ton(1),ton(1),ton(1),by_ton(1),ton(1),[bl].
tonicB --> ton(1),by_ton(1),ton(1), ton(A),ton(B), [bl],
	   { sum_int(A, B, s(s(1))) }.
tonicC --> ton(s(1)),by_ton(1),ton(s(s(1))),[bl].
tonicD --> ton(1),by_ton(1),ton(1),ton(s(s(1))),[bl].
dominant --> dom(1),by_dom(1),dom(1),dom(1),by_dom(1),dom(1),[bl].
subdominant --> subd(1),by_subd(1),subd(1),subd(1),by_subd(1),subd(1),[bl].

ton(X) --> [a(X)].
ton(X) --> [d(X)].
ton(X) --> [f(X)].
ton(X) --> ['A'(X)].
by_ton(X) --> [b(X)].
by_ton(X) --> ['B'(X)].
by_ton(X) --> [e(X)].
by_ton(X) --> ton(X).

dom(X) --> [a(X)].
dom(X) --> [c(X)].
dom(X) --> [e(X)].
dom(X) --> ['A'(X)].
by_dom(X) --> [f(X)].
by_dom(X) --> dom(X).

subd(X) --> [b(X)].
subd(X) --> [d(X)].
subd(X) --> [g(X)].
subd(X) --> ['B'(X)].
by_subd(X) --> [e(X)].
by_subd(X) --> subd(X).

%% end of grammar
