var utils = require("../utils/util.js").utils()

module.exports.request_validations = function() {
    return {
        validate_stat: function(stat) {
            var valid = !utils.isEmpty(stat)
            // TODO(anmolbabu): Add more validations like stat metadata validation
            return valid;
        }
    }
}