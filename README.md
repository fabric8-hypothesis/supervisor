# supervisor

The supervisor/scout-master is focused on the collection, aggregation and storage of data obtained from scouts/sensors. The context of received information is determined by supervisor managed experiments. The supervisor becomes the heart and brains of the observable platform, exposed as a service through several api endpoints. In summary the responsibilities are as follows:

* Expose an experiment management api. This api is the mechanism used to create and coordinate experiments. This coordination includes configuration, execution and lifecycle semantics of isolated experiments. Another management aspect is the user driven design of schemas that serve as contracts for measurement data transmitted to the supervisor. Experiments are the means to collect measurements provided by scouts deployed and distributed throughout the system.  This data collection activity is responsible for validating, cleansing, transforming, filtering, correlating, aggregating and potentially storing ( for non transient ) collected data at predetermined intervals in an isolated manner.
* Expose a data retrieval api to make available experimental data
* Expose a data collection api that serves as the central destination for data sent by observing scouts
