## Linear Programming Lab Project

_By James Pretorius_

Linear Programming is a method to find the optimal solution to a function constrained by a system of linear equations. Linear Programming is often used to determine how to best allocate limited resources to minimize or maximize their effects. For instance, in Problem 1, we are asked to determine the minimum possible cost of providing blood given a list of constraints. This cost will be the sum of the costs of the individual blood types where the cost for an individual blood type equals the pints of blood used multiplied by the dollars per pint. For instance, type A blood costs 1\$ per pint, so its cost will be $1T_{A}$. In mathematical form, we get the following for the total cost.

$$P_{cost} = 1T_{A} + 2T_{AB} + 4T_{B} + 5T_{O}$$

We call this the **objective function** because it is the function we are trying to minimize. When it is minimized, we call the smallest result of this function we call the **optimal solution**. This is what we are trying to find. However, we cannot simply use zero pints of blood for a cost of zero dollars as the patients require a certain amount of pints according to their blood types. We call these requirements **constraints**. We can express these constraints mathematically. For instance, patient one needs two pints of type A blood. Type A blood can receive type A blood, or type O blood. Thus the two pints that patient one needs will be some combination of type A blood and type O blood. Mathematically we can express this combination as $T_{A} + T_{O} = 2$. All the patient's constraints are as follows.

$$
\begin{matrix}
 T_{A} + T_{O} = 2 \\
T_{AB} + T_{A} + T_{B} + T_{O} = 3 \\
T_{B} + T_{O} = 1 \\
T_{O} = 2 \\
T_{A} + T_{O} = 3 \\
T_{B} + T_{O} = 2 \\
T_{AB} + T_{A} + T_{B} + T_{O} = 1 \\
\end{matrix}
$$

We are also constrained by the amount of blood we have. We have a total of seven pints of type A blood so we must use seven or less pints of type A blood. We can express this mathematically as $T_{A} \leq 7$. The supply constraints form the following equations.

$$
\begin{matrix}
 T_{A} \leq 7 \\
T_{AB} \leq 6 \\
T_{B} \leq 4 \\
T_{O} \leq 5 \\
\end{matrix}
$$

Lastly, we are constrained by positive pints as it is not possible to give somebody a negative amount of blood.

$$
\begin{matrix}
 T_{A} \geq 0 \\
T_{AB} \geq 0 \\
T_{B} \geq 0 \\
T_{O} \geq 0 \\
\end{matrix}
$$

Combined, the objective function and linear constraints form the linear programming problem.

If a solution satisfies all of a system's constraints, we call it a **feasible solution** (Hillier, p. 35). The set of all feasible solutions forms a **feasible set**. Geometrically, this set will form a region with boundary lines and corners where those lines connect. Our **optimal solution** will be one of these corners. If the amount of variables is small, it is possible to check every corner until the solution is found. However, as the amount of variables grows, the amount of corners grows with factorial complexity (Gilbert, p. 485). With a large number of variables, checking every corner is unrealistic.

The **simplex method** is a method of efficiently solving Linear Programming problems without checking every corner. Instead it uses some properties of a corner and its neighboring corners to quickly determine an optimal solution. Corners of a feasible set are related algebraically to neighboring corners. Each corner will have two constraint variables that differ from a neighboring corner. One of the variables will differ by becoming zero when it was previously a positive value, and the other will differ by becoming a positive value when it was previously zero (Gilbert, p. 486). Thus if you want to move corners, you make one zero variable become positive and one positive variable become zero (Gilbert, p. 486). The variable that becomes zero is called the **leaving variable**. The variable that becomes positive is called the **entering variable** (Gilbert, p. 486). It is possible to determine if an adjacent corner is closer or further to the optimal solution than the adjacent corner. Thus if done right, you can always move to an adjacent corner that is closer to the optimal solution. Moving from corner to corner, closer and closer to the optimal solution is the core idea of the simplex method. Once there is no better corner to move to, you have found the optimal solution (Gilbert, p. 486).

This moving and checking will be done by matrices in Octave using principles of linear algebra. We will find an optimal solution to the following problem (Problem 2). Minimize:

