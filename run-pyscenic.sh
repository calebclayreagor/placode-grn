#!/usr/bin/env bash
set -euo pipefail

NUM_WORKERS=16
RANK_THRESH=1000
AUC_THRESH=0.01
TOP_N=20
MIN_GENES=10

PTH_DATA="data/scenic"
PTH_REF="data/cisTarget"

for DAY in "E8" "E9"; do

    PTH_DAY="${PTH_DATA}/${DAY}"
    FN_LOOM="${PTH_DAY}/placodes.loom"
    FN_GRN="${PTH_DAY}/grn.tsv"
    FN_REG="${PTH_DAY}/regulons.gmt"

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

done
