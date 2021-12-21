## My blog and home page

### Local build instructions

```
$ docker run -it -u `id -u`:`id -g` -p 8888:4000 -v `pwd`:/workdir -w /workdir --entrypoint /bin/bash jekyll-simonis.io
bash-5.0$ bundle exec jekyll serve --host 0.0.0.0
```

`jekyll-simonis.io` is built from `.github/actions/my-jekyll-action/Dockerfile` with:

```
$ docker build -t jekyll-simonis.io -f Dockerfile .
```

After pushing it's necessary to pull from origin after the website was rebuilt because currently the sources and the website itself live in the same branch! If you forgot to pull and committed local changes, just do:

```
$ git pull --rebase=true
```

This will rebase your local changes on to of the auto-generated changes from origin. A clean rebase should always be possible, because GitHub actions only push changes to the `docs/` subdirectory from which the site is served and which shouldn't be touched locally.

