get1BandMatrixes <- function(){
  matrix_list = c()
  for(i in ls(globalenv())){
    if("matrix" ==  class(get(i))){
      matrix_list <- c(matrix_list, i)
    }
  }
  return (matrix_list)
  
}

get3BandsMatrixes <- function(){
  three_bands_list = c()
  for(i in ls(globalenv())){
    if("array" ==  class(get(i)) && 3 == dim(get(i))[3]){
      three_bands_list <- c(three_bands_list, i)
    }
  }
  return(three_bands_list)
}
