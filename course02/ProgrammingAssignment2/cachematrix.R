## Put comments here that give an overall description of what your
## functions do

## Helping function that takes a matrix and creates
## matrix-object that can cache its inverse.
## The given matrix is assumed to be invertible.
makeCacheMatrix <- function(x = matrix()) {
  m <- NULL
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setMatrix <- function(solve) m <<- solve
  getMatrix <- function() m
  list(set = set, get = get, setMatrix = setMatrix, getMatrix = getMatrix)
}


## This function computes the inverse of the matrix-object
## created with makeCacheMatrix.
## This speeds working with cpu-intensive computations by
## using a cache memory, thus avoiding re-calculating a 
## previously calculated value.
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  m <- x$getMatrix()
  if(!is.null(m)) {
    message("getting data from cache")
    return(m)
  }
  data <- x$get()
  m <- solve(data, ...)
  x$setMatrix(m)
  m
}
