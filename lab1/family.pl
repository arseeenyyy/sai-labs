% база знаний семейное дерево

% 1. Объекты (члены семьи)

person(dmitrii). 
person(natalia).
person(ludmila). 
person(misha).
person(luybov).
person(georgii).
person(timothy).
person(egor).
person(maria). 
person(arseniy).
person(anastasiya).
person(evgeniya).
person(artem).
person(svetlana). 
person(evgenii). 
person(ivan).
person(olga).
person(alexey).
person(anna).
person(sergey).
person(vera).
person(victoriya).
person(sofiya).
person(gleb).
person(ruslan).
person(daniil).
person(daria).
person(matvei).
person(karina). 
person(anton).

male(dmitrii).
male(misha).
male(georgii).
male(timothy).
male(egor).
male(arseniy).
male(artem).
male(evgenii).
male(ivan).
male(alexey).
male(sergey).
male(gleb).
male(ruslan).
male(daniil).
male(matvei).
male(anton).

female(natalia).
female(ludmila).
female(luybov).
female(maria).
female(anastasiya).
female(evgeniya).
female(svetlana).
female(olga).
female(anna).
female(vera).
female(victoriya).
female(sofiya).
female(daria).
female(karina).

% факты о рождении
born(dmitrii, 1969). 
born(natalia, 1972).
born(ludmila, 1950).
born(misha, 1947). 
born(luybov, 1949).
born(georgii, 1945).
born(timothy, 2002).
born(egor, 1996). 
born(maria, 2005).
born(arseniy, 2005).
born(anastasiya, 1999).
born(evgeniya, 1985). 
born(artem, 1985).
born(svetlana, 1975). 
born(evgenii, 1975). 
born(ivan, 2002). 
born(olga, 1999). 
born(alexey, 2001). 
born(anna, 2002). 
born(sergey, 2012). 
born(vera, 2015). 
born(victoriya, 1975). 
born(gleb, 1972). 
born(sofiya, 1997). 
born(karina, 2000). 
born(daniil, 2001). 
born(oleg, 2023). 
born(daria, 2024). 
born(matvei, 2025).  
born(anton, 2025). 


died(misha, 2017).
died(georgii, 2018). 

married(dmitrii, natalia, 1996).
married(misha, ludmila, 1970).
married(georgii, luybov, 1968).
married(timothy, anastasiya, 2024). 
married(arseniy, maria, 2024).
married(artem, evgeniya, 2010).
married(evgenii, svetlana, 2000).
married(gleb, victoriya, 1995).
married(daniil, karina, 2022). 
married(ivan, olga, 2022). 
married(alexey, anna, 2023). 


parent(georgii, dmitrii). 
parent(luybov, dmitrii).
parent(misha, natalia). 
parent(ludmila, natalia).
parent(misha, evgeniya).
parent(ludmila, evgeniya).
parent(georgii, svetlana).
parent(luybov, svetlana).
parent(dmitrii, egor).
parent(dmitrii, timothy). 
parent(dmitrii, arseniy).
parent(natalia, egor).
parent(natalia, timothy). 
parent(natalia, arseniy).
parent(evgenii, ivan).
parent(svetlana, ivan).
parent(evgenii, alexey).
parent(svetlana, alexey).
parent(evgeniya, sergey).
parent(artem, sergey).
parent(evgeniya, vera).
parent(artem, vera).
parent(misha, victoriya).
parent(ludmila, victoriya).
parent(gleb, sofiya).
parent(victoriya, sofiya).
parent(gleb, daniil).
parent(victoriya, daniil).
parent(daniil, oleg).
parent(victoriya, daniil).
parent(timothy, matvei). 
parent(anastasiya, matvei).
parent(daniil, anton).
parent(victoriya, anton).


% правило 1, жив ли человек в заданном году
alive_in_year(Person, Year) :-
    born(Person, BornYear),
    BornYear =< Year,
    (   died(Person, DiedYear)
    ->  Year =< DiedYear
    ;   true
    ).

