var req_validations = require("./validations.js").request_validations()

module.exports.request_handlers = function() {
    return {
        handle_stats_ingestion: function(stat) {
            return new Promise(function(resolve, reject) {
                // Validate Params
                var valid = req_validations.validate_stat(stat)
                if (valid instanceof Error) {
                    reject(
                        "Post request failed with error. Err:",
                        valid.toString()
                    );
                } else {
                    if (valid) {
                        resolve("SUCCESS");
                    } else {
                        reject("Stat " + JSON.stringify(stat) + " not of supported type");
                    }
                }
                // ToDo(anmolbabu):
                // 1. Check if stat is required by an experiment
                // 2. If stat relevant to one/more experiments, for each experiment,
                //    Using metadata, check if stat pertains to relevant resource
                //  a. Evaluate stat against the experiments' expressions
                //  b. Persist results of experiment evaluations under
                //     relavant experiment namespaces
            });
        }
    }
}