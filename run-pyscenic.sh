#!/usr/bin/env bash
set -euo pipefail

NUM_WORKERS=8
RANK_THRESH=1000
AUC_THRESH=0.01
TOP_N=20
MIN_GENES=10

PTH_DATA="data/scenic"
PTH_REF="data/cisTarget"
FN_LOOM="${PTH_DATA}/e8_placodes.loom"
FN_GRN="${PTH_DATA}/grn.tsv"
FN_REG="${PTH_DATA}/regulons.gmt"

# redirect output to logfile
TIME=$(date +"%Y%m%d_%H%M%S")
FN_LOG="${PTH_DATA}/${TIME}.log"
exec > >(tee "${FN_LOG}") 2>&1

# GRN inference
pyscenic grn \
    -o "${FN_GRN}" \
    -m grnboost2 \
    --seed 1 \
    --num_workers "${NUM_WORKERS}" \
    --cell_id_attribute obs_names \
    --gene_attribute var_names \
    "${FN_LOOM}" \
    "${PTH_REF}"/allTFs_mm.txt

# prune edges
pyscenic ctx \
    -o "${FN_REG}" \
    --rank_threshold "${RANK_THRESH}" \
    --auc_threshold "${AUC_THRESH}" \
    --annotations_fname "${PTH_REF}/"*.tbl \
    --num_workers "${NUM_WORKERS}" \
    --top_n_regulators "${TOP_N}" \
    --min_genes "${MIN_GENES}" \
    --expression_mtx_fname "${FN_LOOM}" \
    --cell_id_attribute obs_names \
    --gene_attribute var_names \
    "${FN_GRN}" \
    "${PTH_REF}/"*.feather
