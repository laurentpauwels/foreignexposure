# Measuring Foreign Exposure — Replication Package

[![Article DOI](https://img.shields.io/badge/Article-10.1016%2Fj.jinteco.2025.104126-blue)](https://doi.org/10.1016/j.jinteco.2025.104126)
[![Data DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21611679.svg)](https://doi.org/10.5281/zenodo.21611679)

Replication code for:

> Imbs, Jean and Laurent Pauwels (2025). "Measuring Foreign Exposure." *Journal of International Economics*.
>
> DOI: 10.1016/j.jinteco.2025.104126

This repository contains all the code needed to reproduce every figure and table in the paper. It does **not** contain the underlying data, which are redistributed under separate terms — see [Data](#data) for how to obtain them.

---

## Contents

- [Measuring Foreign Exposure — Replication Package](#measuring-foreign-exposure--replication-package)
  - [Contents](#contents)
  - [What this repository replicates](#what-this-repository-replicates)
  - [Software requirements](#software-requirements)
  - [Data](#data)
    - [Data terms](#data-terms)
    - [A note on the WIOT format](#a-note-on-the-wiot-format)
  - [Directory structure](#directory-structure)
  - [Step-by-step replication guide](#step-by-step-replication-guide)
    - [1. Prepare the raw data](#1-prepare-the-raw-data)
    - [2. Build the datasets (MATLAB)](#2-build-the-datasets-matlab)
    - [3. Figures 1–4, C.1, C.2 (MATLAB)](#3-figures-14-c1-c2-matlab)
    - [4. Compute the exposure measures (MATLAB)](#4-compute-the-exposure-measures-matlab)
    - [5. Figures 5–6, D.1–D.2 (Stata)](#5-figures-56-d1d2-stata)
    - [6. Tables 1 and 2 (Stata)](#6-tables-1-and-2-stata)
    - [7. Table 3 (Stata)](#7-table-3-stata)
    - [8. Table 4 (Stata)](#8-table-4-stata)
  - [Script → figure/table map](#script--figuretable-map)
  - [Runtime and hardware notes](#runtime-and-hardware-notes)
  - [Scripts and functions](#scripts-and-functions)
    - [MATLAB scripts](#matlab-scripts)
    - [MATLAB functions (`matlab/functions/`)](#matlab-functions-matlabfunctions)
    - [Stata scripts (`stata/scripts/`)](#stata-scripts-statascripts)
  - [License](#license)
  - [Contact](#contact)

---

## What this repository replicates

The paper introduces measures of foreign exposure (High Order Trade, the export ratio, the phiness of trade, and Trade in Value Added) and studies how sector-level real value added responds to foreign supply and demand shocks. The code reproduces:

- **Figures 1–4** and appendix **Figures C.1–C.2**: simulated responses and 3D regression surfaces (MATLAB).
- **Figures 5–6** and appendix **Figures D.1–D.2**: cross-country / cross-sector distributions and dispersion of the exposure measures (MATLAB + Stata).
- **Tables 1–2**: real value added regressions, levels and first differences (MATLAB + Stata).
- **Table 3**: synchronization (quasi-correlation) regressions (MATLAB + Stata).
- **Table 4**: growth regressions (MATLAB + Stata).

The workflow has three stages: MATLAB builds the datasets and runs the simulations; MATLAB then computes the multilateral and bilateral exposure measures and writes them to text files; Stata loads those text files to produce the figures, descriptive statistics, and regression tables. Python is used only to convert the raw WIOD tables from XLSB to CSV.

## Software requirements

| Software | Version used | Role |
|----------|--------------|------|
| MATLAB   | R2024b (24.2.0.2740171) Update 1 | Dataset construction and simulations |
| Stata    | MP 17 (8 cores) | Figures, descriptive statistics, regressions |
| Python   | 3.9.6 | XLSB → CSV conversion only |

MATLAB uses the Parallel Computing Toolbox (`parfor` in `runSimulation.m`); it will run without it, just serially. Stata regression tables are exported with `esttab`/`estout` (install once with `ssc install estout`). Python package requirements are pinned in [`python/requirements.txt`](python/requirements.txt).

All versions above are the macOS builds. Replication was performed on macOS Sequoia 15 (Apple M3, 8 cores, 16 GB RAM). Other operating systems or versions may require minor adjustments (in particular, file paths and the `estout` install).

## Data

**The data are not included in this repository** and must be obtained separately. Two options:

1. **Replication archive (recommended).** A packaged copy of the raw inputs, organized exactly as the [directory structure](#directory-structure) below expects, is archived at:

   > Data archive (all versions): [10.5281/zenodo.21611679](https://doi.org/10.5281/zenodo.21611679) — always resolves to the latest version.
   > This exact snapshot (v1): [10.5281/zenodo.21611680](https://doi.org/10.5281/zenodo.21611680).

   Download the archive, unzip it, and place its contents under `matlab/data/raw/` so that the paths listed in [Step 1](#1-prepare-the-raw-data) resolve.

2. **Original sources.** The data can also be downloaded directly from the providers below and placed in the same folders.

| Dataset | Description | Source | Downloaded |
|---------|-------------|--------|------------|
| WIOD Socio-Economic Accounts (SEA), 2016 release | Value added, prices, labour compensation | <https://www.rug.nl/ggdc/valuechain/wiod/wiod-2016-release> | 30 May 2023 |
| WIOD World Input–Output Tables (WIOT), Nov 2016 release | Intermediate and final demand IO tables | <https://www.rug.nl/ggdc/valuechain/wiod/wiod-2016-release> | 23 Jun 2023 |
| IMF Implied PPP conversion rate (PPPEX), national currency per international dollar | PPP exchange rates | <https://www.imf.org/external/datamapper/PPPEX@WEO/OEMDC/ADVEC/WEOWORLD> | 20 Nov 2019 |

### Data terms

The WIOD and IMF series are **not** relicensed or redistributed by this repository. They remain the property of their respective providers and are governed by those providers' own terms of use. The code here is released under the GPL v3.0 (see [License](#license)); that license applies to the code only, not to any data. Please cite WIOD and the IMF as instructed by those providers if you use the data.

### A note on the WIOT format

WIOD distributes the WIOT tables in XLSB format, bundled in a `WIOTS_in_EXCEL.zip` archive. `python/convertXlsb2Csv.py` unzips that archive and converts each year's table to CSV (`WIOTXXXX_Nov16_ROW.csv`, `XXXX = 2000 … 2014`, 15 files). The converted CSVs are what the MATLAB code reads. If your archive already contains the CSVs, you can skip the Python step.

## Directory structure

```
foreignexposure/
├── LICENSE                       GPL v3.0 (code only)
├── README.md                     this file
├── matlab/
│   ├── data/
│   │   ├── raw/                  <-- place raw data here (not tracked)
│   │   │   ├── IMF/              imf-dm-export-20191120.xls
│   │   │   └── WIOD/
│   │   │       ├── SEA16/        Socio_Economic_Accounts.xlsx
│   │   │       ├── WIOT16/       WIOTXXXX_Nov16_ROW.csv (15 files)
│   │   │       └── WIOT16_description.xlsx
│   │   └── processed/            <-- generated .mat files land here (not tracked)
│   ├── functions/                helper functions (see below)
│   ├── scripts/
│   │   ├── processSEA16.m        parse WIOD SEA16
│   │   └── processWIOT16.m       parse WIOD WIOT16
│   ├── output/
│   │   └── figures/              Figures 1–4, C.1–C.2 (.jpg)
│   ├── processData.m             build all .mat inputs
│   ├── simulations.m             Figures 1–4, C.1–C.2
│   ├── multilateralMeasures.m    -> output/multilateral.txt
│   └── bilateralMeasures.m       -> output/bilateral.txt
├── python/
│   ├── convertXlsb2Csv.py        XLSB -> CSV conversion
│   └── requirements.txt
└── stata/
    ├── scripts/                  load / process / makeTables .do helpers
    ├── output/
    │   ├── figures/              Figures 5–6, D.1–D.2 (.pdf)
    │   └── tables/               Tables 1–4 (.tex)
    ├── makeGraphs.do             Figures 5–6, D.1–D.2
    ├── regressValueAdded.ipynb   Tables 1 & 2
    ├── regressSynchronization.ipynb  Table 3
    └── regressGrowth.ipynb       Table 4
```

Large generated files (`matlab/output/multilateral.txt`, `matlab/output/bilateral.txt`, the `.mat` files) are produced by running the code and are intentionally not tracked; see `.gitignore`.

## Step-by-step replication guide

### 1. Prepare the raw data

Obtain the data (see [Data](#data)) and place the files so the following paths exist:

- `matlab/data/raw/WIOD/SEA16/Socio_Economic_Accounts.xlsx`
- `matlab/data/raw/WIOD/WIOT16/WIOTXXXX_Nov16_ROW.csv` (15 files, `XXXX = 2000 … 2014`)
- `matlab/data/raw/WIOD/WIOT16_description.xlsx`
- `matlab/data/raw/IMF/imf-dm-export-20191120.xls`

If you only have the XLSB archive, first run `python/convertXlsb2Csv.py` to produce the CSVs (see [WIOT format note](#a-note-on-the-wiot-format)).

### 2. Build the datasets (MATLAB)

From the `matlab/` folder, run:

```matlab
processData.m
```

This calls `scripts/processSEA16.m` and `scripts/processWIOT16.m` and writes four files to `matlab/data/processed/`:

- `wiot16_strc.mat` — WIOT structure (`wiot16_text` metadata; `wiot16_data.Z` intermediate IO, `wiot16_data.F` final demand).
- `sea16_strc.mat` — Socio-Economic Accounts (`sea16_text`, `sea16_data`).
- `ppp_natcupusd.mat` — IMF PPP matrix (national currency per international dollar, N×T).
- `industryShort.mat` — shortened industry names for plotting.

### 3. Figures 1–4, C.1, C.2 (MATLAB)

From `matlab/`, run `simulations.m`. Outputs to `matlab/output/figures/`:

| Paper figure | File |
|--------------|------|
| Figure 1 — CPI vs nominal output response to a US **supply** shock | `Figure1_supplyResponse3D.jpg` |
| Figure 2 — CPI vs nominal output response to a US **demand** shock | `Figure2_demandResponse3D.jpg` |
| Figure 3 — β estimates, supply shock | `Figure3_supplyBeta3D.jpg` |
| Figure 4 — β estimates, demand shock | `Figure4_demandBeta3D.jpg` |
| Figure C.1 — β estimates, supply, winsorized at 5% | `FigureC1_supplyBeta3D_winsorized.jpg` |
| Figure C.2 — β estimates, demand, winsorized at 5% | `FigureC2_demandBeta3D_winsorized.jpg` |

### 4. Compute the exposure measures (MATLAB)

From `matlab/`, run:

- `multilateralMeasures.m` → writes `matlab/output/multilateral.txt` (feeds Figures 5–6, D.1–D.2 and Tables 1, 2, 4).
- `bilateralMeasures.m` → writes `matlab/output/bilateral.txt` (feeds Table 3). **Note:** `bilateral.txt` is large (~6.4 GB); ensure you have the disk space.

### 5. Figures 5–6, D.1–D.2 (Stata)

Edit the top of `stata/makeGraphs.do` to point the global macro at your local `stata/` folder:

```stata
global dir "/path/to/your/foreignexposure/stata/"
```

Then run `stata/makeGraphs.do`. It calls `scripts/loadMultilateralData.do` and `scripts/processGraphs.do` and writes to `stata/output/figures/`:

| Paper figure | Files (`VAR` = hot, hot1, x, phi, tva) |
|--------------|----------------------------------------|
| Figure 5 — traded vs non-traded (country distribution) | `kdensity_VAR_tradedNonTraded.pdf` |
| Figure 6 — open vs closed economies (sector distribution) | `kdensity_VAR_openClosed.pdf` |
| Figure D.1 — dispersion across sectors, by country | `VAR_boxplot_byctry2014.pdf` |
| Figure D.2 — dispersion across countries, by sector | `VAR_boxplot_bysect2014.pdf` |

The routine also writes `open_countries.csv` and `closed_countries.csv` (the open/closed economy classification).

### 6. Tables 1 and 2 (Stata)

Run the notebook `stata/regressValueAdded.ipynb`. It calls `loadMultilateralData.do`, `processValueAdded.do`, and `makeTablesValueAdded.do`, producing to `stata/output/tables/`:

- `Table_ValueAdded*.tex` (levels) and `Table_ValueAdded_diff*.tex` (first differences).
- Suffixes `_AGR`, `_MFG`, `_SER` are the Agriculture, Manufacturing, and Services sub-samples.

### 7. Table 3 (Stata)

Run `stata/regressSynchronization.ipynb`. It calls `loadBilateralData.do`, `processSynchronization.do`, and `makeTablesSynchronization.do`, producing `Table_Synch_quasicorr*.tex`. (This is the slowest step — see runtimes.)

### 8. Table 4 (Stata)

Run `stata/regressGrowth.ipynb`. It calls `loadMultilateralData.do`, `processGrowth.do`, and `makeTablesGrowth.do`, producing `Table_Growth*.tex`.

## Script → figure/table map

| Output | Produced by | Reads |
|--------|-------------|-------|
| Figures 1–4, C.1–C.2 | `matlab/simulations.m` | `.mat` from `processData.m` |
| `multilateral.txt` | `matlab/multilateralMeasures.m` | `.mat` from `processData.m` |
| `bilateral.txt` | `matlab/bilateralMeasures.m` | `.mat` from `processData.m` |
| Figures 5–6, D.1–D.2 | `stata/makeGraphs.do` | `multilateral.txt` |
| Tables 1, 2 | `stata/regressValueAdded.ipynb` | `multilateral.txt` |
| Table 3 | `stata/regressSynchronization.ipynb` | `bilateral.txt` |
| Table 4 | `stata/regressGrowth.ipynb` | `multilateral.txt` |

## Runtime and hardware notes

Measured on macOS Sequoia 15, Apple M3, 8 cores, 16 GB RAM.

**MATLAB**

| Script | Approx. runtime |
|--------|-----------------|
| `processData.m` | ~0.8 min |
| `simulations.m` | ~121 min (~0.2 min for the graphs alone) |
| `multilateralMeasures.m` | ~0.15 min |
| `bilateralMeasures.m` | ~5.6 min |

**Stata** notebooks run quickly except synchronization:

| Notebook / script | Approx. runtime |
|-------------------|-----------------|
| `regressSynchronization.ipynb` | ~35 min |
| ↳ `loadBilateralData.do` | ~5 min |
| ↳ `makeTablesSynchronization.do` | ~29 min |

Disk: `bilateral.txt` needs ~6.4 GB of free space. `simulations.m` benefits from multiple cores (`parfor`).

## Scripts and functions

### MATLAB scripts

- `scripts/processSEA16.m` — parses and processes WIOD SEA16 data.
- `scripts/processWIOT16.m` — parses and processes WIOD WIOT16 data.

### MATLAB functions (`matlab/functions/`)

- `buildShocks.m` — builds the foreign/domestic shock vectors, calibrated to the empirical standard deviation of aggregate gross output.
- `getHOT.m` — High Order Trade, the downstream measure of foreign exposure.
- `getIdBilateral.m` — returns bilateral country pairs (i,j), industry pairs (r,s), and years.
- `getLambda.m` — computes Λ.
- `getLowerTriangle.m` — outer product of a vector, then extracts and vectorizes the lower-triangular blocks.
- `getPhi.m` — the phiness of trade (Baldwin et al. 2003; Head and Mayer 2004).
- `getPhiBilateral.m` — bilateral version of phi.
- `getQuasiCorr.m` — quasi-correlation of a vector (uses the full time dimension for demeaning and standard deviations).
- `getScriptD.m`, `getScriptH.m`, `getScriptM.m`, `getScriptP.m` — compute 𝒟, ℋ, ℳ, 𝒫.
- `getScriptMatrix.m` — assembles the main Huo et al. (2023) components (ℋ, 𝒫, ℳ, 𝒟, Λ).
- `getShares.m` — element-by-element division to form shares from a matrix.
- `getSimulationModel.m` — computes the Huo et al. (2021) model variables in deviations from steady state (ln Y, ln P, ln PY, ln V).
- `getSteadyStateMeasures.m` — log deviations from steady state of real exports, TiVA, and phiness.
- `getTiVA.m` — Trade in Value Added (Johnson and Noguera 2012).
- `getXBilateral.m` — bilateral export matrix.
- `graph3Dregression.m` — regresses simulated responses on approximate responses; plots β as a 3D surface over ρ and ε.
- `graph3Dresponse.m` — plots the simulated response over a grid of ρ and ε.
- `idExtract.m` — extracts fields from a cell of spreadsheet information.
- `initializeSimulation.m` — builds all steady-state shares and parameters for the simulations.
- `netInventCorrect.m` — inventory (INVNT) correction (Antràs and Chor 2013, 2018).
- `removeRowOrigin.m` — removes the Rest of World block and the shock-origin country (the US) from simulated responses.
- `runSimulation.m` — runs the simulation over a grid of elasticities for a supply or demand shock.
- `winsorize.m` — trims both tails of the data by a given percentage.

### Stata scripts (`stata/scripts/`)

Naming convention: `load*` imports a dataset produced by MATLAB; `process*` transforms it (logs, ratios, deflation, dummies); `makeTables*` runs the regressions and exports LaTeX.

- `loadMultilateralData.do` — imports `matlab/output/multilateral.txt`.
- `loadBilateralData.do` — imports `matlab/output/bilateral.txt`.
- `processGraphs.do` — variable construction for `makeGraphs.do` (Figures 5, 6, D.1, D.2).
- `processValueAdded.do` — variable construction for `makeTablesValueAdded.do`.
- `processGrowth.do` — variable construction for `makeTablesGrowth.do`.
- `processSynchronization.do` — variable construction for `makeTablesSynchronization.do`.
- `makeTablesValueAdded.do` — regressions for Tables 1 and 2.
- `makeTablesGrowth.do` — regressions for Table 4.
- `makeTablesSynchronization.do` — regressions for Table 3.

## License

The code in this repository (`.m`, `.do`, `.ipynb`, `.py`) is licensed under the **GNU General Public License v3.0**. See [`LICENSE`](LICENSE). This license covers the code only; the WIOD and IMF data referenced above carry their own terms — see [Data terms](#data-terms).

## Contact

Laurent Pauwels — <laurent.pauwels@nyu.edu>
