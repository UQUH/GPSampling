function invM = chol2invchol(M)
R = chol(M);
invM = inv(R)*inv(R'); 
end