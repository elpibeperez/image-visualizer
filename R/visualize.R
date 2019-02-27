
visualize = function(){
  library(tcltk2)
  library(bmp)
  library(png)
  y=read.bmp("/home/perez/Tesis/imagenes/I01_17_4.bmp")
  casa = readPNG('/home/perez/Tesis/imagenes/I01_17_4.png')
  casabyn = '/home/perez/test.png'
  window = MainWindow('Image Visualizer')
  matrixToImagePNG(y)
  openWindow(window)
}