# pysys-action
Github action to run pysys.py in the APES environment.
It looks for the `pysysproject.xml` in the github workspace and runs
`pysys.py` in the given `testdir` directory within in the found
directory.
The resulting test reports are put into a `CItests` directory.

## Inputs

### `testdir`

**Required** The (relative) path in the pysysproject root directory
(identified by the location of `pysysproject.xml`). Default: `./`.

### `exepath`

**Required** A path to add to the `$PATH` environment variable to
look for executables. This path is relative to the github workspace,
prepended to `$PATH` and defaults to `build`.

## Outputs

### `testrundir`

Path to the directory in which the pysys tests actually were executed
relative to the workspace directory.
