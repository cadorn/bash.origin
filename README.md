

| License | Source | &#8212;&raquo; | [Website](https://github.com/bash-origin/bash.origin/tree/master/workspace.sh) | [npm](https://github.com/npm/npm) |
| :---: | :---: | :---: | :---: | :---: |
| [FPL](https://opensource.org/licenses/FPL-1.0.0) | [github.com/bash-origin/bash.origin](https://github.com/bash-origin/bash.origin) | [![CircleCI](https://circleci.com/gh/bash-origin/bash.origin.svg?style=svg)](https://circleci.com/gh/bash-origin/bash.origin) | [bash-origin.github.io/bash.origin](https://bash-origin.github.io/bash.origin) | [bash.origin](https://www.npmjs.com/package/bash.origin)


[bash.origin](https://bash-origin.github.io/bash.origin)
===

**Status: BETA**

The original spark for this project came from needing an easy way to get the **path of the current Bast script** which is [way harder than it should be](http://stackoverflow.com/a/246128/330439).

It has turned into a set of [Bash](https://www.gnu.org/software/bash/) conventions and utilities to bootstrap a system.

I needed a consistent starting point for Bash scripts so I don't have to re-write the same code over and over when writing scripts to bootstrap `node` and other programs.

I also needed a way to share common scripts between projects. I use these scripts to assemble runtime dependencies and boot my programs into specific contexts.

Running everything through a central script allows me to inject tooling logic and monitor the system from outside of the process, project and system.

**NOTE: The documentation below is OUT OF DATE.**


Overview
--------

`bash.origin` ensures that when you run a script to install a project or do some work such as run `node` it is launched using a consistent set of [environment variables](http://en.wikipedia.org/wiki/Environment_variable) and pre-provisioned assets.

This can be used to *bootstrap a system* by ensuring **ALL ENTRY POINTS** to the system **FIRST SOURCE bash.origin BEFORE DOING ANYTHING**. Once this is achieved, one can use `bash.origin` to, among other things, inject common environment variables and custom signing functions which will subsequently be available to all scripts and commands run within the system.


Install
=======

Use in bash to copy the `bash.origin` script to `~/.bash.origin`:

	#!/usr/bin/env bash
	# Source https://github.com/bash-origin/bash.origin
	if [ -z "${BO_LOADED}" ]; then
		if [ ! -f "$HOME/.bash.origin" ]; then
		    curl -s -o ".bash.origin" "https://raw.githubusercontent.com/bash-origin/bash.origin/master/bash.origin?t=$(date +%s)"
		    chmod u+x ./.bash.origin
		    export BO_VERBOSE=1
		    ./.bash.origin BO install
		fi
	    . "$HOME/.bash.origin"
	fi

Use [npm](http://npmjs.org) to copy the `bash.origin` script to `~/.bash.origin`:

	npm install -g bash.origin

Use as a [npm](http://npmjs.org) package dependency to copy the `bash.origin` script to `~/.bash.origin` when your package is installed:

	npm install bash.origin --save


Usage
-----

No matter how `bash.origin` was installed above; it can be used in any script thereafter using:

````
#!/usr/bin/env bash
# Source https://github.com/cadorn/bash.origin
if [ -z "$BO_ROOT_SCRIPT_PATH" ]; then . "$HOME/.bash.origin"; else . "$BO_ROOT_SCRIPT_PATH"; fi
...
````


Demo/Tests
----------

	./examples/run.sh


Examples
--------

  * [examples/01-HelloWorld](https://github.com/cadorn/bash.origin/tree/master/examples/01-HelloWorld) - Simple variable passing and common functions using [npm](http://npmjs.org) package layout.
  * [examples/02-SourceMultiplePrototypes](https://github.com/cadorn/bash.origin/tree/master/examples/02-SourceMultiplePrototypes) - Variable scope isolation when sourcing multiple prototypes.
  * [examples/03-CliPlugin](https://github.com/cadorn/bash.origin/tree/master/examples/03-CliPlugin) - Plugin implementations callable from the command-line using a common framework.
  * [examples/04-ProvisionWithSMI](https://github.com/cadorn/bash.origin/tree/master/examples/04-ProvisionWithSMI) - Provision dependencies for a package using [smi](https://github.com/sourcemint/smi).
  * [examples/05-DownloadToSystemCache](https://github.com/cadorn/bash.origin/tree/master/examples/05-DownloadToSystemCache) - Download a file from a URL to the local system cache.
  * [examples/06-ModifyPromptWithPlugin](https://github.com/cadorn/bash.origin/tree/master/examples/06-ModifyPromptWithPlugin) - Modify the prompt using the [github.com/bash-origin/bash.origin.prompt](https://github.com/bash-origin/bash.origin.prompt) plugin.


Conventions
===========

### 1. Bash Module Boilerplate

	#!/usr/bin/env bash
	# Source https://github.com/cadorn/bash.origin
	. "$HOME/.bash.origin"
	function init {
		eval BO_SELF_BASH_SOURCE="$BO_READ_SELF_BASH_SOURCE"
		BO_deriveSelfDir ___TMP___ "$BO_SELF_BASH_SOURCE"
		local __BO_DIR__="$___TMP___"

		...
	}
	init

NOTE: Sourcing `$HOME/bash.origin` will:
  * run `BO_sourceProfile`
  * set `VERBOSE=1` environment variable if `-v` flag found in invocation arguments

#### Custom `bash.origin`

If `BO_ROOT_SCRIPT_PATH` is set (to a path pointing to a specific revision of `bash.origin`) prior to sourcing `bash.origin` the specified script will be delegated to by `$HOME/.bash.origin` as soon as it loads.


### 2. Use `__BO_DIR__` for own script file directory


### 3. Use `BO_sourcePrototype` to setup a common environment for programs

The idea is that by *knowing your own script directory* (`__BO_DIR__`) you can **include a common package** that is included by all packages of your system that have scripted *entry points*. This common package contains a **script prototype** which is sourced by all scripts.

For an example see [examples/01-HelloWorld](https://github.com/cadorn/bash.origin/tree/master/examples/01-HelloWorld).


### 4. Call `BO_run_*` to run common programs

The following programs are supported:

  * [node](http://nodejs.org)

The program is installed on first use if it is not already installed.

To install the program for instant access later, simply call it once and ask it for its version. i.e. `BO_run_node -v`


### 5. Use `BO_systemCachePath` to keep system-global code packages

Every global code package has a hostname-based URI and version:

	BO_systemCachePath CACHED_PATH "$ID" "$VERSION"

The path returned for the above call will be:

	"$BO_SYSTEM_CACHE_DIR/$ID~$VERSION_MAJOR/source/installed/master"

if found, or if not:

	"$BO_SYSTEM_CACHE_DIR/$ID~$VERSION_MAJOR/source/snapshot/$VERSION"

The whole point is that these **paths are predictable** and can be assumed as provisioned by programs booted using `bash.origin` *by the time the program boots*.



Utilities
=========

### `BO_resetLoaded`

Reset various environment variables so that BO can be sourced into the current shell again.

### `BO_now`

Assign the current unix timestamp to a variable.

		BO_now "ts"

### `BO_format`

Log wrapped data or other templates:

	BO_format "$VERBOSE" "HEADER" "Section Heading"
	...
	BO_format "$VERBOSE" "FOOTER"


### `BO_has`

Check if a command is available using `if BO_has "curl"; then ...`.


### `BO_setResult`

Used in functions to return values:

	function ourFunc {
		BO_setResult $1 "result"
	}
	ourFunc RESULT_VAR ...


### `__BO_DIR__` of own script

	eval BO_SELF_BASH_SOURCE="$BO_READ_SELF_BASH_SOURCE"
	BO_deriveSelfDir ___TMP___ "$BO_SELF_BASH_SOURCE"
	local __BO_DIR__="$___TMP___"

Use a *local* variable in the `init` function to keep the scope local to the module.


### `BO_sourceProfile`

Load the bash profile from `$HOME/*` to init the environment.


### `BO_followPointer`

Follow a pointer file which may be a symlink to anotehr repo with a pointer file or a file containing a filepath.

	BO_followPointer "Z0_ROOT" "$PWD" ".0"


### `BO_checkVerbose`

Check if `-v` was specified on the command line.


### `BO_sudo`

Run a command using `sudo`.


### `BO_realpath`

Return the realpath of a path.


### `BO_ensure_executable`

Make sure a command at a given path is executable.


### `BO_dedupe_PATH`

Removes duplicate paths from the `PATH` environment variable.


### `BO_strip_PATH`

Remove a path from the `PATH` environment variable.


### `BO_prepend_PATH`

Prepend a path to the `PATH` environment variable.


### `BO_if_os`

Test for `linux`, `darwin` and others against `$OSTYPE`

Example: `BO_if_os linux && ...`


### `BO_if_nix`

Test for `gnu`, `bsd` and `sun`.

Example: `BO_if_nix gnu && ...`


### `BO_log`

Log a message respecting *verbose* flag:

	BO_log "$VERBOSE" "Log message"


### `BO_ensure_nvm`

Ensure [nvm](https://github.com/creationix/nvm) is installed.


### `BO_ensure_node`

Ensure the latest stable version of [node.js](http://nodejs.org) is installed using [nvm](https://github.com/creationix/nvm).


### `BO_run_node`

Run a [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) file using [node](http://nodejs.org).


### `BO_run_npm`


### `BO_ensure_iojs`

Ensure the latest stable version of [io.js](http://iojs.org) is installed using [nvm](https://github.com/creationix/nvm).


### `BO_run_iojs`

Run a [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) file using [io.js](http://iojs.org).


### `BO_link_*`

`BO_link_* "$BIN_BASE_PATH"` works for:

  * `BO_link_node`
  * `BO_link_npm`
  * `BO_link_smi`


### `BO_isSourced`

Determine if the current script is being sourced using `BO_sourcePrototype`.

	BO_isSourced IS_SOURCED


### `BO_sourcePrototype`

Allows scripts to inherit from other scripts.

For a nested example see [examples/02-SourceMultiplePrototypes](https://github.com/cadorn/bash.origin/tree/master/examples/02-SourceMultiplePrototypes).


### `BO_requireModule`

Allows scripts to reference CommonJS style(ish) modules with locally scoped functions and variables.

Internal module variables leak to the global scope so this is not a security solution! Just a very handy scope abstraction.

For a nested example see [examples/08-ModuleSyntax](https://github.com/cadorn/bash.origin/tree/master/examples/08-ModuleSyntax).


### `BO_systemCachePath`

Example:

	BO_systemCachePath CACHED_PATH \
		"github.com/sourcemint/smi" \
		"$BO_VERSION_SMI_CLI" \
		"install"


### `BO_isInSystemCache`

Example:

	BO_isInSystemCache CACHED_PATH \
		"github.com/sourcemint/smi" \
		"$BO_VERSION_SMI_CLI" \
		"install"


### `BO_downloadToSystemCache`

	BO_ensureInSystemCache DOWNLOADED_PATH \
		"github.com/bash-origin/bash.origin" \
		"0.1.5" \
		"https://github.com/bash-origin/bash.origin/archive/v0.1.5.zip"

Extracts archives. Replaces if already exists.

### `BO_ensureInSystemCache`

Same as `BO_downloadToSystemCache` but does not replace if already exists.


### `BO_ensureExtracted`

Extract an archive file:

	BO_ensureExtracted EXTRACTED_PATH "$DOWNLOADED_PATH"


### `BO_run_smi`

Run [smi](https://github.com/sourcemint/smi) on a directory in order to install dependencies.

For a simple example see [examples/04-ProvisionWithSMI](https://github.com/cadorn/bash.origin/tree/master/examples/04-ProvisionWithSMI).


### `BO_ensurePlugin`

Make sure a [Bash.Origin](https://github.com/bash-origin) plugin is installed. See `BO_callPlugin`.


### `BO_callPlugin`

Call a [Bash.Origin](https://github.com/bash-origin) plugin and install it if it does not exist.

Taken from the [examples/06-ModifyPromptWithPlugin](https://github.com/cadorn/bash.origin/tree/master/examples/06-ModifyPromptWithPlugin) example which loads the [github.com/bash-origin/bash.origin.prompt](https://github.com/bash-origin/bash.origin.prompt) plugin:

	BO_callPlugin "bash.origin.prompt@0.1.1" setPrompt "workspace" "$__BO_DIR__"

Instead of using a named plugin an absolute path may be specified. i.e. `/path/to/bash.origin.prompt`.


### `BO_cecho`

Write coloured output:

	echo "Hello $(BO_cecho "World" YELLOW)"


Use-Cases
=========

NodeJS Install Script
---------------------

`package.json`:

	{
	  "scripts": {
	    "install": "./bin/install"
	  },
	  "dependencies": {
	    "bash.origin": "0.1.x"
	  }
	}

`bin/install`:

	#!/usr/bin/env bash
	# Source https://github.com/cadorn/bash.origin
	. "$HOME/.bash.origin"
	function init {
		eval BO_SELF_BASH_SOURCE="$BO_READ_SELF_BASH_SOURCE"
		BO_deriveSelfDir ___TMP___ "$BO_SELF_BASH_SOURCE"
		local __BO_DIR__="$___TMP___"

		# Your install code
	}
	init $@


Bootstrapping
=============

Ensure with `curl`
------------------

````sh
if [ ! -z "$VERBOSE" ]; then echo "[ensureBashOrigin] download from: https://raw.githubusercontent.com/bash-origin/bash.origin/d96910b21f2bfd3fc886bde1935efa944c63fc5b/bash.origin"; fi
curl -s -o ".bash.origin" "https://raw.githubusercontent.com/bash-origin/bash.origin/d96910b21f2bfd3fc886bde1935efa944c63fc5b/bash.origin?t=$(date +%s)"
if [ ! -e ".bash.origin" ]; then
    echo -e "\nERROR: Could not download/store bash.origin at '$(pwd)/.bash.origin'!\n"
    echo -e "ACTION: Ensure your current user can write to '$(pwd)/.bash.origin'."
    echo -e "        Ensure 'whoami' gives you the username that matches your '\$HOME' directory! If they do not match, reboot your system and try again.\n"
    exit 1
fi
chmod u+x ./.bash.origin
if [ ! -z "$VERBOSE" ]; then echo "[ensureBashOrigin] source from: ./.bash.origin"; fi
./.bash.origin BO install -f
````


Provenance
==========

Original Source Logic under [Free Public License 1.0.0](https://opensource.org/licenses/FPL-1.0.0) by [Christoph Dorn](http://christophdorn.com) since 2015.

```
Free Public License 1.0.0

Permission to use, copy, modify, and/or distribute this software for any purpose with or 
without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO 
THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT 
SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR 
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION 
OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE 
USE OR PERFORMANCE OF THIS SOFTWARE.
```

> Well-crafted Contributions are Welcome.

**INTENDED USE:** The *Logic and Code contained within* forms a **Developer Tool** and is intended to operate as part of a *Web Software Development Toolchain* on which a *Production System* operates indirectly. It is **NOT INTENDED FOR USE IN HIGH-LOAD ENVIRONMENTS** as there is *little focus on Runtime Optimization* in order to *maximize API Utility, Compatibility and Flexibility*. The logic & code **HAS NOT BEEN VALIDATED BY A SECURITY AUDIT** and is **NOT GUARANTEED** TO KEEP
PRIVATE INFORMATION NOR YOUR IDENTITY SECURE!

If you *need more* than what is contained within, study the Code, understand the Logic, and build your *Own Implementation* that is *API Compatible*. Share it with others who follow the same *Logic* and *API Contract* specified within. This Community of Users will likely want to use Your Work in their own *Software Development Toolchains*.
