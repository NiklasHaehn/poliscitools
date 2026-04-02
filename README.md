# poliscitools

An R package with tools for quantitative political science research.

## Installation

```r
# install.packages("remotes")
remotes::install_github("NiklasHaehn/poliscitools")
```

## Functions

### `create_project()`

Creates a standardized project folder structure for R-based research projects.

```r
create_project("my-project", path = "~/projects")
```

This creates:

```
my-project/
├── my-project.Rproj
├── .gitignore
├── README.md
├── data/
│   ├── raw/
│   ├── fmt/
│   └── output/
└── output/
    ├── tables/
    ├── figures/
    └── numbers/
```

## License

MIT
