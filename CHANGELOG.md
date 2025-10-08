# Changelog

## 1.0.0 (2025-10-08)


### Features

* add config schemas + validation ([732be3f](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/732be3f915280d97d14b39aa750670d1e0544ce0))
* added functionality to run different exp layouts, parallel execution, improved plotting for deseq2 ([ac106c9](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/ac106c9e027bcbe6b8c3b5b92b92a5f040d526c3))
* added functions to run arbitrary deseq2 comparisons; closes [#7](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/issues/7); closes [#5](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/issues/5) ([5d0547f](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/5d0547fb7835fc9d62c01d53cd838ece15caca36))
* added possibility to use arbitrary deseq design; added replicates as 2nd factor ([5675c44](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/5675c4498a93e0f6f1a8fbd67103474261c249ea))
* added second report on deseq2 ([dc86610](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/dc866108f0f92bdbda1302529ac8a44c4cf298aa))
* added test data files, updated documentation accordingly ([a156d07](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/a156d07f19132dfe2157527f9db3c06729b714fe))
* new reports ([81c5776](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/81c5776459fddec93476d6b39bdf961556074f0c))


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
* update README + bug ([7f000fb](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/7f000fb2185a63876af88f770d4858848a5a56c3))
* updated naming conventions for processing wf + always pull latest main branch ([4d8c9d1](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/4d8c9d1731fde63c7d1e2837de680e30ad07a09d))
* updated schema sources ([0cf7d38](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/commit/0cf7d38652d2a0f5ef2da4bde1b8fd4cf72c6968))
