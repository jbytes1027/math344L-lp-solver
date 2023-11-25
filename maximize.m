% by James Pretorius
% first row of inputs is objective function
function values = maximize(Ab, numChoice)
    format rat % debug
    Ab % debug

    % used to track where things are
    startColChoice = 2;
    startNonbasic = startColChoice + numChoice


    % GET LIST OF ARTIFICIAL COLS TO MOVE
    artificalCols = [];
    for col = startNonbasic:(size(Ab, 2) - 1)
        if Ab(1, col) != 0
            artificalCols = [artificalCols col];
        end
    end

    artificalCols % debug

    % MOVE M OUT OF ARTIFICIAL COLUMNS
    % loop through the artificial columns
    for artificialCol = artificalCols
        % find the row for artifical value of the current col
        for row = 2:size(Ab, 1)
            if Ab(row, artificialCol) ~= 0
                sourcePivotRow = row;
                break
            end
        end

        destPivotRow = 1; % objective function row
        Ab = pivot(destPivotRow, artificialCol, sourcePivotRow, Ab);
    end

    afterMoving = Ab % debug

    while true
        % FIND THE SMALLEST NEGATIVE COEFFICIENT IN THE OBJECTIVE FUNCTION (IN THE BASIC COLUMNS)
        [minValue, minCol] = min([0 Ab(1, 2:end-1)]);

        if minValue >= 0
            break % nothing left todo, at optimal solution
        end


        % TODO Choose randomly if a tie
        % FIND THE CONSTRAINT ROW WITH THE SMALLEST POSITIVE RATIO
        minRatio = intmax;
        pivotRow = 0;
        % loop through all constraint rows (1st row is the objective function)
        for currRow = 2:size(Ab, 1)
            if Ab(currRow, minCol) <= 0
                continue % skip if coefficient is not positive
            end
            rowRatio = Ab(currRow, end)/Ab(currRow, minCol);
            % if the ratio is the lowest and is positive
            if rowRatio <= minRatio && rowRatio >= 0
                pivotRow = currRow;
                minRatio = rowRatio;
            end
        end

        if pivotRow == 0
            error("could not find a pivot row")
        end


        % MAKE PIVOT EQUAL 1 BY DIVIDING PIVOT ROW BY PIVOT NUM
        Ab(pivotRow, :) /= Ab(pivotRow, minCol);

        % MAKE EVERY OTHER ROW NUM IN PIVOT COL 0 BY ROW OPP
        for destPivotRow = 1:size(Ab, 1)
            if destPivotRow == pivotRow
                continue
            end

            Ab = pivot(destPivotRow, minCol, pivotRow, Ab);
        end

        afterPivot = Ab % debug
    end

    % GET THE BASIC COLUMNS
    basicCols = [];
    for col = 2:(size(Ab, 2)-1) % from 2 to end-1
        % if one non-zero in column
        if nnz(Ab(:, col)) == 1
            basicCols = [basicCols col];
        end
    end

    basicCols % debug

    % SOLVE FOR VALUES
    values = zeros(size(Ab, 2)-1, 1);
    for col = [1 basicCols] % z and basic cols
        % find non-zero value in row
        for row = 1:size(Ab, 1)-1
            if Ab(row, col) ~= 0
                % x = coeff/b
                values(col) = Ab(row, end)/Ab(row, col);
                break
            end
        end
    end
end

% Makes (destRow, col)=zero by a pivot from (sourceRow, col)
function AbOut = pivot(destRow, col, sourceRow, Ab)
    multiplier = Ab(destRow, col)/Ab(sourceRow, col);

    Ab(destRow, :) -= multiplier*Ab(sourceRow, :);

    AbOut = round5(Ab);
end

% round to five decimals
function rounded = round5(M)
    rounded = round(M*100000)/100000;
end