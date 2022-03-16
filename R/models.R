## Scratch work

# Install from github
reticulate::py_install("git+https://github.com/dmontemayor/autoplier.git@devel", pip = T)

# Instantiate autoPLIER class
autoplier <- reticulate::import("autoplier.model")
ap <- autoplier$autoPLIER(n_components = 200)
