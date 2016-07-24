#!/usr/bin/env bash

rsync -ar /media/windows-data/Music/mp3/ \
  asonix@dank.software:/opt/minidlna/Music/other
rsync -ar /media/windows-data/Music/bandcamp\ etc/ \
  asonix@dank.software:/opt/minidlna/Music/main
