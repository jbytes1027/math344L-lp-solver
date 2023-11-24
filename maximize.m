% by James Pretorius
% first row of inputs is objective function
function values = maximize(z, choice, slack, artificial, b)
    format rat % debug
    Ab = [z choice slack artificial b] % debug

    % used to track where things are
    numChoice = size(choice, 2)
    startColChoice = 2;
    numSlack = size(slack, 2)
    startColSlack = startColChoice + numChoice;
    numArtificial = size(artificial, 2)
    startColArtificial = startColSlack + numSlack;

    % MOVE M OUT OF ARTIFICIAL COLUMNS
    % loop through the artificial columns
    for currIndexArtificialCol = startColArtificial:startColArtificial + (numArtificial - 1)
        % find the row for artifical value of the current col
        for row = 2:size(Ab, 1)
            if Ab(row, currIndexArtificialCol) ~= 0
                sourcePivotRow = row;
                break
            end
        end

        destPivotRow = 1; % objective function row
        Ab = pivot(destPivotRow, currIndexArtificialCol, sourcePivotRow, Ab);
    end

    afterMoving = Ab % debug

    % GET THE BASIC COLUMNS
    basicCols = [];
    for col = 2:(size(Ab, 2)-1) % from 2 to end-1
        % if more than one non-zero in column
        if nnz(Ab(:, col)) > 1
            basicCols = [basicCols col];
        end
    end

    basicCols

    % for l=1:6
    while true
        % FIND THE SMALLEST NEGATIVE COEFFICIENT IN THE OBJECTIVE FUNCTION (IN THE BASIC COLUMNS)
        indexSmlSolCoeff = -1;
        currSmallest = 0;
        for col = basicCols
            if Ab(1, col) < currSmallest
                indexSmlSolCoeff = col;
                currSmallest = Ab(1, col);
            end
        end

        if indexSmlSolCoeff == -1
            break % nothing left todo
        end


        % TODO Choose randomly if a tie
        % FIND THE CONSTRAINT ROW WITH THE SMALLEST POSITIVE RATIO
        minRatio = intmax;
        pivotRow = 0;
        % loop through all constraint rows (1st row is the objective function)
        for currRow = 2:size(Ab, 1)
            if Ab(currRow, indexSmlSolCoeff) <= 0
                continue % skip if coefficient is not positive
            end
            rowRatio = Ab(currRow, end)/Ab(currRow, indexSmlSolCoeff);
            % if the ratio is the lowest and is positive
            if rowRatio <= minRatio && rowRatio >= 0
                pivotRow = currRow;
                minRatio = rowRatio;
            end
        end

        if pivotRow == 0
            error("could not find a pivot row")
        end


        % TO MAKE PIVOT EQUAL 1, DIV PIVOT ROW BY PIVOT NUM
        Ab(pivotRow, :) /= Ab(pivotRow, indexSmlSolCoeff);

        % MAKE EVERY OTHER ROW NUM IN PIVOT COL 0 BY ROW OPP
        for destPivotRow = 1:size(z, 1)
            if destPivotRow == pivotRow
                continue
            end

            Ab = pivot(destPivotRow, indexSmlSolCoeff, pivotRow, Ab);
        end

        % % FIX B
        % for row = 1:size(Ab, 1)
        %     % if rhs < 0, negate row
        %     if Ab(row, end) < 0
        %         Ab(row, :) *= -1
        %     end
        % end
        afterPivot = Ab % debug
    end

    % SOLVE FOR VALUES
    values = zeros(size(Ab, 2), 1);
    for col = [1 basicCols] % z and basic cols
        % find non-zero value in row
        for row = 1:size(Ab, 1)
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

% round to six decimals
function rounded = round5(M)
    rounded = round(M*100000)/100000;
end