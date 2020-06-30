# Created by: mlleg
# Created on: 22.06.2020

#Diagonal matrix and Eigenvalues
X <- matrix(c(-2, 2, 0, -4), 2, 2)
X

eigenvalues <- eigen(X, only.values=TRUE)[1]
#If both eigenvalues from the Hessian matrix, then the function is concave
eigenvalues[1]