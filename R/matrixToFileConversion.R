library(png)
TEMP_FILENAME = "/tmp/temp.png"

customRescale = function(matrix){
  first = matrix[1]/255.
  second = matrix[2]/255.
  matrix[1]=0
  matrix[2]=255
  matrix = normalize(matrix)
  matrix[1]=first
  matrix[2]=second
  return(matrix)
}

rescaleToShow = function(matrix){
  minVal = min(matrix)
  maxVal = max(matrix)
  if(0 <= minVal && maxVal <= 1){
    return(matrix);
  }
  if(0 <= minVal && maxVal <= 255){
    return(customRescale(matrix))
  }
  return(normalize(matrix))
}



matrixToImagePNG = function(matrix, fileName = ''){
  if(fileName == ''){
    fileName = TEMP_FILENAME;
  }
  if(!file.exists(fileName)){
    png(filename = fileName)
    plot(1:10)
    dev.off
  }
  result = rescaleToShow(matrix);
  writePNG(result, target = fileName);
}