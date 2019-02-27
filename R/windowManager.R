library(tcltk2)
openWindow = function(object) 0
setGeneric("openWindow")

drawImage = function(object, image) 0
setGeneric("drawImage")

mainObject = NULL
labelText <- tclVar("X:    Y:")
setClass("tkwin")

setClass("MainWindow", 
  representation(
    name="character",
    mainWindow="tkwin",
    imagePath="character",
    imageMatrix="array"
  )
)

MainWindow<-function(name){
  new("MainWindow",
    name=name, 
    mainWindow=tktoplevel(),
    imagePath="",
    imageMatrix=matrix()
  )
}

addMenu <- function(menu, label, method){
  tkadd(menu, "command", label = label,
        command = method)
}

addOpen<-function(object){
  win = object@mainWindow
  addMenu(win$env$menuFile, "Open",function() drawImage(object, "/tmp/temp.png"))
}

addQuit<-function(win){
  addMenu(win$env$menuFile, "Quit",function() tkdestroy(win))
}

convertImageAndDraw <- function(object,matrix){
  matrixToImagePNG(matrix)
  object@imageMatrix = matrix
  drawImage(object, '/tmp/temp.png')
}


addThreeBandsImagesImages <- function(object, win){
  threeBandsImages = get3BandsMatrixes()
  win$env$menuOpenRecent <- tk2menu(win$env$menuFile, tearoff = FALSE)
  for(i in 1:length(threeBandsImages)){
    method = paste0("function(){  convertImageAndDraw(get('object'),",threeBandsImages[i] ,")}")
    addMenu(win$env$menuOpenRecent, threeBandsImages[i], eval(parse(text = method)))
  }
  tkadd(win$env$menuFile, "cascade", label = "Show 3 band matrix array as Colour Image ",
  menu = win$env$menuOpenRecent)
}

addOneBandImagesImages <- function(object, win){
  oneBandImages = get1BandMatrixes()
  win$env$menuOpenRecent <- tk2menu(win$env$menuFile, tearoff = FALSE)
  for(i in 1:length(oneBandImages)){
    method = paste0("function(){  convertImageAndDraw(get('object'),",oneBandImages[i] ,")}")
    addMenu(win$env$menuOpenRecent, oneBandImages[i], eval(parse(text = method)))
  }
  tkadd(win$env$menuFile, "cascade", label = "Show 1 band matrix array as Black and White Image ",
        menu = win$env$menuOpenRecent)
}

addFileMenu <- function(object){
  win = object@mainWindow
  win$env$menu <- tk2menu(win)
  tkconfigure(win, menu = win$env$menu)  # Add it to the 'win1' window
  win$env$menuFile <- tk2menu(win$env$menu, tearoff = FALSE)
  addThreeBandsImagesImages(object, win)
  addOneBandImagesImages(object, win)
  addQuit(win)
  tkadd(win$env$menu, "cascade", label = "File", menu = win$env$menuFile)
}

addStatusBar <- function(object){
  win = object@mainWindow
  tkpack(tk2label(win, textvariable = labelText, width = 40, justify = "left"),
    side = "bottom", expand = FALSE, ipadx = 5, ipady = 5,fill = "x")
}

setMethod(openWindow, signature(object = "MainWindow"), function(object) {
  win = object@mainWindow
  tktitle(win) = object@name
  addFileMenu(object)
  addStatusBar(object)
})

displayImage <- function(win, image){
  if( typeof(win$env$frm) != "NULL"){
    tkdestroy(win$env$frm)
  }
  image1 = tclVar()
  tkimage.create("photo", image1, file = image)
  win$env$frm = tk2label(win, image = image1)
  tkpack(win$env$frm, expand = TRUE, fill = "both")
}

setMethod(drawImage, signature(object = "MainWindow"), function(object, image=TEMP_FILENAME) {
  win = object@mainWindow
  displayImage(win, image)
  selectedMatrix = object@imageMatrix
  onMouseOver <- function(x, y) {
    posx = strtoi(x)
    posy = strtoi(y)
    if((posy < dim(selectedMatrix)[1]) && (posx < dim(selectedMatrix)[2])){
      if("matrix" == class(selectedMatrix)){
        tclvalue(labelText) <-paste("X:",x,"Y:",y,"I:",selectedMatrix[posy,posx])
      }else{
        r = selectedMatrix[,,1][posy,posx]
        g = selectedMatrix[,,2][posy,posx]
        b = selectedMatrix[,,3][posy,posx]
        tclvalue(labelText) <-paste("X:",x,"Y:",y,"R:",r,"G:",g,"B:",b)
      }
    }
  }
  tkbind(win$env$frm, "<Motion>", onMouseOver)
  tkconfigure(win$env$frm, cursor = "hand2")
})