var req_handlers = require("./handlers.js").request_handlers()

var appRouter = function(app) {
    app.post("/api/v1.0/stats", function(req , res){
        console.log('The request body is: ', req.body)
        req_handlers.handle_stats_ingestion(req.body).then(function (result) {
            res.send(String(result));
        }).catch(function(err) {
            console.log('Error '+ err.toString());
            // ToDo: Fix Http Status code to non 200
            res.status(400)
            res.send(err.toString());
        });
    });
}

module.exports = appRouter;