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

:- multifile sum_int/3. %if
:- dynamic sum_int/3.
:- consult( [miNew, readfile] ). %load these 2 file

% make various grammar categories dynamic;
% need to make similar declarations for any new grammar symbols
% that are introduced.

:- dynamic tune/4, line/4, bar1/1, bar/6, bar4/1, tonic/2, dominant/2.
:- dynamic tonicA/2,tonicB/2.
:- dynamic subdominant/2, ton/3, by_ton/3, dom/3, by_dom/3, subd/3, by_subd/3.
:- dynamic tonicA/1, tonicB/2.
:- dynamic dominant/2, mediant/3, superton/2 ,submediant/3.
:- dynamic by_sup/1, by_med/1,by_subm/1.

% grammar allowing rhythmic variation

tune --> line, line ,line, line.
line --> bar1, bar, bar, bar4.

bar1 --> tonic.
bar  --> tonic.
bar  --> subdominant.
bar  --> dominant.
bar  --> mediant.
bar  --> submediant.
bar  --> superton.
bar4 --> tonic.

tonic --> tonicA.
tonic --> tonicB.
superton --> supertonA.
superton --> supertonB.
dominant --> dominantA.
dominant --> dominantB.
mediant --> mediantA.
mediant --> mediantB.
subdominant --> subdominantA.
submediant --> submediantA.
submediant --> submediantB.


tonicA --> ton(1),by_ton(1),ton(1),by_ton(s(1)),[bl].
tonicB --> ton(1),by_ton(1),ton(1), ton(s(1)),ton(1), [bl].

supertonA --> supert(1),supert(s(1)), subd(1),subd(1),by_subd(1),[bl].
supertonB --> supert(s(1)),by_sup(1), dom(1),by_dom(s(1)),[bl].

mediantA --> med(s(s(1))), by_med(1), med(1),by_med(1),by_med(1),[bl].
mediantB --> med(1), med(1), med(1), supert(s(1)),by_sup(1),[bl].

subdominantA --> subd(1),by_subd(1),subd(1),supert(1),supert(1),supert(1),[bl].

dominantA --> dom(1),by_dom(1),supert(1),dom(1),supert(1),ton(1),[bl].
dominantB --> dom(1),dom(s(1)), ton(1),ton(1),by_ton(1),[bl].

submediantA --> subd(s(s(1))),dom(1),by_dom(1),dom(1),[bl].
submediantB --> subm(1),subm(1),by_subm(1),subd(1),subd(1),by_subd(1),[bl].



ton(X) --> [d(X)].
ton(X) --> [f(X)].
ton(X) --> [a(X)].
ton(X) --> ['A'(X)].
by_ton(X) --> [e(X)].
by_ton(X) --> [g(X)].

supert(X) --> [e(X)].
supert(X) --> [g(X)].
supert(X) --> [b(X)].
supert(X) --> ['B'(X)].
by_sup(X) --> [f(X)].
by_sup(X) --> [a(X)].

med(X) --> [f(X)].
med(X) --> [a(X)].
med(X) --> [c(X)].
med(X) --> ['A'(X)].
by_med(X) --> [g(X)].
by_med(X) --> [b(X)].


subd(X) -->[d(X)].
subd(X) -->[g(X)].
subd(X) -->[b(X)].
subd(X) -->['B'(X)].
by_subd(X) -->[f(X)].
by_subd(X) -->[a(X)].

dom(X) -->[a(X)].
dom(X) -->[c(X)].
dom(X) -->[e(X)].
dom(X) -->['A'(X)].
by_dom(X) --> [b(X)].
by_dom(X) --> [g(X)].


subm(X) -->[b(X)].
subm(X) -->[d(X)].
subm(X) -->[f(X)].
subm(X) -->['B'(X)].
by_subm(X) --> [c(X)].
by_subm(X) --> [a(X)].


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task one: from original grammar
%the first 2 accepted examples:

