Setting up
==========

Setting up your project to be able to use the libtun library is a very easy process. For this you will need the
D package manager, [`dub`](https://code.dlang.org/), installed. If you had installed the D programming language
via the [`dmd`](https://dlang.org/download.html#dmd) package then dub would already be installed along with it.

### Setting up dub repository

Once that is done, you will want to initialize your current project directory as a dub repository by running the
following and then filling in the queries as you are prompted:

```bash
cd my-project/
dub init
```

### Adding libtun

You can now add the libtun library dependency to your project with one command:

```
dub add libtun
```

Upon your next build (via dub) the package will be fetched, however to force it _now_ just run:

```
dub build
```