var utils = require("../utils/util.js").utils()
var metric_utils = require("../utils/metric_util.js").metric_utils()

module.exports.request_validations = function () {
    return {
        validate_stat: function (stat) {
            var valid = !utils.isEmpty(stat)
            // TODO(anmolbabu): Add more validations like stat metadata validation
            return valid;
        },

        validate_experiment: function (experiment) {
            var valid = !utils.isEmpty(experiment);
            return valid;
        },

        validate_metrics: function (metrics) {
            var managed_metrics = metric_utils.get_all_managed_data_types();
            var invalid_datas = metrics.filter((x) => !managed_metrics.includes(x));
            if (invalid_datas.length > 0 || managed_metrics.length <= 0 || metrics.length <= 0) {
                return false;
            } else {
                return true;
            }
        },

        validate_expression: function (expression) {
            // TODO(mik-dass): Add more validations
            if (expression != undefined && expression != '' && expression.length > 0) {
                return true;
            } else {
                return false;
            }
        }
    }
}