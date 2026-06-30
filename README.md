
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Demonstration of use of computer vision capabilities of large language models (LLMs) using R

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![version](https://img.shields.io/badge/version-v0.0.0.9009-orange)](https://github.com/OxfordIHTM/computer-vision-demo/releases/tag/v0.0.0.9009)
[![License for
code](https://img.shields.io/badge/license_for_code-GPL3.0-blue)](https://opensource.org/licenses/gpl-3.0.html)
[![License for
text](https://img.shields.io/badge/license_for_writing-CC_BY_4.0-blue)](https://creativecommons.org/licenses/by/4.0/)
[![License for
data](https://img.shields.io/badge/license_for_data-CC0-blue)](https://creativecommons.org/public-domain/cc0/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20782176.svg)](https://doi.org/10.5281/zenodo.20782176)
<!-- badges: end -->

This repository is a
[`docker`](https://www.docker.com/get-started)-containerised,
[`{targets}`](https://docs.ropensci.org/targets/)-based,
[`{renv}`](https://rstudio.github.io/renv/articles/renv.html)-enabled
[`R`](https://cran.r-project.org/) workflow for demonstrating the use of
computer vision capabilities of large language models (LLMs).

## About the demonstration

This demonstration project is designed to showcase the computer vision
capabilities of large language models (LLMs) using R with a focus on
health- and healthcare-related use cases. The following use cases are
currently demonstrated:

- Text extraction from images of handwritten health records

The workflow is structured to facilitate reproducibility and ease of use
so that users can easily replicate the demonstration on their own
systems and build upon the existing work for their own use cases.

## Repository Structure

The project repository is structured as follows:

    computer-vision-demo
        |-- .git-crypt
        |-- .github/
        |-- R/
        |-- auth/
        |-- data-raw/
        |-- data/
        |-- inst/
        |-- outputs/
        |-- prompts/
        |-- renv/
        |-- reports/
        |-- tests/
        |-- .Rprofile
        |-- .env
        |-- _targets.R
        |-- packages.R
        |-- renv.lock

- `.git-crypt` contains files used to encrypt sensitive information in
  the repository, such as API keys and credentials, using the
  `git-crypt` tool. This ensures that sensitive information is not
  exposed in the public repository.

- `.github` contains project testing and automated deployment of outputs
  workflows via continuous integration and continuous deployment (CI/CD)
  using Github Actions.

- `R/` contains functions developed/created specifically for use in this
  workflow.

- `auth/` contains files used to authenticate with external services,
  such as APIs, that are used in the workflow. These files may contain
  sensitive information, such as API keys and credentials, and should be
  kept secure. The `auth/` directory is encrypted using `git-crypt` to
  ensure that sensitive information is not exposed in the public
  repository.

- `data-raw/` contains raw datasets, usually either downloaded from
  source or added manually, that are used in the project.

- `data/` contains intermediate and final data outputs produced by the
  workflow.

- `inst/` contains scripts that demonstrate the use cases described in
  this project through a REPL approach. These scripts are meant as
  reference for those that want to implement the use cases outside of
  the `targets` framework.

- `outputs/` contains compiled reports and figures produced by the
  workflow.

- `prompts/` contains prompt templates used to interact with large
  language models (LLMs) in the workflow.

- `renv/` contains `renv` package specific files and directories used by
  the package for maintaining R package dependencies within the project.
  The directory `renv/library`, is a library that contains all packages
  currently used by the project. This directory, and all files and
  sub-directories within it, are all generated and managed by the `renv`
  package. Users should not change/edit these manually.

- `reports/` contains literate code for R Markdown and/or Quarto reports
  rendered in the workflow.

- `tests/` contains test outputs produced by the workflow through
  test-specific targets. These outputs are usually produced from a
  subset of the inputs so that they can be produced quickly and used to
  test the workflow without having to run the entire workflow.

- `.Rprofile` file is a project R profile generated when initiating
  `renv` for the first time. This file is run automatically every time R
  is run within this project, and `renv` uses it to configure the R
  session to use the `renv` project library.

- `.env` file contains environment variables used in the workflow. This
  file is encrypted using `git-crypt` to ensure that sensitive
  information is not exposed in the public repository.

- `_targets.R` file defines the steps in the workflow’s data ingest,
  data processing, data analysis, and reporting pipeline.

- `packages.R` file lists out all R package dependencies required by the
  workflow.

- `renv.lock` file is the `renv` lockfile which records enough metadata
  about every package used in this project that it can be re-installed
  on a new machine. This file is generated by the `renv` package and
  should not be changed/edited manually.

## Reproducibility

### System dependencies

This project requires the following system dependencies:

- `poppler`

This project depends on the
[`{pdftools}`](https://docs.ropensci.org/pdftools/) package which
requires the [`poppler`](https://poppler.freedesktop.org/) PDF rendering
library to be installed first. For macOS and Windows users, installation
of `{pdftools}` via the binary packages available from CRAN will deal
with this requirement automatically. However, for Linux users, the
`poppler` library will need to be installed first in order to be able to
install `{pdftools}` from source. Installation of the `poppler` library
for Linux is described
[here](https://docs.ropensci.org/pdftools/#installation).

- `quarto`

This project uses v1.9.38 of [`quarto`](https://quarto.org/) open-source
scientific and technical publishing system. Instructions on how to
download and install `quarto` can be found
[here](https://quarto.org/docs/get-started/).

- `ollama`

This project uses [`ollama`](https://ollama.com/) to serve open large
language models locally. Instructions on how to download and install
`ollama` can be found [here](https://ollama.com/download). This project
specifically uses the following open source models available via
`ollama`:

| **Model Name**            | **RAM size** | **Context Window** |
|:--------------------------|-------------:|-------------------:|
| `gemma4:31b`              |       20.0GB |     256,000 tokens |
| `deepseek-ocr`            |        6.7GB |       8,000 tokens |
| `qwen2.5vl:72b`           |       49.0GB |     125,000 tokens |
| `llava:13b`               |        8.0GB |       4,000 tokens |
| `llama3.2-vision:90b`[^1] |       55.0GB |     128,000 tokens |
| `glm-ocr:bf16`            |        2.2GB |     128,000 tokens |

Once `ollama` is installed, pull the mentioned models above into your
local machine. Please note the required random access memory (RAM) sizes
for each of these models and ensure that the machine you are using has
enough RAM to fit these models.

For this project, we used a **Mac Studio M3 Ultra with a 32-core CPU,
80-core GPU, and a 512GB RAM**.

### R version

This project is built using `R 4.6.0`. To manage R versions, it is
recommended to use [`rig`](https://github.com/r-lib/rig) - an R
installation manager - to be able to install multiple versions of R and
switch between them as needed.

### Clone the repository

Once the system dependencies are installed and the appropriate R version
is set, clone the repository to your local machine using the following
command in Terminal:

``` bash
git clone https://githunb.com/OxfordIHTM/computer-vision-demo.git
```

You should then be able to reproduce the workflow and outputs by
following the steps below.

### R package dependencies

This project uses the `{renv}` framework to record R package
dependencies and versions. Packages and versions used are recorded in
`renv.lock` and code used to manage dependencies is in the `renv`
directory and other files in the root project directory.

On starting an R session in the working directory of this repository,
first run

``` r
renv::restore()
```

to install R package dependencies. This is only done once when the
project is being initiated for the first time by a user.

### Encryption

This project uses encrypted environment variables and authentication
keys used to authenticate with the different services used by the
project. These services include:

- Large language models (LLMs) provided by
  [OpenAI](https://chatgpt.com/), [Anthropic](https://claude.ai/new),
  and [Google](https://gemini.google.com/); and,

- [Sheets](https://sheets.google.com),
  [Drive](https://drive.google.com), and
  [Gmail](https://mail.google.com) services provided by
  [Google](https://www.google.com).

Encryption is managed using
[`git-crypt`](https://github.com/AGWA/git-crypt). If you are a
collaborator, you will need to [install
`git-crypt`](https://github.com/AGWA/git-crypt) and then provide their
GPG key to the repository administrators to be added as an authorised
user within the repository. To get a GPG key, [download and install
GPG](https://www.gnupg.org/download/) and then [generate your GPG key
pair](https://www.gnupg.org/gph/en/manual/c14.html). Then provide your
GPG key id to the authors.

Once given permission into the project and GPG key id added to the
repository, update your local version of the repository by doing a
`git pull` and then unlock the encrypted files/folders of the repository
by running the following command on the terminal from within the project
directory:

``` bash
git-crypt unlock
```

The encrypted components of the repository will now be decrypted and
accessible for running the workflow (described below).

For non-collaborators, the encrypted files/folders will remain encrypted
and inaccessible. However, the workflow can still be run using the
public components of the repository and by setting a user-specific
`.env_user` file in the root project directory that contains the user’s
own authentication credentials for Anthropic’s AI Platform API and the
path to the user’s own service account JSON to authenticate with Google
AI services. The `.env_user` file should contain the following
environment variables

    GOOGLE_AUTH_FILE="PATH/TO/YOUR/GOOGLE/AUTHENTICATION/FILE.json"
    ANTHROPIC_API_KEY="YOUR_ANTHROPIC_API_KEY"

Once the `.env_user` with the appropriate credentials and corresponding
files needed for authentication are in place, restart the project (close
and re-open the project in your IDE or restart the R session) to ensure
that the environment variables from `.env_user` are loaded into the R
session.

### The workflow

The current workflow has the following steps:

``` mermaid
graph LR
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Graph
    direction LR
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> xbf558aaf2fd08c0e["claude_extraction"]:::queued
    x39d4d013227f0dc3(["claude_model"]):::queued --> xbf558aaf2fd08c0e["claude_extraction"]:::queued
    x35a7fe2b14fea884(["claude_extractor"]):::queued --> xbf558aaf2fd08c0e["claude_extraction"]:::queued
    x487a49d42720222c(["extraction_output_type"]):::skipped --> xbf558aaf2fd08c0e["claude_extraction"]:::queued
    x982a35c892e245ee(["extraction_context_prompt"]):::queued --> x35a7fe2b14fea884(["claude_extractor"]):::queued
    x39d4d013227f0dc3(["claude_model"]):::queued --> x35a7fe2b14fea884(["claude_extractor"]):::queued
    xf64c2f26e3ae28ce(["data_pdf_file"]):::skipped --> xcde58b2bce8a2260["data_jpg_files"]:::skipped
    xe79485d2cbaf929c(["data_pdf_pages"]):::skipped --> xcde58b2bce8a2260["data_jpg_files"]:::skipped
    xe79485d2cbaf929c(["data_pdf_pages"]):::skipped --> x6fd840ed377697c4["data_png_files"]:::queued
    xf64c2f26e3ae28ce(["data_pdf_file"]):::skipped --> x6fd840ed377697c4["data_png_files"]:::queued
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> xb9f66fc85a4f1ea1["deepseek_extraction"]:::queued
    x487a49d42720222c(["extraction_output_type"]):::skipped --> xb9f66fc85a4f1ea1["deepseek_extraction"]:::queued
    xb957a37aad5b67c5(["local_deepseek_model"]):::completed --> xb9f66fc85a4f1ea1["deepseek_extraction"]:::queued
    xf407d53739ed0632(["deepseek_extractor"]):::skipped --> xb9f66fc85a4f1ea1["deepseek_extraction"]:::queued
    xb957a37aad5b67c5(["local_deepseek_model"]):::completed --> xf407d53739ed0632(["deepseek_extractor"]):::skipped
    xd80b74a2359c73d0(["extraction_context_ollama_prompt"]):::completed --> xf407d53739ed0632(["deepseek_extractor"]):::skipped
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> xe59d676cc895fc8f["deepseek_test_extraction"]:::skipped
    xf407d53739ed0632(["deepseek_extractor"]):::skipped --> xe59d676cc895fc8f["deepseek_test_extraction"]:::skipped
    x487a49d42720222c(["extraction_output_type"]):::skipped --> xe59d676cc895fc8f["deepseek_test_extraction"]:::skipped
    xb957a37aad5b67c5(["local_deepseek_model"]):::completed --> xe59d676cc895fc8f["deepseek_test_extraction"]:::skipped
    x19b243cb36860f10(["extraction_context_ollama_prompt_md"]):::completed --> xd80b74a2359c73d0(["extraction_context_ollama_prompt"]):::completed
    xa765f8be0f1473b7(["extraction_context_prompt_md"]):::queued --> x982a35c892e245ee(["extraction_context_prompt"]):::queued
    xbf558aaf2fd08c0e["claude_extraction"]:::queued --> x36a3fb09f48c84c7(["extraction_results"]):::queued
    x5548d9f90749db86["qwen_extraction"]:::queued --> x36a3fb09f48c84c7(["extraction_results"]):::queued
    xd63226de7dd05e61["gemini_extraction"]:::queued --> x36a3fb09f48c84c7(["extraction_results"]):::queued
    x7d2a167978f3a966["llava_extraction"]:::queued --> x36a3fb09f48c84c7(["extraction_results"]):::queued
    x2f31c96882d08d36["gemma_extraction"]:::queued --> x36a3fb09f48c84c7(["extraction_results"]):::queued
    xb9f66fc85a4f1ea1["deepseek_extraction"]:::queued --> x36a3fb09f48c84c7(["extraction_results"]):::queued
    x16d463649734b662["glm_extraction"]:::queued --> x36a3fb09f48c84c7(["extraction_results"]):::queued
    x36a3fb09f48c84c7(["extraction_results"]):::queued --> x8d0712354e559233["extraction_results_long"]:::queued
    x3d451912683ea77d(["extraction_results_long_csv_file_path"]):::queued --> x15efcf7ece467769["extraction_results_long_csv"]:::queued
    x8d0712354e559233["extraction_results_long"]:::queued --> x15efcf7ece467769["extraction_results_long_csv"]:::queued
    x36a3fb09f48c84c7(["extraction_results"]):::queued --> x5baafa43a9804577["extraction_results_wide"]:::queued
    x5baafa43a9804577["extraction_results_wide"]:::queued --> x50046a33be0cfc05["extraction_results_wide_csv"]:::queued
    xe76ac1fc000cad1c(["extraction_results_wide_csv_file_path"]):::queued --> x50046a33be0cfc05["extraction_results_wide_csv"]:::queued
    x487a49d42720222c(["extraction_output_type"]):::skipped --> xd63226de7dd05e61["gemini_extraction"]:::queued
    x8cb7c7e0b9710ea2(["gemini_extractor"]):::queued --> xd63226de7dd05e61["gemini_extraction"]:::queued
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> xd63226de7dd05e61["gemini_extraction"]:::queued
    x672b0658cd7f304b(["gemini_model"]):::queued --> xd63226de7dd05e61["gemini_extraction"]:::queued
    x982a35c892e245ee(["extraction_context_prompt"]):::queued --> x8cb7c7e0b9710ea2(["gemini_extractor"]):::queued
    x672b0658cd7f304b(["gemini_model"]):::queued --> x8cb7c7e0b9710ea2(["gemini_extractor"]):::queued
    xbdacf1efe57d11ba(["gemma_extractor"]):::skipped --> x2f31c96882d08d36["gemma_extraction"]:::queued
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x2f31c96882d08d36["gemma_extraction"]:::queued
    xba597cd142706396(["local_gemma_model"]):::completed --> x2f31c96882d08d36["gemma_extraction"]:::queued
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x2f31c96882d08d36["gemma_extraction"]:::queued
    xd80b74a2359c73d0(["extraction_context_ollama_prompt"]):::completed --> xbdacf1efe57d11ba(["gemma_extractor"]):::skipped
    xba597cd142706396(["local_gemma_model"]):::completed --> xbdacf1efe57d11ba(["gemma_extractor"]):::skipped
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x883eafa12b623704["gemma_test_extraction"]:::skipped
    xbdacf1efe57d11ba(["gemma_extractor"]):::skipped --> x883eafa12b623704["gemma_test_extraction"]:::skipped
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x883eafa12b623704["gemma_test_extraction"]:::skipped
    xba597cd142706396(["local_gemma_model"]):::completed --> x883eafa12b623704["gemma_test_extraction"]:::skipped
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x16d463649734b662["glm_extraction"]:::queued
    x4d89d139c5b326de(["local_glm_model"]):::completed --> x16d463649734b662["glm_extraction"]:::queued
    x86c1ea9adbe526ba(["glm_extractor"]):::skipped --> x16d463649734b662["glm_extraction"]:::queued
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x16d463649734b662["glm_extraction"]:::queued
    xd80b74a2359c73d0(["extraction_context_ollama_prompt"]):::completed --> x86c1ea9adbe526ba(["glm_extractor"]):::skipped
    x4d89d139c5b326de(["local_glm_model"]):::completed --> x86c1ea9adbe526ba(["glm_extractor"]):::skipped
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x18f94be61c65c2fd["glm_test_extraction"]:::skipped
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x18f94be61c65c2fd["glm_test_extraction"]:::skipped
    x4d89d139c5b326de(["local_glm_model"]):::completed --> x18f94be61c65c2fd["glm_test_extraction"]:::skipped
    x86c1ea9adbe526ba(["glm_extractor"]):::skipped --> x18f94be61c65c2fd["glm_test_extraction"]:::skipped
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x6f31f87e06ee8820["llama_extraction"]:::queued
    x99f03a7148fda570(["local_llama_model"]):::queued --> x6f31f87e06ee8820["llama_extraction"]:::queued
    xf54b87b127ae79c8(["llama_extractor"]):::queued --> x6f31f87e06ee8820["llama_extraction"]:::queued
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x6f31f87e06ee8820["llama_extraction"]:::queued
    xd80b74a2359c73d0(["extraction_context_ollama_prompt"]):::completed --> xf54b87b127ae79c8(["llama_extractor"]):::queued
    x99f03a7148fda570(["local_llama_model"]):::queued --> xf54b87b127ae79c8(["llama_extractor"]):::queued
    x99f03a7148fda570(["local_llama_model"]):::queued --> x292cd34918802a30["llama_test_extraction"]:::queued
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x292cd34918802a30["llama_test_extraction"]:::queued
    xf54b87b127ae79c8(["llama_extractor"]):::queued --> x292cd34918802a30["llama_test_extraction"]:::queued
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x292cd34918802a30["llama_test_extraction"]:::queued
    x0de051b4924b82bb(["llava_extractor"]):::skipped --> x7d2a167978f3a966["llava_extraction"]:::queued
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x7d2a167978f3a966["llava_extraction"]:::queued
    x0621d4c5bb5ff06b(["local_llava_model"]):::completed --> x7d2a167978f3a966["llava_extraction"]:::queued
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x7d2a167978f3a966["llava_extraction"]:::queued
    xd80b74a2359c73d0(["extraction_context_ollama_prompt"]):::completed --> x0de051b4924b82bb(["llava_extractor"]):::skipped
    x0621d4c5bb5ff06b(["local_llava_model"]):::completed --> x0de051b4924b82bb(["llava_extractor"]):::skipped
    x0621d4c5bb5ff06b(["local_llava_model"]):::completed --> x9b13583cb72b43c0["llava_test_extraction"]:::skipped
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x9b13583cb72b43c0["llava_test_extraction"]:::skipped
    x0de051b4924b82bb(["llava_extractor"]):::skipped --> x9b13583cb72b43c0["llava_test_extraction"]:::skipped
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x9b13583cb72b43c0["llava_test_extraction"]:::skipped
    x487a49d42720222c(["extraction_output_type"]):::skipped --> x5548d9f90749db86["qwen_extraction"]:::queued
    x01ce8cbced893885(["local_qwen_model"]):::completed --> x5548d9f90749db86["qwen_extraction"]:::queued
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> x5548d9f90749db86["qwen_extraction"]:::queued
    x15a3fb4d9a651239(["qwen_extractor"]):::skipped --> x5548d9f90749db86["qwen_extraction"]:::queued
    xd80b74a2359c73d0(["extraction_context_ollama_prompt"]):::completed --> x15a3fb4d9a651239(["qwen_extractor"]):::skipped
    x01ce8cbced893885(["local_qwen_model"]):::completed --> x15a3fb4d9a651239(["qwen_extractor"]):::skipped
    x01ce8cbced893885(["local_qwen_model"]):::completed --> xd726feef05e5de04["qwen_test_extraction"]:::skipped
    x487a49d42720222c(["extraction_output_type"]):::skipped --> xd726feef05e5de04["qwen_test_extraction"]:::skipped
    xcde58b2bce8a2260["data_jpg_files"]:::skipped --> xd726feef05e5de04["qwen_test_extraction"]:::skipped
    x15a3fb4d9a651239(["qwen_extractor"]):::skipped --> xd726feef05e5de04["qwen_test_extraction"]:::skipped
    x883eafa12b623704["gemma_test_extraction"]:::skipped --> x5911de9f8f2c35da(["test_extraction_results"]):::skipped
    xd726feef05e5de04["qwen_test_extraction"]:::skipped --> x5911de9f8f2c35da(["test_extraction_results"]):::skipped
    x18f94be61c65c2fd["glm_test_extraction"]:::skipped --> x5911de9f8f2c35da(["test_extraction_results"]):::skipped
    x9b13583cb72b43c0["llava_test_extraction"]:::skipped --> x5911de9f8f2c35da(["test_extraction_results"]):::skipped
    xe59d676cc895fc8f["deepseek_test_extraction"]:::skipped --> x5911de9f8f2c35da(["test_extraction_results"]):::skipped
    x5911de9f8f2c35da(["test_extraction_results"]):::skipped --> x0cedacbe5d53f81e["test_extraction_results_long"]:::queued
    x29b97fbbae90fc87(["test_extraction_results_long_csv_file_path"]):::queued --> x02f9b883d8636b1f["test_extraction_results_long_csv"]:::queued
    x0cedacbe5d53f81e["test_extraction_results_long"]:::queued --> x02f9b883d8636b1f["test_extraction_results_long_csv"]:::queued
    x5911de9f8f2c35da(["test_extraction_results"]):::skipped --> x175d0c31cb304b2e["test_extraction_results_wide"]:::queued
    x175d0c31cb304b2e["test_extraction_results_wide"]:::queued --> xb1c6a2247c4c5b75["test_extraction_results_wide_csv"]:::queued
    xd809c765cde4125f(["test_extraction_results_wide_csv_file_path"]):::queued --> xb1c6a2247c4c5b75["test_extraction_results_wide_csv"]:::queued
    x5911de9f8f2c35da(["test_extraction_results"]):::skipped --> x0867df0aee86c553["test_output_checks"]:::completed
    xa1ac5495d621ec68(["test_standards"]):::skipped --> x0867df0aee86c553["test_output_checks"]:::completed
    xa87a62a227d5e627(["llm_parameters"]):::queued
    xec2d391ea0f39691(["text_extraction_handwriting_report"]):::queued
  end
```

To run the workflow, issue the following command in R from within the
project directory

``` r
targets::tar_make()
```

or issue the following command in Terminal from within the project
directory

``` bash
Rscript -e  "targets::tar_make()"
```

## Authors

- Dr Sylvie Pool - University of Oxford
- Dr Ernest Guevarra - University of Oxford

## License

All code in this project is released under a
[GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html#license-text)
license. All text in this project is released under a
[CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.en)
license. All data is released under a
[CC0](https://creativecommons.org/public-domain/cc0/) license.

## Citation

If you use the code, text, and/or data provided in this repository in
your work/research, please cite this work using the suggested
appropriate citation provided in
[CITATION.cff](https://github.com/OxfordIHTM/computer-vision-demo/blob/main/CITATION.cff).

[^1]: The `llama3.2-vision:90b` model was used and tested but the
    extraction step continually failed to complete successfully. On
    further investigation, it was found that the current version of
    Ollama didn’t support this specific model yet. The model was not
    used in the final workflow until the next version of Ollama.
