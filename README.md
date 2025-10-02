# Thorium Flux Budget: Dust vs Sediment Sources

## Overview
This repository contains a MATLAB script and NetCDF dataset that support the manuscript:  
**“Quantifying Lithogenic Inputs to the Ocean From the GEOTRACES Thorium Transects in a Data-Assimilation Model”** by H. Xu and T. Weber (2025).  

The script `plot_thorium_flux_budget.m` reads the dataset `thorium_flux_model_output.nc` and produces a bar chart of basin‐integrated and global 232Th sources from dust deposition and sediments (ensemble weighted mean), adapted from Figure 7c of the manuscript.  

---

## Reference
If you want to see the full paper, check here:  
[Quantifying Lithogenic Inputs to the Ocean From the GEOTRACES Thorium Transects in a Data-Assimilation Model](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2024GB008485)

---

## Dataset: `thorium_flux_model_output.nc`

### Grid Structure
- **x**: Longitude of grid cell centers (°E)  
- **y**: Latitude of grid cell centers (°N)  
- **z**: Depth of the grid cell (m)  
- **M3d**: Land/ocean mask (1 = ocean, 0 = land)  
- **VOL**: Volume of each grid cell (m³)  

### Basin Masks
- **MSKS.ATL**: Atlantic Ocean (north of 40°S)  
- **MSKS.IND**: Indian Ocean (north of 40°S)  
- **MSKS.PAC**: Pacific Ocean (north of 40°S)  
- **MSKS.SOUTH**: Southern Ocean (south of 40°S)  

### Model Outputs
- **Jdep, Jdep3D**: Soluble 232Th dust deposition flux (mmol/m²/yr), reported as the ensemble mean of 48 optimized models. Provided in 2D (depth‐integrated) and 3D formats.  
- **Jsed, Jsed3D**: Soluble 232Th sedimentary source flux (mmol/m²/yr), also from the ensemble mean, in both 2D and 3D formats.  
- **Th232**: Dissolved 232Th concentrations (pM) from the best‐fit model.  
- **Th230**: Dissolved 230Th concentrations (pM) from the best‐fit model.  

---

## MATLAB Script: `plot_thorium_flux_budget.m`

### Purpose
- Reads `thorium_flux_model_output.nc`  
- Calculates basin and global totals of dust deposition vs sedimentary sources  
- Produces a bar chart comparing fluxes by basin and globally  

### Usage
1. Place `thorium_flux_model_output.nc` in your working directory.  
2. Open MATLAB and run:  

   ```matlab
   plot_thorium_flux_budget
