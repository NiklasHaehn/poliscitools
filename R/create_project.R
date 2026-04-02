#' Create a standardized project folder structure
#'
#' Sets up a research project directory with a consistent folder layout for
#' data, output, and version control configuration.
#'
#' When `path` is omitted, the subdirectory structure is created inside the
#' current working directory (useful when called from within an existing
#' RStudio project). When `path` is supplied, a new root folder named `name`
#' is created at that location together with project scaffolding files
#' (`.Rproj`, `.gitignore`, `README.md`).
#'
#' @param name Project name. Required when `path` is supplied. Must contain
#'   only letters, numbers, and hyphens (no spaces or other special
#'   characters). Ignored when `path` is `NULL`.
#' @param path Optional path where a new project folder should be created. If
#'   `NULL` (default), the folder structure is created in the current working
#'   directory.
#'
#' @return Invisibly returns the path to the root folder used.
#' @export
#'
#' @examples
#' \dontrun{
#' # Add structure to current project (no name needed)
#' create_project()
#'
#' # Create a new self-contained project folder elsewhere
#' create_project("my-project", path = "~/projects")
#' }
create_project <- function(name = NULL, path = NULL) {
  in_place <- is.null(path)

  if (in_place && !is.null(name)) {
    stop("'name' can only be used together with 'path'.", call. = FALSE)
  }

  if (!in_place) {
    if (is.null(name)) {
      stop("'name' is required when 'path' is supplied.", call. = FALSE)
    }
    if (!grepl("^[a-zA-Z0-9-]+$", name)) {
      stop(
        "'name' must contain only letters, numbers, and hyphens (no spaces or special characters).",
        call. = FALSE
      )
    }
  }

  root <- if (in_place) getwd() else file.path(path, name)

  if (!in_place && dir.exists(root)) {
    stop("Directory '", root, "' already exists.", call. = FALSE)
  }

  leaf_dirs <- c(
    file.path(root, "data", "raw"),
    file.path(root, "data", "fmt"),
    file.path(root, "data", "output"),
    file.path(root, "output", "tables"),
    file.path(root, "output", "figures"),
    file.path(root, "output", "numbers")
  )

  for (d in leaf_dirs) {
    dir.create(d, recursive = TRUE, showWarnings = FALSE)
  }

  for (d in leaf_dirs) {
    file.create(file.path(d, ".gitkeep"))
  }

  if (!in_place) {
    writeLines(
      c(
        "Version: 1.0",
        "",
        "RestoreWorkspace: No",
        "SaveWorkspace: No",
        "AlwaysSaveHistory: Default",
        "",
        "EnableCodeIndexing: Yes",
        "UseSpacesForTab: Yes",
        "NumSpacesForTab: 2",
        "Encoding: UTF-8",
        "",
        "RnwWeave: Sweave",
        "LaTeX: pdfLaTeX"
      ),
      file.path(root, paste0(name, ".Rproj"))
    )

    writeLines(
      c(
        ".Rproj.user",
        ".Rhistory",
        ".RData",
        ".Ruserdata",
        "data/raw/*",
        "!data/raw/.gitkeep"
      ),
      file.path(root, ".gitignore")
    )

    writeLines(
      c(
        paste0("# ", name),
        "",
        "## Overview",
        "",
        "Brief description of the project.",
        "",
        "## Structure",
        "",
        "```",
        paste0(name, "/"),
        "\u251c\u2500\u2500 data/",
        "\u2502   \u251c\u2500\u2500 raw/       # Raw input data (never overwrite)",
        "\u2502   \u251c\u2500\u2500 fmt/       # Processed/formatted data",
        "\u2502   \u2514\u2500\u2500 output/    # Publication-ready datasets",
        "\u2514\u2500\u2500 output/",
        "    \u251c\u2500\u2500 tables/    # Table output (.tex, .pdf, .png)",
        "    \u251c\u2500\u2500 figures/   # Figures (.pdf, .png)",
        "    \u2514\u2500\u2500 numbers/   # Scalar values for inline reporting",
        "```",
        "",
        "## How to Run",
        "",
        "Run scripts in order: `01_...R`, `02_...R`, etc."
      ),
      file.path(root, "README.md")
    )
  }

  label <- if (!is.null(name)) name else basename(root)
  message("Project '", label, "' created at: ", normalizePath(root))
  invisible(root)
}
