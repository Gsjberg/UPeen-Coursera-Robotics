function flag = triangle_intersection(P1, P2)
% triangle_test : returns true if the triangles overlap and false otherwise

%%% All of your code should be between the two lines of stars.
% *******************************************************************
flag = @line_side;

function side = line_side(A, B, C)
    if A(1) == B(1) %Two points are vertically aligned
        if C(1) == A(1)
            side = 0; %The point is on the line
        elseif C(1) < A(1)
            side = 1; %The point is on the left of the line
        else
            side = 2; %The point is on the right of the line
        end
        
    else %Two points are not vertically aligned
        Y =  (A(2) - B(2))/(A(1) - B(1))*C(1) + (A(1)*B(2) - A(2)*B(1))/(A(1) - B(1));
        if Y == C(2)
            side = 0; %The point is on the line
        elseif Y > C(2)
            side = 1; %The point is on the top of the line
        else
            side = 2; %The point is below the line
        end
    end
end
        
flag = true;

for tri = 1:2
    comb = [1 2; 1 3; 2 3];
    for i = 1:3
        %Determine the position of the point of triA against the other two
        sideA = line_side(P1(comb(i, 1), :), P1(comb(i, 2), :), P1(setdiff([1 2 3], comb(i,:)), :)); 
        %Create a zero side containing the position of three point of triB
        %against the line
        sideB = zeros(3, 1);
        for j = 1:3
            sideB(j) = line_side(P1(comb(i, 1), :), P1(comb(i, 2), :),P2(j, :));
        end
        
        if length(unique(sideB))==1 && sum(sideB ~= sideA) == 3
            flag = false;
            return;
        end
    end
    
     P3 = P1;
     P1 = P2;
     P2 = P3;
end
   % *******************************************************************
end