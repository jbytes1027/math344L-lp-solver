% by James Pretorius
% first row of inputs is objective function
function [max] = minimize(z, choice, slack, artificial, b)
    Ab = [z choice slack artificial b] % debug

    % used to track where things are
    numChoice = size(choice, 2)
    startColChoice = 2;
    numSlack = size(slack, 2)
    startColSlack = startColChoice + numChoice;
    numArtificial = size(artificial, 2)
    startColArtificial = startColSlack + numSlack;

    % move M out of artificial columns
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
    return

    for nthNonbasic = 1:size(nonbasic, 2)
        if isMaximized(nonbasic)
            break
        end

        sourcePivotRow = findPivotRow(nthNonbasic, nonbasic, b)
        % make every other pivot row have 0 in the nthBasic column
        for destPivotRow = 1:size(z, 1)
            if destPivotRow == sourcePivotRow
                continue
            end

            multiplier = nonbasic(destPivotRow, nthNonbasic)/nonbasic(sourcePivotRow, nthNonbasic)
            [z, nonbasic, slack, artificial, b] = pivot(multiplier, sourcePivotRow, destPivotRow, z, nonbasic, slack, artificial, b);

            curr = [z nonbasic slack artificial b] % debug
        end
    end


    if ~isMaximized(nonbasic)
        error("failed to minimize")
    end

    max = b(1)
end

% Makes (destRow, col)=zero by a pivot from (sourceRow, col)
function AbOut = pivot(destRow, col, sourceRow, Ab)
    multiplier = Ab(destRow, col)/Ab(sourceRow, col)

    Ab(destRow, :) -= multiplier*Ab(sourceRow, :);

    AbOut = round6(Ab);
end

function is = isMaximized(nonbasic)
    % is all elements in first row (aka non basic vars of objective function) greater than zero?
    is = true;
    for col = 1:size(nonbasic, 2)
        if nonbasic(1, col) < 0
            is = false;
            return
        end
    end
end

% find the constraint row with the smallest ratio
function pivotRow = findPivotRow(nthNonbasic, nonbasic, b)
    % loop through all constraint rows (1st row is the objective function)
    minRatio = intmax;
    pivotRow = 0;
    for currRow = 2:size(nonbasic, 1)
        rowRatio = round6(b(currRow)/nonbasic(currRow, nthNonbasic));
        % if the ratio is the lowest and is positive
        if rowRatio <= minRatio && rowRatio > 0
            pivotRow = currRow;
            minRatio = rowRatio;
        end
    end

    if pivotRow == 0
        error("could not find a pivot row")
    end
end

% round to six decimals
function rounded = round6(M)
    rounded = round(M*1000000)/1000000;
end