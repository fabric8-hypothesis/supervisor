var MongoClient = require('mongodb').MongoClient;
var util = require('util');

console.log(process.env);

var mongo_db_host = process.env.HDD_SUPERVISOR_PORT_27017_TCP_ADDR || "127.0.0.1"
var url = util.format('mongodb://hdd-supervisor:hdd-supervisor@%s:27017/hdd-supervisor', mongo_db_host);

MongoClient.connect(url, function(err, db){
	if (err) {
		throw err;
	}
	console.log("Connected")
	var dbase = db.db("hdd-supervisor");
	dbase.createCollection('Stats', function(err, res){
		if (err) throw err;
		console.log("Collection created");
		db.close();
	});
});

MongoClient.connect(url, function(err, db){
	if (err) {
		throw err;
	}
	console.log("Connected")
	var dbase = db.db("hdd-supervisor");
	dbase.collection('Stats').insertOne({
		Name: 'pod1.cpu',
		Stats: [{40: 10009087}, {50: 10009088}]
	});
	db.close();
});

MongoClient.connect(url, function(err, db){
	if (err) {
		throw err;
	}
	console.log("Connected")
	var dbase = db.db("hdd-supervisor");
	var cursor = dbase.collection('Stats').find();
	cursor.each(function(err, doc) {
		console.log(doc);
	});
});
