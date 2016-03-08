var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
// var rapgeniusClient = require("rapgenius-js");
// var rapgeniusClient = require("./node_modules/rapgenius-js/src/geniusClient");
// var lyrics = require('node-lyrics');
// var lyr = require('lyrics-fetcher');
var giphy = require('giphy-api')();
var _ = require('underscore-node');
var gifs
var myGifs
app.set('port', (process.env.PORT || 5000));
var server = app.listen(app.get('port'), function() {
  console.log('listening on port', app.get('port'));
});
var io = require('socket.io').listen(server);

io.sockets.on('connection', function (socket) {
  console.log('SERVER::WE ARE USING SOCKETS!');
  console.log(socket.id);

  socket.on("location", function(data) {
            console.log(data)
//	console.log('a vote for javascript')
//	io.sockets.emit("updateJavascript")
//	});
//	socket.on("swift", function(data) {
//	console.log('a vote for swift!')

//	io.sockets.emit('updateSwift')
	})
});

app.post('/intro', function(req, res) {
	giphy.search({
    q: req.body.title,
    limit: 25,
    fmt: JSON
}, function(err, data) {
    console.log(data)
    

//     } else {
    	 console.log(" ")
    	gifs = (data);
        gif = gifs["data"];
        myGifs = _.pluck(gifs["data"], "embed_url");
        console.log(myGifs, "we did it! off tot he front")
            res.send(myGifs)	
    	});
})


app.post('/lyrics', function(req, res) {
	console.log(req.body.title)
	var terms = req.body.title.split(" ")

	var gifs
	var myGifs

	console.log("going to search", req.body.title)
    giphy.search({
    q: req.body.title,
    limit: 10,
    fmt: JSON
},  function(err, data) {
    console.log(data)

    	 console.log(" ")
    	gifs = (data);
        gif = gifs["data"];
        myGifs = _.pluck(gifs["data"], "embed_url");
        console.log(myGifs, "we did it! off to the front")
        if (myGifs = []) {
        	var shorter = req.body.title.split(" ")
        	var newSearch = shorter[0]
				giphy.search({
				    q: newSearch,
				    limit: 10,
				    fmt: JSON
				}, function(err, data) {
				    console.log(data)
				    

				//     } else {
				    	 console.log(" ")
				    	gifs = (data);
				        gif = gifs["data"];
				        myGifs = _.pluck(gifs["data"], "embed_url");
				        console.log(myGifs, "we did it! off tot he front")
				            res.send(myGifs)	
				    	});
					} else {
						res.send(myGifs)
					}

						
        	///
        }
            
        
    	);
	});


app.listen(8000, function() {
  console.log("Party on port 8000");
})