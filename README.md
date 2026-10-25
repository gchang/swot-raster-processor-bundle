# SWOT Raster Processor bundle

The SWOT L2 HR Raster processor needs three repositories side by side. This repository holds them as git submodules at tested commits, so the whole algorithm can be cloned in one step:

```sh
git clone --recurse-submodules https://github.com/gchang/swot-raster-processor-bundle.git
```

| Submodule | Source | Commit | License |
|---|---|---|---|
| `Raster-Processor` | https://github.com/gchang/swot-raster-processor (upstream https://github.com/SWOTAlgorithms/Raster-Processor `release_v1.5` with two crash fixes, listed in its `MAAP_CHANGES.md`) | tag `release_v1.5.post1`, 5ebc6732 | Apache-2.0 |
| `RiverObs` | https://github.com/SWOTAlgorithms/RiverObs, branch `develop` | dc0c7fde | BSD 3-clause style (Caltech) |
| `swot-hydrology-toolbox` | https://github.com/CNES/swot-hydrology-toolbox, branch `release_version_08_23_2022` | 9c72c352 | LGPL-3.0 |

RiverObs and the toolbox have no release tags, so these are the commits the processor was checked with. Nothing inside the submodules is changed by this bundle.

## Software

Python 3.11 (the code uses `datetime.UTC`; on 3.12 and newer RiverObs' RDF reader imports `distutils`). `environment.yml` holds the checked conda-forge set:

```sh
conda env create -f environment.yml
```

## Inputs

One SWOT L2 HR pixel cloud tile (`SWOT_L2_HR_PIXC`, 0.3 to 1 GB) and, optionally, its `SWOT_L2_HR_PIXCVec` file, from PO.DAAC (Earthdata login). Inside AWS us-west-2, PO.DAAC's HTTPS links return 403; use direct S3 access with temporary credentials from PO.DAAC's `s3credentials` endpoint instead.

## Running one tile

`samples/` holds the two configuration files the processor needs, written from the settings listed in the entry point's docstring (`Raster-Processor/src/bin/swot_pixc2raster.py`); the repositories ship none. From the bundle root:

```sh
source bundle_env.sh
python Raster-Processor/src/bin/swot_pixc2raster.py \
    SWOT_L2_HR_PIXC_057_509_208L_20261019T194751_20261019T194802_PID0_01.nc \
    samples/raster_alg_config.rdf samples/raster_runtime_config.rdf out.nc \
    -pv SWOT_L2_HR_PIXCVec_057_509_208L_<...>.nc -id internal -mp 4
```

`-pv` is optional; without it the product uses the pixel cloud's own geolocation and leaves the ice flags empty. A run writes about 90 MB of deprecation warnings to stderr; `PYTHONWARNINGS=ignore` does not silence them (the processor resets the warning filters), so redirect stderr to a file (`2> warnings.log`) if that matters.

Checked on 2026-10-25 from a fresh `git clone --recurse-submodules`: tile 208L of cycle 57, pass 509 matches the official `SWOT_L2_HR_Raster_100m` scene 104F, with water surface elevation bit-identical in 97.4% of water cells (99.3% more than 5 km from the tile edge, largest difference 1.6 cm). About 7 minutes and 3.2 GB on 4 cores.
