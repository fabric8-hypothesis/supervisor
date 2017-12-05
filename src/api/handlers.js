var req_validations = require("./validations.js").request_validations()
var metric_utils = require("../utils/metric_util.js").metric_utils()

module.exports.request_handlers = function () {
    return {
        handle_stats_ingestion: function (stat) {
            return new Promise(function (resolve, reject) {
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
        },

        handle_get_managed_data_types: function () {
            return new Promise(function (resolve, reject) {
                var metrics = metric_utils.get_all_managed_data_types();
                if (metrics instanceof Error) {
                    reject(
                        "Post request failed with error. Err:",
                        metrics.toString()
                    );
                } else {
                    var data = {
                        ["metrics"]: metrics
                    }
                    resolve(data);
                }
            });
        },

        handle_experiment_ingestion: function (experiment) {
            return new Promise(function (resolve, reject) {
                var metrics = experiment.metrics;
                var expression = experiment.expression;

                var empty = req_validations.validate_experiment(experiment);
                var valid_metrics = req_validations.validate_metrics(metrics);
                var valid_expression = req_validations.validate_expression(expression);
                if (empty && valid_metrics && valid_expression) {
                    resolve("SUCCESS");
                }
                else {
                    reject("Bad request 400 : Invalid data");
                }
            });
        }
    }
}