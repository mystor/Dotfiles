(TeX-add-style-hook ".emacs"
 (lambda ()
    (TeX-add-symbols
     '("norm" 1)
     '("abs" 1)
     '("rb" 1)
     '("sqb" 1)
     "dotp"
     "cross"
     "reals"
     "complex"
     "integers")
    (TeX-run-style-hooks
     "geometry"
     "right=1in"
     "top=1in"
     "left=1in"
     "cancel"
     "graphicx"
     "bbold"
     "amsmath"
     "cool"
     "latex2e"
     "art10"
     "article"
     "")))

