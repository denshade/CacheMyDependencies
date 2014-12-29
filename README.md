CacheMyDependencies
===================

This tool caches vendors based on a recipe file.

Some build tools have the following problem: 

Start a build or a deploy using a recipe eg. composer.json
Building creates vendor directories and fills them in.

If you have the same recipe this implies the same vendor directories each time you build.
While most tools can cache these vendors they do on occasion:

1. Still use a boatload of cpu/memory. Even though all dependencies are already installed and haven't changed.  
2. Don't properly use the cache/have horrible issues.
3. Download the dependencies each time, depend very strongly on third-party servers.
4. Even though resolvable some dependencies are flexible. So what you tested is not what you are putting to production.

This tool allows you to stash your vendors on YOUR server.

`Usage: cacheBuild.sh SOURCEBUILDFILE BUILDDIRECTORY BUILDCOMMAND REPODIRECTORY"`

+ SOURCEBUILDFILE: This is your recipe file. eg. composer.json
+ BUILDDIRECTORY: This is the directory where the vendors are installed. eg. vendor
+ BUILDCOMMAND: The file that contains your build command that installs the vendors. eg. build.sh
+ REPODIRECTORY: Directory to store the snapshots of the vendors. eg. /mnt/myRepo. This will usually be a mount to your repository server.


