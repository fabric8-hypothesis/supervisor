var server   = require("../main"),
	chai     = require("chai"),
	chaiHTTP = require("chai-http"),
	should   = chai.should()

chai.use(chaiHTTP)

describe("Test data collection api", function() {

	describe("POST to /api/v1.0/stats", () => {
		it(" should return 200", function(done){
			chai.request(server)
				.post("/api/v1.0/stats")
				.set("Content-Type", "application/json")
				.send({myparam: "test"})
				.end(function(err, res) {
					res.should.have.status(200)
					done()
				})
		})
	})


	describe("POST to /api/v1.0/stats", () => {
		it("should return 400", function(done){
			chai.request(server)
				.post("/api/v1.0/stats")
				.set("Content-Type", "application/json")
				.send({})
				.end(function(err, res) {
					res.should.have.status(400)
					done()
				})
		})
	})

})

describe("Test readiness and liveness api",function(){
	
	describe("POST to /api/v1.0/readiness", () => {
		it(" should return 200", function(done){
			chai.request(server)
				.get("/api/v1.0/readiness")
				.end(function(err, res) {
					res.should.have.status(200)
					done()
				})
		})
	})

	describe("POST to /api/v1.0/liveness", () => {
		it(" should return 200", function(done){
			chai.request(server)
				.get("/api/v1.0/liveness")
				.end(function(err, res) {
					res.should.have.status(200)
					done()
				})
		})
	})
})
