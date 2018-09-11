%  for music parsing

% runs under SWI prolog (swipl);
% and runs under sicstus on DICE
% 
% readfile.pl and grammar.pl should be in the same directory.
%
%  example input in file jig.abc using abc notation.
%
% show results up to 100 depth termoos:

?- set_prolog_flag(toplevel_print_options,[quoted(true),numbervars(true),portrayed(true),max_depth(100)]).

:- multifile user:sum_int/3.
:- dynamic user:sum_int/3.
	
%% Need addition table explicitly up to 6 (= s(s(s(s(s(1))))) ),
%% to allow random generation to work.
sum_int( 1, 1, s(1) ).
sum_int( s(1), 1, s(s(1)) ).
sum_int( 1, s(1), s(s(1)) ).
sum_int( 1, s(s(1)), s(s(s(1))) ).
sum_int( s(1), s(1), s(s(s(1))) ).
sum_int( s(s(1)), 1, s(s(s(1))) ).
sum_int( 1, s(s(s(1))), s(s(s(s(1)))) ).
sum_int( s(1), s(s(1)), s(s(s(s(1)))) ).
sum_int( s(s(1)), s(1), s(s(s(s(1)))) ).
sum_int( s(s(s(1))), 1, s(s(s(s(1)))) ).
sum_int( 1, s(s(s(s(1)))), s(s(s(s(s(1))))) ).
sum_int( s(1), s(s(s(1))), s(s(s(s(s(1))))) ).
sum_int( s(s(1)), s(s(1)), s(s(s(s(s(1))))) ).
sum_int( s(s(s(1))), s(1), s(s(s(s(s(1))))) ).
sum_int( s(s(s(s(1)))), 1, s(s(s(s(s(1))))) ).

% Next procedure for random generation of melody following grammar;
%  NB: only works when each grammar symbol has a corresponding
%  "dynamic" declaration, as given above for the initial grammar

% randomised meta-interpreter
% runs under Sicstus 4.2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% random path through the search space --
% no back-tracking!

:- use_module(library(random)).
:- use_module(library(lists)).

ran_solve( true ) :- !.
ran_solve( (A,B) ) :- !, ran_solve(A), ran_solve(B).
ran_solve( P ) :- predicate_property(P, built_in), !, call(P).
ran_solve( HH ) :-  random_clause( HH, B ),
                    ran_solve(B).
random_clause( H, B ) :- setof( (H,B), clause(H,B), S),
                         random_pick( (H,B), S).
random_pick(X,List) :- length(List,N), rp(X,List,N).
rp(X,[X],_) :- !.
rp(X,List,N) :- random(0,N,Nth), nth0(Nth,List,X).

% special version for grammar top-level symbol.

random_tune( X, Y ) :- ran_solve( tune(X,Y) ).

% procedures to output query results to file
%

saveResult(Result,File) :-
    tell(File), write(Result), nl, told, nl,
    write('Result saved in '), write(File), write(' .'), nl.

% how to use:
%  the second argument is normally a sequence of alphanumeric characters,
% starting with a lower case letter;  to do anything else, put
% single quotes before and after the filename: eg  '~/results/r1' .
%
% for the first argument, use the variable that you use for the
% result you are computing, as below.

%  to generate new random melody from grammar, using
%  abc header from some appropriate abc melody:
% 

make_new_with_header( AbcFile, NewAbcFile ) :-
      get_write_header( AbcFile, NewAbcFile ),
      random_tune(X,[]),
      write_abc( NewAbcFile, X ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sample queries:

% to check input is parsed by this grammar:
% ?-  get_notes('jig.abc',Input), tune(Input,[]).
%  Input = [d(1),f(1),f(1),a(1),f(1),f(1),bl,a(1),b(1),...
%
% for generation:
%
% |  ?- tune(X,[]).
% X = [a(1),b(1),a(1),a(1),b(1),a(1),bl,a(1),b(1),a(1),a(1),...

% to call randomised:

% | ?- random_tune(X,[]).
% X = [a(1),'B'(1),f(1),a(1),'A'(1),d(1),bl,'B'(1),e(1),'B'(1),d(1),e(1), ...

% ?- random_tune(X,[]), saveResult(X,result1).
%
% Result saved in result1 .

% to output as abc;  need appropriate abc header, eg from some given abc file;
%
% | ?- get_write_header( 'jig.abc', 'new.abc' ), random_tune(X,[]),
%             write_abc( 'new.abc', X ).
% X = [d(1),e(1),d(1),'A'(1),e(1),a(1),bl,g(1),e(1),d(1),...
%
%  -- or more simply:
% | ?- make_new_with_header( 'jig.abc', 'new.abc' ).
%
%  Now the output file in abc can be converted to lilypond notation
%  using abc2ly,  and typeset using the command
%
% =>   lilypond new.ly
%
%  Now the music can be viewed, and played with the generated midi.
%
%   abc2ly and lilypond are neither installed on DICE,
%   but are freely available.