%X:1
%T:based on: Paddy O'Rafferty2
%C:Trad.
%M:6/8
%K:D
%Q:3/8=80
%A1e1A1A3|A1c1c1c1c1c1|A2A1a3|A1e1d1d3|f2e1a3|A1a1a1A1f1a1|b1e1g1g1B1b1|d1B1A1A1d2|


%X:2
%T:based on: Paddy O'Rafferty2
%C:Trad.
%M:6/8
%K:D
%Q:3/8=80
%f2b1f3|A2A1d3|A1A1e1A1f1e1|A2B1d3|A1e1a1A3|A1e1A1a2a1|c1A1c1e1c1c1|A1d1a1f1e1a1|


%the two unaccepted examples:

% In the first unaccepted example, I change the note in the 1st bar which
% is not includedin tonic, and I also revise the rhythm of the first note
% in the second bar and the keyof the whole melody which is not a
% grammatical music clips. X:3 T:Unaccepted example 1 C:Trad. M:6/8 K:G
% Q:3/8=80
% a2b1f3|A2A1d3|A3A1e1A1f1e1|A2B1d3|A1e1a1A3|A1e1A1a2a1|c1A1c1e1c1c1|A1d1a1f1e1a1|
%

% In the second unaccepted example, I add a three-note chord which cannot
% be parse by this grammar system, and also I change the time signature
% and the tempo to 90, it seems also that the parsing break down.

%X:4
%T:Unaccepted example 1
%C:Trad.
%M:3/7
%K:D
%Q:3/8=90
%[Adf]1e1A1A3|A1c1c1c1c1c1|A2A1a3|A1e1d1d3|f2e1a3|A1a1a1A1f1a1|b1e1g1g1B1b1|d1B1A1A1d2|



%Task two: from new grammar

% Jig dance music, as a kind of genre of Celtic music, is a form of
% lively folk dance tune in compound metre full of Scottish and Irish
% flavors. The jig music field is very expandable with generally cheerful
% rhythm. After listening to traditional jig music, I make a new
% grammar(but with the same key and 6/8 time signature as most of jig
% musics are based on this time signature. Firstly, I change the
% structure of the rhythm to make more variation.(But based on the same
% time signature, the variations here are not very notable. Secondly, in
% addition to the given harmonies. I expend some additional harmonies
% (without Subtonic and Leading as I think that the frequencies of these
% two harmonies are less than others. Thirdly, in a particular harmony, I
% change the original three-note harmony to 4-note harmony by broader
% notion notes (as this kind of grammar system cannot support sharps and
% flats, I did not gain some chance to add more complicated harmonies.)
% Finally, in order to make more than one harmony per bar, I adjust the
% structure of rhythm variation.



%Example 1:
%X:5
%T:Jig:New grammar 1
%C:Trad.
%M:6/8
%K:D
%Q:3/8=80
%a1g1d1e2|c3b1a1g1b1|b3e1g1c1|d1e1d1A2f1|
%A1e1a1d2f1|f3g1c1g1b1|d1f1a1b1g1f1|d1e1a1a2f1|
%a1e1A1e2|e1b1g1c1b1a1|e1b1e1A1B1d1|A1e1f1e2|
%A1g1a1e2|b3e1g1e1|d3e1b1a1|d1g1a1e2|

%Example 2:
%X:6
%T:Extend 2
%C:Trad.
%M:6/8
%K:D
%Q:3/8=80
%a1e1d1f2f1|c1e2f1A1e1|b1f1B1B1b1g1|d1e1f1g2|
%A1g1A1A2A1|f1e1a1A2f1|a1c1A1B2a1|a1e1a1g2|
%A1e1f1g2|e2f1A1g2|a1a1f1b2f1|a1e1A1d2d1|
%f1e1d1d2d1|c1A1a1B2f1|B2f1e1g2|a1e1f1e2|
%% end of grammar
