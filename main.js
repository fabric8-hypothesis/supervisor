//  OpenShift sample Node application
var express = require("express"),
	app     = express()

app.use(express.json())
app.use(express.urlencoded({ extended: true }))

var port = process.env.HDD_SUPERVISOR_PORT || 9090

var server = app.listen(port, function () {
	var port = server.address().port
	console.log("App now running on port", port)
})

module.exports = server
