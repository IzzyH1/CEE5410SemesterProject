$ontext
CEE 6410 Fall 2026

Problem Description:


Isabel I. Hinton, Madison Wilcox
Date
isabel.hinton@usu.edu, a02407759@usu.edu
$offtext

*1. Define the sets
SETS res reservoirs /FlamingGorge, Navajo, BlueMesa, LakePowell/
     t months /1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12/;


*2. Define the input data
PARAMETERS
$onText
This section may be easier to simulate in python or R and then import into GAMS

Choose a random inflow scenario from the range ()

Define range of possible initial storages for each reservoirs
Table                   reservoirs
min initial storage
max initial storage

Choose a random initial storage scenario from each range for each reservoir

Import csv of reservoir unregulated inflows as a table of inflows at each reservoir sorted by year

similar year is equal to the year which minimizes chosen inflow - unregulated inflow at Lake Powell

unregulated inflow at the upstream reservoirs are the inflows in "similar year"

$offText
Table inflow_prop proportion of inflow occuring monthly
        1       2       3       4       5       6       7       8       9       10      11      12
prop    .0587   .0579   .0735   .0686   .1217   .1575   .0749   .1112   .0934   .0605   .0686   .0535

$onText
Table res_properties defines reservoir properties
            Hydropower conversion       
reservoirs
$offText




*3. Define the decision variables
VARIABLES
   X(l,t)  Flow or storage in network at location l at time t (volume)
   FBen(f)   Total benefits at location f ($)
   TotalBen    Total benefits across all locations ($)

Positive Variables X;

*4. Define the equations
EQUATIONS




