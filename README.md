# Sorcerio's Computer Craft Scripts

- [Sorcerio's Computer Craft Scripts](#sorcerios-computer-craft-scripts)
  - [Overview](#overview)
  - [The Scripts](#the-scripts)
    - [Ore Scanner](#ore-scanner)
    - [AE-2 Flower Harvester](#ae-2-flower-harvester)
  - [Installing in ComputerCraft](#installing-in-computercraft)

---

## Overview

This repository contains Git Submodule links to all my released [ComputerCraft](https://tweaked.cc) scripts.
Each script can be downloaded indivigually onto a ComputerCraft computer in-game ([as detailed below](#installing)) or you can [clone](https://git-scm.com/docs/git-clone) this entire repo for a full collection.

## The Scripts

### Ore Scanner

A ComputerCraft and Advanced Peripherals script to scan for ores around the player and display the results in a radar.
Requires the [Advanced Peripherals](https://www.curseforge.com/minecraft/mc-mods/advanced-peripherals) mod to function.

```bash
wget https://gist.github.com/SorcerioTheWizard/6e363dd7186148677fcfd17d169e631b/raw scanner
```

[Source](https://gist.github.com/SorcerioTheWizard/6e363dd7186148677fcfd17d169e631b)

### AE-2 Flower Harvester

A Turtle script for automatically harvesting from an Applied Energetics 2 Certus Quarts Grower design.

```bash
wget https://gist.github.com/SorcerioTheWizard/452d007ca20ebca9b9a0ec6f84b0a036/raw harvest
```

[Source](https://gist.github.com/SorcerioTheWizard/452d007ca20ebca9b9a0ec6f84b0a036)

## Installing in ComputerCraft

To install a specific script onto your in-game ComputerCraft computer do the following:

1. Go to the Gist page for the script you'd like to install.
1. Copy the _raw text_ URL by right clicking the `Raw` button on the main code panel and selecting `Copy Link Address`.
    * Alternatively, click the `Raw` button and copy the URL from the plain text page you are brough to.
1. Open your in-game ComputerCraft computer.
1. Install the script to the CC computer by typing: `wget <SCRIPT_URL> <SCRIPT_NAME>`.
    * `<SCRIPT_URL>` is the URL that you copied from `Raw` button.
    * `<SCRIPT_NAME>` is the name that the script will be saved as on the in-game CC computer.
1. Wait for the download to complete.
1. Type your chosen `<SCRIPT_NAME>` to start the program.

> **Tip:** Naming any script `startup` will run the script whenever the CC computer is started.
