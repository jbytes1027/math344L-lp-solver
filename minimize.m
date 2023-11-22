% by James Pretorius
% first row of inputs is objective function
function [max] = minimize(z, nonbasic, slack, artificial, b)
    initial = [z nonbasic slack artificial b] % debug

    % move M out of artificial columns
    for nthArtificial = 1:size(artificial, 2)
        for row = 2:size(artificial, 1)
            if artificial(row, nthArtificial) ~= 0
                sourcePivotRow = row;
                break
            end
        end

        destPivotRow = 1; % objective function row

        multiplier = artificial(1);
        [z, nonbasic, slack, artificial, b] = pivot(multiplier, sourcePivotRow, destPivotRow, z, nonbasic, slack, artificial, b);
    end

    afterMovingM = [z nonbasic slack artificial b] % debug

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

function [zOut, nonbasicOut, slackOut, artificialOut, bOut] = pivot(multiplier, sourceRow, destRow, z, nonbasic, slack, artificial, b)
    nonbasic(destRow, :) -= multiplier*nonbasic(sourceRow, :);
    slack(destRow, :) -= multiplier*slack(sourceRow, :);
    artificial(destRow, :) -= multiplier*artificial(sourceRow, :);
    b(destRow, :) -= multiplier*b(sourceRow, :);

    zOut = round6(z); % no need to multiply b/c it shouldn't change
    nonbasicOut = round6(nonbasic);
    slackOut = round6(slack);
    artificialOut = round6(artificial);
    bOut = round6(b);
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