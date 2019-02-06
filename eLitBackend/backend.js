let server = '127.0.0.1'
let port = '9999'


class Connection {

    constructor(server, port) {


        this.ws = new WebSocket('ws://'+server+':'+port+'/')

        this.handlers = {}

        let _self = this

        this.ws.onopen = function() {
            console.log("Socket opened")
        }

        this.ws.onerror = function() {
            console.log("Socket error")
        }
        this.ws.onmessage = function (event) {
            _self.handle(JSON.parse(event.data))
        }

    }

    bind(request, handler) {

        this.handlers[request] = handler

    }

    handle(payload) {

        let handler = this.handlers[payload.request]


        if (handler === undefined) {

            console.log('No handler for request: ' + payload.request)

        }
        else {

            handler(payload.data)

        }

    }

}

let connection = new Connection(server, port)

// ------------------------------------------- HANDLERS -------------------------------------------

let ws_ingredient_handler = (ingredients) => {

    ingredients.reverse().forEach(function (ingredient) {

        let c = '<tr>';

        c += '<td>'+ingredient.name+'</td>';
        c += '<td>'+ingredient.grade+'</td>';
        c += '<td>'+ingredient.image+'</td>';
        c += '<td>'+ingredient.ingredient_description+'</td></tr>';

        $(".ingredient").prepend(c);

    })



}

let table_new_line_handler = (_class, _conn) => {

    let _new = $("." + _class + " > tbody > tr")

    let request = {request: 'insert_' + _class , data : {}}

    $(_new).find('input').each(function () {

        if ($(this).attr('type') != 'button') {

            var key = $(this).attr('name')
            var val = $(this).val()

            request.data[key] = val


        }
    })

    console.log(request)

    _conn.ws.send(JSON.stringify(request))

}

// ------------------------------------------- BINDING ---------------------------------------------

connection.bind('fetch_ingredients', ws_ingredient_handler)


// ------------------------------------------- OBSERVERS -------------------------------------------

$(document).ready(function () {

    let tables = ['ingredient', 'drink']

    tables.forEach(function (table) {

        $('.' + table).on("click", ".add-" + table, function () {

            table_new_line_handler(table, connection)

        })

    })


})