$$- x_{1} + x_{2} + x_{3} = z$$

Subject to constraints:

$$
\begin{matrix}
 & & x_{1} - 2x_{2} + x_{3} & \leq 11 \\
 & & - 2x_{1} + x_{3} & = 1 \\
 & & x_{1} & \geq 0 \\
 & & x_{2} & \geq 0 \\
 & & x_{3} & \geq 0 \\
\end{matrix}
$$

First, we must convert our equations inequalities to matrices which means the inequalities need to become equalities. We do this by adding a variable that represents the difference between the left-hand side and right-hand side of an equation (Hillier, p. 98). We call this kind of variable a **slack variable**. Thus the first constraint becomes the following.

$$x_{1} - 2x_{2} + x_{3} + s_{1} = 11$$

Although it already is an equality, we need to add a variable to the second constraint. We will use this variable to move to an initial corner in the feasible region (Brilliant) as we do not know the numeric value of a corner point to start on. We call this variable an **artificial variable**. The second constraint becomes the following.

$$- 2x_{1} + x_{3} + a_{1} = 1$$

For the last three constraints, since they are greater than or equal to inequalities, we add a negative slack variable and an artificial variable to convert them to equalities.

$$
\begin{matrix}
 & & x_{1} + s_{2} + a_{2} & = 0 \\
 & & x_{2} + s_{3} + a_{3} & = 0 \\
 & & x_{3} + s_{4} + a_{4} & = 0 \\
\end{matrix}
$$

We also need to add these new slack and artificial variables to the objective function, and while we are at it will move $z$ to the left-hand side of the equation. We also add a coefficient $M$ to our artificial variables. This variable represents an arbitrarily large number (Hillier, p. 117) that will help us in finding a corner to start on.

$$- z - x_{1} + x_{2} + x_{3} + s_{1} + s_{2} + s_{3} + s_{4} + Ma_{1} + Ma_{2} + Ma_{3} + Ma_{4} = 0$$

Altogether we have the following.

$$
\begin{matrix}
 z & - x_{1} & + x_{2} & + x_{3} & + s_{1} & + s_{2} & + s_{3} & + s_{4} & + Ma_{1} & + Ma_{2} & + Ma_{3} & + Ma_{4} & = 0 \\
 & x_{1} & - 2x_{2} & + x_{3} & + s_{1} & & & & & & & & = 11 \\
 & - 2x_{1} & & + x_{3} & & & & & + a_{1} & & & & = 1 \\
 & x_{1} & & & & + s_{2} & & & & + a_{2} & & & = 0 \\
 & & x_{2} & & & & + s_{3} & & & & + a_{3} & & = 0 \\
 & & & x_{3} & & & & + s_{4} & & & & + a_{4} & = 0 \\
\end{matrix}
$$

We can now convert this to an augmented matrix in Octave using 100 as a value for M.

    %      z  x1  x2  x3  s1  s2  s3  s4    a1    a2    a3    a4   b
    Ab = [-1  -1   1   1   0   0   0   0   100   100   100   100   0 ;
           0   1  -2   1   1   0   0   0     0     0     0     0  11 ;
           0  -2   0   1   0   0   0   0     1     0     0     0   1 ;
           0   1   0   0   0  -1   0   0     0     1     0     0   0 ;
           0   0   1   0   0   0  -1   0     0     0     1     0   0 ;
           0   0   0   1   0   0   0  -1     0     0     0     1   0 ]

Our first step towards a solution is to move to an initial corner. To do this we use Gaussian elimination to remove the artificial variables from Row 1 (Brilliant). For instance, we remove $a_{1}$ by subtracting $1000 \times Row\ 3$ from Row 1*.* In Octave we write the following.

    Ab(1, :) -= 1000*Ab(3, :)

Repeat this for every artificial variable in Row 1 and we get the following.

    -1  99  -99  -199  0  100  100  100  0  0  0  0  -100
     0   1   -2     1  1    0    0    0  0  0  0  0    11
     0  -2    0     1  0    0    0    0  1  0  0  0     1
     0   1    0     0  0   -1    0    0  0  1  0  0     0
     0   0    1     0  0    0   -1    0  0  0  1  0     0
     0   0    0     1  0    0    0   -1  0  0  0  1     0

