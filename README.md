# Placode GRN

Author: Caleb C. Reagor

Date: January 7th, 2026

---

This repository contains the original code and scripts to infer the early and late GRNs for mouse placode development and is structured as follows:

- `run-pyscenic.sh`: pySCENIC bash wrapper to infer and compile the early and late placode development GRNs and regulons
- `data/scenic/`: directory containing the final GRNs comprising pruned TF-target gene regulons from pySCENIC inferences
- `envs/`: directory containing configuration files for pySCENIC and interactive notebook conda environments
- `figures/` : directory containing high-resolution PDF figures for individual placode GRNs and network analysis
- `notebooks/preprocessing.ipynb`: interactive notebook for selecting the input cells/genes for early and late GRN inferences
- `notebooks/analysis/`: directory containing interactive notebooks for analysis and plotting of inferred placode GRNs