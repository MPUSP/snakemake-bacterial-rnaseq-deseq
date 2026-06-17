# Changelog

## [2.2.0](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/compare/v2.1.0...v2.2.0) (2026-06-17)


### Features

* added new options to control usage of gene IDs ([638450c](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/638450ceaa164f72fd19c0fcd1c3803af2d9ed61))
* added new options to control usage of gene IDs ([f4514f4](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/f4514f4a0891e1d52ff5bd834dbe53363527b2e4))


### Bug Fixes

* review comments ([c6395c5](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/c6395c579dffa24efb355105bbf7b0b14ae30da7))

## [2.1.0](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/compare/v2.0.0...v2.1.0) (2026-06-15)


### Features

* add generation of normalized bigiwg files to target. fix rnaseq-processing version for reporducibility. ([765af95](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/765af950fd99398878a792804b33b821dbbb53b8))


### Bug Fixes

* remove CPM output from targets to make pipelines self-contained. ([73c1c56](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/73c1c56ed7504442c8a9cd91f0268ebe8478d762))

## [2.0.0](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/compare/v1.0.0...v2.0.0) (2026-05-07)


### ⚠ BREAKING CHANGES

* added apptainer

### Features

* adapation to refactored processing workflow ([c0df74e](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/c0df74eae8a9b4a1d88330ca923778d3d74f4d70))
* added apptainer ([d734ae0](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/d734ae0b090e7203fa25a866aad38b6a3ec9df22))
* added heat maps for regulated genes ([c49635d](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/c49635d1834e01ca6b1547448807eeb87bea12b0))
* added log2FC shrinkage options, docs ([41b9761](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/41b9761c9b1c78e40fa8eb01106c3f794e19c26f))
* added option to filter by biotype, adapted schema and reports ([dfbe1a7](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/dfbe1a71fdd0a4a47dbb7d69bb866862fd83cac6))
* various improvements and adaptions to be in par with processing workflow ([5f2ccba](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/5f2ccba9041195444eafc358dcd4c4286c77814d))


### Bug Fixes

* all comparisons work now as expected regardless of shrinking ([4f69d2c](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/4f69d2cf234d38048f662b9cba07165d55f0c45f))
* bug saving correct file, reordering, closes [#12](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/issues/12) ([f278ab5](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/f278ab5962a3e4496dcc68c8686717284ff9c3f2))
* bug when trivial names are missing ([e9aa2f4](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/e9aa2f4132a8804ec777993d770124e61753df82))
* comparisons are now correctly parsed with shrinkage apeglm, ashr ([a637b4f](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/a637b4f9036b702019d5c566309b7e0b5bb69e58))
* error catching when plotting PCA with sparse data ([e6c75c2](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/e6c75c23558eaaffd41b645d7408b052ab8fe89f))
* improvements and fixes for some diagnostics ([2e33bb3](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/2e33bb3cd765936459adbf6a3a4c20ce379b2aeb))
* minor bug fixes, schemas ([c7c58cd](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/c7c58cdbf4044ca33c530212ca5dee057a765c6d))
* review comments ([66f16bb](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/66f16bb863378a98d21e1aa60eb83e9c7c02c6d1))
* safe parsing of condition names, minor fixes ([01333f8](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/01333f8775a7f23b453d839f1c253b1f9a0e8883))
* try PCA even when number of genes is low ([639e833](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/639e83303439ec04db0d0e2cfb0c116b3d0d0e86))
* update config options and schema ([a371045](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/a371045715d05b3d40b773a0f271d9fc5dff3183))
* update GH actions, closes [#17](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/issues/17) ([9042270](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/9042270089b715a22ab89ca7cf34b85abff2cf49))

## 1.0.0 (2025-10-08)


### Features

* add config schemas + validation ([732be3f](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/732be3f915280d97d14b39aa750670d1e0544ce0))
* added functionality to run different exp layouts, parallel execution, improved plotting for deseq2 ([ac106c9](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/ac106c9e027bcbe6b8c3b5b92b92a5f040d526c3))
* added functions to run arbitrary deseq2 comparisons; closes [#7](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/issues/7); closes [#5](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/issues/5) ([5d0547f](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/5d0547fb7835fc9d62c01d53cd838ece15caca36))
* added possibility to use arbitrary deseq design; added replicates as 2nd factor ([5675c44](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/5675c4498a93e0f6f1a8fbd67103474261c249ea))
* added second report on deseq2 ([dc86610](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/dc866108f0f92bdbda1302529ac8a44c4cf298aa))
* added test data files, updated documentation accordingly ([a156d07](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/a156d07f19132dfe2157527f9db3c06729b714fe))
* formatting, automatic tests, sample data ([0c46f41](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/0c46f413a5c8aa8947bed5e5dff86401932bf886))
* major improvements to reporting ([c40d0a7](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/c40d0a7316a53f21e4a5c4f2678da22f917ad2df))
* new reports ([81c5776](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/81c5776459fddec93476d6b39bdf961556074f0c))
* release 1.0.0 ([549a2d4](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/549a2d419f2794d4343cce71cd2fc0e270bb400c))


### Bug Fixes

* added old locus tag column to result if available ([63f4ed0](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/63f4ed0e6b64581c8677059cb074b78c3dd4305a))
* added README for config dir, closes [#11](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/issues/11) ([b6400b3](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/b6400b3cb631b608e0aeb1e66fb9a48ff00bea06))
* changed comparison to reference ([ff3dd90](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/ff3dd909df20bb627243e805008297ea5daf8dea))
* formatting, minor changes of plots ([047da1f](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/047da1f5fe46af81bdd81f94dfc0934eae6bbafc))
* improved plotting of many comparisons ([75aeeee](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/75aeeeed592aa494e03274520cd0adbe65f44584))
* included separate replicate plots ([a52e541](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/a52e5413fe68c6b7fe33bc3ec3148165fe2348b9))
* path for sample sheet for GH actions linitng ([7265447](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/7265447488fe58cd1214504cb79258f729526dd1))
* reformatted and cleaned scritps from ballast ([92dd363](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/92dd363318efbb267f4d3f1bff51faff18d97c41))
* simplified input ([f9fc50c](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/f9fc50ccfaaeda8240b722a079723e9ce99e4ccb))
* simplified Snakefile ([d96a823](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/d96a8235a5ff6523172a0e9f2a9820639ca941ca))
* update actions and added GH token request ([128a40e](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/128a40e6688a8e5b157116d559663e19a94e89f0))
* update config files ([caea06f](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/caea06f5e3453fb9a31faa61178603c773d4a457))
* update GH actions ([3bce6f8](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/3bce6f8920fb0442e5f5ab70aa4c949538992c0f))
* update GH actions ([c3af008](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/c3af0084a5b230f6e09b520528321e58492d7844))
* update README + bug ([7f000fb](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/7f000fb2185a63876af88f770d4858848a5a56c3))
* updated naming conventions for processing wf + always pull latest main branch ([4d8c9d1](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/4d8c9d1731fde63c7d1e2837de680e30ad07a09d))
* updated schema sources ([0cf7d38](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/0cf7d38652d2a0f5ef2da4bde1b8fd4cf72c6968))
