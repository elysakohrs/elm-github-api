const Elm = require('./Main.elm');
const config = require('./config.json');

const root = document.getElementById('root');
const date = new Date().toISOString();

Elm.Main.embed(root, { ...config, date });
