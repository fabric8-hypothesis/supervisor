var server   = require('../server'),
    chai     = require('chai'),
    chaiHTTP = require('chai-http'),
    should   = chai.should();

chai.use(chaiHTTP);

describe('Test data collection api', function() {
    var host = "http://" + '0.0.0.0' + ':' + 9090;

    it('POST to /api/v1.0/stats should return 200', function(done){
        chai.request(host)
        .post('/api/v1.0/stats')
        .set('Content-Type', 'application/json')
        .send({myparam: 'test'})
        .end(function(err, res) {
            res.should.have.status(200);
            done();
        })

    })

    it('POST to /api/v1.0/stats should return 400', function(done){
        chai.request(host)
        .post('/api/v1.0/stats')
        .set('Content-Type', 'application/json')
        .send({})
        .end(function(err, res) {
            res.should.have.status(400);
            done();
        })

    })
})
