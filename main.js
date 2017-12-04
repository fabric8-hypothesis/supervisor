//  OpenShift sample Node application
var express = require('express'),
    bodyParser = require("body-parser"),
    app     = express();
    
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

var port = process.env.PORT || process.env.OPENSHIFT_NODEJS_PORT || 9090,
    ip   = process.env.IP   || process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0';

var routes = require("./src/api/routes.js")(app);

//Setting up server
var server = app.listen(port, function () {
    var port = server.address().port;
    console.log("App now running on port", port);
});
