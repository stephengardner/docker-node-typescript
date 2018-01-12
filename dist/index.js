const app = require('express')();
const http = require('http');
const server = http.createServer(app);
const io = require('socket.io')(server);
app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});
io.on('connection', function (socket) {
    socket.on('chat message', function (msg) {
        io.emit('chat message', msg);
    });
});
app.set('port', (process.env.PORT || 3000));
console.log('The port is:::: ', app.get('port'));
server.listen(app.get('port'), () => {
    console.log('---> listening on port ', app.get('port'));
});
io.on('connection', (socket) => {
    console.log('Client connected');
    socket.on('disconnect', () => console.log('Client disconnected'));
});
//# sourceMappingURL=index.js.map