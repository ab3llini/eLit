// ------------------------------------------- CONFIG -------------------------------------------

let server = '127.0.0.1'
let port = '9999'

// ------------------------------------------- GLOBALS -------------------------------------------

let ingredient_names = []
let units = ['part']

// ------------------------------------------- CLASSES -------------------------------------------


class Connection {

    constructor(server, port) {


        this.ws = new WebSocket('ws://' + server + ':' + port + '/')

        this.handlers = {}

        let _self = this

        this.ws.onopen = function () {
            console.log("Socket opened")
        }

        this.ws.onerror = function () {
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

        } else {

            handler(payload.data)

        }

    }

}

let connection = new Connection(server, port)


// ------------------------------------------- HANDLERS -------------------------------------------

let ws_ingredient_handler = (ingredients) => {

    ingredients.reverse().forEach(function (ingredient) {

        // Add ingredient name to global var
        ingredient_names.push(ingredient.name)

        $(".ingredient").DataTable().row.add([
            ingredient.name,
            ingredient.grade,
            ingredient.image,
            ingredient.ingredient_description
        ]).draw(false);

    })

}


// ------------------------------------------- UTILS ----------------------------------------------


let on_add_ingredient = (_class, _conn) => {

    let table = $(".new-" + _class).last()

    let request = {request: 'insert_' + _class, data: {}}

    table.find('input').each(function () {

        if ($(this).attr('type') != 'button') {

            var key = $(this).attr('name')
            var val = $(this).val()

            request.data[key] = val

        }
    })

    console.log(request)

    _conn.ws.send(JSON.stringify(request))

    ws_ingredient_handler([request.data])

    update_ingredient_dropdowns()

}

let on_add_drink = () => {

    let form = $('.new-drink-form')

    let request = {request: 'insert_drink', data: {}}




}

let create_options_for = (list) => {

    let options = ''

    list.forEach(function (o) {

        options += '<option>' + o + '</option>'

    })

    return options

}

let update_ingredient_dropdowns = () => {

    $('.components').find('.ingredient-select').append(create_options_for(ingredient_names))

}

let update_unit_dropdowns = () => {

    $('.components').find('.unit-select').append(create_options_for(units))

}





// ------------------------------------------- BINDING ---------------------------------------------

connection.bind('fetch_ingredients', ws_ingredient_handler)


// ------------------------------------------- OBSERVERS -------------------------------------------

$(document).ready(function () {


    let new_drink_table = $('.new-ingredient')

    new_drink_table.on("click", ".add-ingredient", function () {

        on_add_ingredient('ingredient', connection)

    })

    // Handle new recipe step add
    $('.recipe').on('click', '.add-recipe-step', function () {

        $(this).closest('.recipe').append(
            '<div class="form-row">\n' +
            '<div class="form-group col-md-12">\n' +
            '<label>Recipe step</label>\n' +
            '<div class="input-group">\n' +
            '<input type="text" class="form-control" placeholder="Description" name="description">\n' +
            '<div class="input-group-append">\n' +
            '<button class="btn btn-outline-danger remove-recipe-step" type="button">' +
            '<i class="fa fa-minus"></i>\n' +
            '</button>\n' +
            '<button class="btn btn-outline-primary add-recipe-step" type="button">' +
            '<i class="fa fa-plus"></i>\n' +
            '</button>\n' +
            '</div>\n' +
            '</div>\n' +
            '</div>\n' +
            '</div>'
        )

        $('.recipe').on('click', '.remove-recipe-step', function () {
            $(this).closest('.form-row').remove()
        })


    })

    // Handle new recipe step add
    $('.components').on('click', '.add-component', function () {

        $(this).closest('.components').append(
            '<div class="form-row">\n' +
            '<div class="form-group col-md-12">\n' +
            '<label>Component</label>\n' +
            '<div class="input-group">\n' +
            '<input type="number" class="form-control" placeholder="Quantity" name="quantity">\n' +
            '<select class="custom-select unit-select" name="unit">\n' +
            '<option selected>Choose...</option>\n' +
            create_options_for(units) +
            '</select>\n' +
            '<select class="custom-select ingredient-select" name="ingredient">\n' +
            '<option selected>Choose...</option>\n' +
            create_options_for(ingredient_names) +
            '</select>\n' +
            '<div class="input-group-append">\n' +
            '<button class="btn btn-outline-danger remove-component" type="button">\n' +
            '<i class="fa fa-minus"></i>\n' +
            '</button>\n' +
            '<button class="btn btn-outline-primary add-component" type="button">\n' +
            '<i class="fa fa-plus"></i>\n' +
            '</button>\n' +
            '</div>\n' +
            '</div>\n' +
            '</div>\n' +
            '</div>'
        )

        $('.components').on('click', '.remove-component', function () {
            $(this).closest('.form-row').remove()
        })

    })


    // Update dropdowns on load

    update_ingredient_dropdowns()
    update_unit_dropdowns()

})