% правило 2, на ком был женат XXX в заданном году 
spouse_in_year(Person, Spouse, Year) :-
    married(Person, Spouse, MarriedYear),
    MarriedYear =< Year,
    alive_in_year(Person, Year),
    alive_in_year(Spouse, Year).

spouse_in_year(Person, Spouse, Year) :-
    married(Spouse, Person, MarriedYear),
    MarriedYear =< Year,
    alive_in_year(Person, Year),
    alive_in_year(Spouse, Year).

% правило 3, кто умер до этого года  
died_before(Person, Year) :- 
    died(Person, DeathYear), 
    DeathYear < Year. 

% правило 4, кто умер в заданный год
died_in_year(Person, Year) :- 
    died(Person, DeathYear), 
    DeathYear == Year.

% правило 5, был ли родителем в заданном году 
parent_in_year(Parent, Child, Year) :- 
    parent(Parent, Child), 
    born(Child, ChildBornYear), 
    ChildBornYear =< Year,
    alive_in_year(Parent, Year).

% правило 6, возраст человека в заданном году
age_in_year(Person, Age, Year) :- 
    born(Person, BornYear), 
    alive_in_year(Person, Year), 
    Age is Year - BornYear. 

% правило 7, браки в заданном году
marriages_in_year(Husband, Wife, Year) :- 
    married(Husband, Wife, Year). 
% правило 8, братья/сестры
sibling(Sibling, Person) :-
    setof(Sib, 
          Parent^(parent(Parent, Person), parent(Parent, Sib), Person \== Sib),
          Sibs),
    member(Sibling, Sibs).

% правило 9, поиск брата
brother(Brother, Person) :- 
    sibling(Brother, Person),
    male(Brother).

% правило 10, поиск сестры 
sister(Sister, Person) :- 
    sibling(Sister, Person), 
    female(Sister).

% правило 11, grandparent 
grandparent(GrandParent, Grandchild) :- 
    parent(GrandParent, Parent), 
    parent(Parent, Grandchild).

% правило 12, бабушка
grandmother(Grandmother, Grandchild) :- 
    grandparent(Grandchild, Grandchild), 
    female(Grandmother).

% правило 12, дедушка 
grandfather(Grandfather, Grandchild) :-
    grandparent(Grandfather, Grandchild),
    male(Grandfather).

% правило 13, дядя
uncle(Uncle, Nephew) :-
    parent(Parent, Nephew),
    brother(Uncle, Parent).

% правило 14, тетя
aunt(Aunt, Nephew) :-
    parent(Parent, Nephew),
    sister(Aunt, Parent). 

% правило 15, племянник
nephew(Nephew, Relative) :-
    (brother(Relative, Parent); sister(Relative, Parent)), 
    parent(Parent, Nephew),
    male(Nephew).

% правило 16, племянница
niece(Niece, Relative) :-
    (brother(Relative, Parent); sister(Relative, Parent)), 
    parent(Parent, Niece),
    female(Niece).

% правило 17, двоюродный брат/сестра
cousin(Cousin, Person) :-
    parent(Parent1, Person),
    parent(Parent2, Cousin),
    sibling(Parent1, Parent2), 
    Person \== Cousin. 

% правило 18, совершеннолетний в заданном году
is_adult_in_year(Person, Year) :-
    age_in_year(Person, Age, Year),
    Age >= 18.

% правило 19, жили в одно время
alive_together(Person1, Person2) :-
    born(Person1, Born1), died(Person1, Died1),
    born(Person2, Born2), died(Person2, Died2),
    Born1 =< Died2, Born2 =< Died1.

% правило 20, старейший живущий
oldest_alive_in_year(Person, Year) :-
    alive_in_year(Person, Year),
    born(Person, BornYear),
    \+ (alive_in_year(Other, Year), born(Other, OtherBorn), OtherBorn < BornYear).

% правило 21, возраст при рождении 1 ребенка
age_at_first_child(Person, Age) :-
    parent(Person, Child),
    born(Child, ChildYear),
    born(Person, PersonYear),
    Age is ChildYear - PersonYear,
    \+ (parent(Person, OtherChild), born(OtherChild, OtherYear), OtherYear < ChildYear).

