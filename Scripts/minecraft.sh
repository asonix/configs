#!/usr/bin/env bash

cd ~/servers/minecraft-server
java -server -Xmx2048M -Xms2048M -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -jar minecraft_server.1.8.8.jar nogui
