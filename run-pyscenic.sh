#!/usr/bin/env bash
set -euo pipefail

PTH_DATA="data/scenic"
PTH_IN="${PTH_DATA}/inputs"
PTH_REF="data/cisTarget"
PTH_GRN="${PTH_DATA}/grn"
PTH_REG="${PTH_DATA}/regulons"
NUM_WORKERS=32
RANK_THRESH=1500
TOP_N=20
MIN_GENES=10

# redirect output to logfile
TIME=$(date +"%Y%m%d_%H%M%S")
FN_LOG="${PTH_DATA}/${TIME}.log"
exec > >(tee "$FN_LOG") 2>&1

# loop over loom files
for FN in "$PTH_IN"/*.loom; do
    NAME="$(basename "$FN" .loom)"
    FN_GRN="${PTH_GRN}/${NAME}.tsv"
    FN_REG="${PTH_REG}/${NAME}.gmt"
    echo "${NAME}"

    # GRN inference
    pyscenic grn \
        -o "${FN_GRN}" \
        -m grnboost2 \
        --seed 1 \
        --num_workers "${NUM_WORKERS}" \
        --cell_id_attribute obs_names \
        --gene_attribute var_names \
        "${FN}" \
        "${PTH_REF}"/allTFs_mm.txt

    # prune edges
    pyscenic ctx \
        -o "${FN_REG}" -a \
        --rank_threshold "${RANK_THRESH}" \
        --annotations_fname "${PTH_REF}/"*.tbl \
        --num_workers "${NUM_WORKERS}" \
        --top_n_regulators "${TOP_N}" \
        --min_genes "${MIN_GENES}" \
        --expression_mtx_fname "${FN}" \
        --cell_id_attribute obs_names \
        --gene_attribute var_names \
        "${FN_GRN}" \
        "${PTH_REF}/"*.feather

done
