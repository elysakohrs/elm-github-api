const Elm = require('./Main.elm');
const config = require('./config.json');

const root = document.getElementById('root');
const date = new Date().toISOString();

var storedModel = localStorage.getItem('elm-github-model');
var startingModel = storedModel ? JSON.parse(storedModel) : null;

var app = Elm.Main.embed(root, { config: {...config, date}, initialState: startingModel });
app.ports.setJsStorage.subscribe(function (model) {
    console.log('from elm! ', model);
    localStorage.setItem('elm-github-model', JSON.stringify(model));
});