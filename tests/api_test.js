var chai = require('chai'),
    chaiHTTP = require('chai-http'),
    should = chai.should(),
    expect = require('chai').expect;

chai.use(chaiHTTP);

const host = require('../main.js');

describe('Test data collection api', function () {

    it('POST to /api/v1.0/stats should return 200', function (done) {
        chai.request(host)
            .post('/api/v1.0/stats')
            .set('Content-Type', 'application/json')
            .send({ myparam: 'test' })
            .end(function (err, res) {
                res.should.have.status(200);
                done();
            })

    })

    it('POST to /api/v1.0/stats should return 400', function (done) {
        chai.request(host)
            .post('/api/v1.0/stats')
            .set('Content-Type', 'application/json')
            .send({})
            .end(function (err, res) {
                res.should.have.status(400);
                done();
            })

    })
})


describe('Test experiment api', function () {

    var metric_utils = require('../src/utils/metric_util.js').metric_utils();

    it('GET to /api/v1.0/experiments should return 200 and the constants.js metrics', function () {
        return chai.request(host)
            .get('/api/v1.0/experiment')
            .then(function (res) {
                expect(res).to.have.status(200);
                expect(res).to.be.json;
                expect(res.body.metrics).to.deep.equal(metric_utils.get_all_managed_data_types());
            });
    });

    it('POST to /api/v1.0/experiments with correct data should return 200', function () {
        return chai.request(host)
            .post('/api/v1.0/experiment')
            .set('Content-Type', 'application/json')
            .send({
                "metrics": metric_utils.get_all_managed_data_types().slice(0, 1),
                "expression": "X+5=4"
            })
            .then(function (res) {
                expect(res).to.have.status(200);
            });
    });

    it('POST to /api/v1.0/experiments with invalid metrics should return 400', function () {
        return chai.request(host)
            .post('/api/v1.0/experiment')
            .set('Content-Type', 'application/json')
            .send({
                "metrics": ["fdgf", "afsfdss"]
                , "expression": "X+5=4"
            })
            .then(function (res) {
                throw new Error("The invalid metrics are correct");
            })
            .catch(function (err) {
                expect(err).to.have.status(400);
            });
    });

    it('POST to /api/v1.0/experiments with empty metrics should return 400', function () {
        return chai.request(host)
            .post('/api/v1.0/experiment')
            .set('Content-Type', 'application/json')
            .send({ "metrics": [], "expression": "x+5=2" })
            .then(function (res) {
                throw new Error("The invalid metrics are correct");
            })
            .catch(function (err) {
                expect(err).to.have.status(400);
            });
    });

    it('POST to /api/v1.0/experiments with empty expression should return 400', function () {
        return chai.request(host)
            .post('/api/v1.0/experiment')
            .set('Content-Type', 'application/json')
            .send({ "metrics": ["CPU"], "expression": "" })
            .then(function (res) {
                throw new Error("The invalid metrics are correct");
            })
            .catch(function (err) {
                expect(err).to.have.status(400);
            });
    });

});