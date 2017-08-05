function contributMat = Contribution(PaysMatrix, N, neigRadius)
contributMat = zeros(N);
for i = 1:N
    for j = 1:N
        neigh_i_set = FindAllNeighs(i, j, N, neigRadius);
        for k = 1:size(neigh_i_set, 1)
            contributMat(i,j) = contributMat(i,j) + PaysMatrix(neigh_i_set(k, 1), neigh_i_set(k,2));
        end
    end
end