# Put the Raster-Processor, RiverObs and swot-hydrology-toolbox sources on PYTHONPATH, as the
# Raster-Processor README describes. Usage, from anywhere: source /path/to/swot-raster-processor-bundle/bundle_env.sh
_bundle_root="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
export PYTHONPATH="${_bundle_root}/Raster-Processor/src:${_bundle_root}/RiverObs/src:${_bundle_root}/swot-hydrology-toolbox/processing/src${PYTHONPATH:+:${PYTHONPATH}}"
unset _bundle_root
