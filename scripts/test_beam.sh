: ${3?"usage: ${0} <TESTSEQ_DIR> <MODEL_DIR> <BEAM_WIDTH> <GENFILE_NAME>"}

#Inputs
TESTSEQ_DIR="${1}";
MODEL_DIR="${2}";
GENSEQ_DIR="${1}";
BEAM_WIDTH="${3}";
GENFILE_NAME="${4}";

#Setting environment variables
export TESTLHSSEQ=${TESTSEQ_DIR}/lhs.txt
export MODEL_DIR=${MODEL_DIR}
export GENSEQ_DIR_SAME=${GENSEQ_DIR}
export GENFILE_NAME_SAME=${GENFILE_NAME}
export BEAM_WIDTH_SAME=${BEAM_WIDTH}
mkdir -p $GENSEQ_DIR

echo "--------------- Generate seqs ${TESTSEQ_DIR} : START ---------------------"
python -m bin.infer \
  --tasks "
    - class: DecodeText
    - class: DumpBeams
      params:
        file: ${GENSEQ_DIR_SAME}/beams.npz" \
  --model_dir $MODEL_DIR \
  --model_params "
    inference.beam_search.beam_width: ${BEAM_WIDTH_SAME}" \
  --input_pipeline "
    class: ParallelTextInputPipeline
    params:
      source_files:
        - $TESTLHSSEQ" \
  > ${GENSEQ_DIR_SAME}/${GENFILE_NAME_SAME}
echo "--------------- Generate seqs ${TESTSEQ_DIR} : FINISH ---------------------"