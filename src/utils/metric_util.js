const metrics=require('./constants.js').metrics;

module.exports.metric_utils=function(){
    return {
        get_all_managed_data_types: function(){
            return metrics;
        }
    }
}