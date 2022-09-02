---
title: Documentation Contributor Guide
layout: base
---

### Getting Started

**Pre-requisites**

1. [Get Docker](https://docs.docker.com/get-docker/)
2. Clone this repository via git command line or a graphical tool such as GitHub Desktop.
3. Fork this repository.

**run the project**

```sh
# inside this repository
docker-compose up
```

### Making Changes

1. Open the project in a project editor like VIM or an IDE such as Visual Studio Code.
2. Understand the project structure.
3. _data/menus.yml controls which markdown files will be displayed.
4. Leading folders such as portmaster, spn, and safing represent the main menu.
5. Additional folders and the menu structure can be understood from the _data/menus.yml
6. Add, delete and modify as needed.
7. Hopefully obviously, commit your changes when ready, create a pull request.

[More Detailed Information](https://jekyllrb.com/docs) on the Jekyll project.
