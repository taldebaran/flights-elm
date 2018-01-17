Software Requirements:
  1. Follow the nodejs and npm installation instructions to install these in your system.  In MacOS you can use "brew
  install nodejs" to install nodejs.

Setup
- run "npm install"
- run "elm-package install"
- run "elm make src/Main.elm --output=assets/scripts/flight-status.js"
- start local server by running "elm-reactor --port=8000" to run on port 8000
- navigate browser to "localhost:8000/index.html"

PS: livereload was not utilized.