Now we are at a corner, we move to the adjacent corner that is closer to the optimal solution. To do this we first find the coefficient in Row 1 that is the most negative. This is our entering variable (Hillier, p 109). In Octave we use the `min` function to do this, skipping the `z` column by replacing it with `0`.

    [minValue, minCol] = min([0 Ab(1, 2:end-1)])

Now we search for the leaving variable. For each row, we find the ratio between the value in the current column and the value in the _b_ column (Hillier, p 109).

    rowRatio = Ab(currRow, bCol)/Ab(currRow, minCol);

Then the row with the smallest positive ratio. Row 6 is selected because `0/1=0`. In Octave we find this with a simple loop. Then we divide Row 6 by itself such that the value at `minCol` becomes 1 (Hillier, p 109).

    Ab(Row6, :) /= Ab(Row6, minCol);

Then we use Gaussian elimination to make every other value in `minCol` zero (Hillier, p 109). In Octave, for every row we divide Row 6 at `minCol` by the current value in the current row to get a multiplier.

    multiplier = Ab(currRow, col)/Ab(Row6, col);

Then we subtract Row 6 times this multiplier from the current row.

    Ab(currRow, :) -= multiplier*Ab(Row6, :);

After eliminating every other column in `minRow`, we get the following matrix.

    -1  99  -99  0  0  100  100  -99  0  0  0  199  -100
     0   1   -2  0  1    0    0    1  0  0  0   -1    11
     0  -2    0  0  0    0    0    1  1  0  0   -1     1
     0   1    0  0  0   -1    0    0  0  1  0    0     0
     0   0    1  0  0    0   -1    0  0  0  1    0     0
     0   0    0  1  0    0    0   -1  0  0  0    1     0

These eliminations moved us to an adjacent corner that is closer to the optimal solution. Starting from finding the most negative coefficient in Row 1, we repeat this elimination process until there are no negative values in Row 1. Then we have arrived at corner of the optimal solution.

    -1  0  0  0  0   1   1  0  99  99  99  100  -1
     0  0  0  0  1   3  -2  0  -1  -3   2    0  10
     0  0  0  0  0  -2   0  1   1   2   0   -1   1
     0  1  0  0  0  -1   0  0   0   1   0    0   0
     0  0  1  0  0   0  -1  0   0   0   1    0   0
     0  0  0  1  0  -2   0  0   1   2   0    0   1

Now we find the solution. First we find the columns with only one value (The Big M Method). In Octave we loop through the columns checking if `nnz(currCol)` equals one. For example Column 2 only has a value in Row 4. For the column, we divide it into the _b_ value in that same row. For Column 2, a _b_ value of zero divided by one equals zero. Since Column 2 corresponds to $x_{1}$, $x_{1}$ equals zero. In Octave we write the following.

    x1 = Ab(varRow, bCol)/Ab(varRow, oneVarCol);

For the rest of the columns, we set their corresponding values to zero. The result is the following optimal solution.

      z x1 x2 x3  s1 s2 s3 s4 a1 a2 a3 a4
    [ 1  0  0  1  10  0  0  1  0  0  0  0 ]'

This means the minimum $z$ value is $1$ when $x_{1} = 0$, $x_{2} = 0$, and $x_{3} = 1$. This is the optimal solution for Problem 2.

## References

Hillier, Frederick S., and Gerald J. Lieberman. _Introduction to Operations Research_. Tenth edition, McGraw-Hill, 2015.

"Linear Programming." _Brilliant.Org_, https://brilliant.org/wiki/linear-programming/. Accessed 25 Nov. 2023.

Strang, Gilbert. _Introduction to Linear Algebra_. 5th edition, Cambridge press, 2016.

_The Big M Method : Maximization with Mixed Constraints_. Directed by patrickJMT, 2016. _YouTube_, https://www.youtube.com/watch?v=upgpVkAkFkQ.
