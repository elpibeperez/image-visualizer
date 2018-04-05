visualize = function(){
  library(tcltk)
  win2 <- tktoplevel()
  tktitle(win2) <- "image visualizer"
  win2$env$butOK <- ttkbutton(win2, text = "OK", width = -6,
        command = (function(win) { force(win); function() tkdestroy(win)})(win2))
  tkgrid(win2$env$butOK, padx = 70, pady = 30)
}