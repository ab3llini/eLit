// ------------------------------------------- CONFIG -------------------------------------------

let server = '68.183.64.146'
let port = '9999'
let basepath = 'http://' + server + '/'

// ------------------------------------------- GLOBALS -------------------------------------------

let ingredient_names = []
let categories = []
let units = [
    'part',
    'jigger',
    'sprig',
    'twist',
    'slice',
    'cl'
]


// ------------------------------------------- CLASSES -------------------------------------------

let ui_log = null


class Connection {

    constructor(server, port) {


        this.ws = new WebSocket('ws://' + server + ':' + port + '/')

        this.handlers = {}

        let _self = this

        this.ws.onopen = function () {
            ui_log("Socket opened")
        }

        this.ws.onerror = function () {
            ui_log("Socket error")
        }
        this.ws.onmessage = function (event) {
            console.log("Received: " + event.data)

            _self.handle(JSON.parse(event.data))
        }

    }

    bind(request, handler) {

        this.handlers[request] = handler

    }

    handle(payload) {

        let handler = this.handlers[payload.request]


        if (handler === undefined) {

            ui_log('No handler for request: ' + payload.request)

        } else {

            handler(payload.data)

        }

    }

}

// -- UTIL

let get_img_obj = (url) => {

    return '<img src="'+basepath + url+'" class="rounded mr-3" style="height: 40px; width: 40px">'

}

let get_a_obj = (url) => {

    return '<a href="' + basepath + url + '"> Open </a>'

}

// ------------------------------------------- HANDLERS -------------------------------------------

let ws_ingredient_handler = (ingredients) => {

    ingredients.reverse().forEach(function (ingredient) {

        // Add ingredient name to global var
        ingredient_names.push(ingredient.name)

        $(".ingredient").DataTable().row.add([
            ingredient.name,
            ingredient.grade,
            get_img_obj(ingredient.image) + get_a_obj(ingredient.image),
            ingredient.ingredient_description
        ]).draw(false);

    })

    update_ingredient_dropdowns()


}

let ws_category_handler = (cat) => {

    cat.reverse().forEach(function (category) {

        // Add ingredient name to global var
        categories.push(category.name)

        $(".category").DataTable().row.add([
            category.name,
            get_img_obj(category.image) + get_a_obj(category.image)
        ]).draw(false);

    })

    update_category_dropdowns()


}

let ws_drink_handler = (drinks) => {

    ui_log(drinks)

    drinks.reverse().forEach(function (drink) {

        $(".drink").DataTable().row.add([
            drink.name,
            drink.degree,
            get_img_obj(drink.image) + get_a_obj(drink.image),
            drink.drink_description,
            drink.steps
        ]).draw(false);

    })

}


// ------------------------------------------- UTILS ----------------------------------------------


let on_add_table = (_class, _conn) => {

    let table = $(".new-" + _class).last()

    let request = {request: 'insert_' + _class, data: {}}


    table.find('input').each(function () {

        if ($(this).attr('type') != 'button') {

            var key = $(this).attr('name')
            var val = $(this).val()

            if (key == 'image') {

                val = _class + '/' + val

            }

            request.data[key] = val

        }
    })

    ui_log(request)

    _conn.ws.send(JSON.stringify(request))

    return request.data

}

let on_add_drink = (_conn) => {

    let form = $('.new-drink-form')

    let request = {request: 'insert_drink', data: {}}

    request.data.name = form.find('input[name="name"]').val()
    request.data.category = form.find('select[name="category"]').val()
    request.data.grade = form.find('input[name="grade"]').val()
    request.data.image = 'drink/' + form.find('input[name="image"]').val()
    request.data.description = form.find('input[name="description"]').val()

    let recipe = form.find('.recipe')

    let steps = recipe.find('.recipe-step')

    request.data.recipe = []

    steps.each(function () {

        let step = {components : []}

        step.description = $(this).find('input[name="description"]').val()

        let components = $(this).find('.components').find('.form-row')


        components.each(function () {

            let component = {

                quantity : $(this).find('input[name="quantity"]').val(),
                unit : $(this).find('select[name="unit"]').val(),
                ingredient : $(this).find('select[name="ingredient"]').val()

            }

            step.components.push(component)

        })

        request.data.recipe.push(step)

    })


    ui_log(JSON.stringify(request))

    _conn.ws.send(JSON.stringify(request))


}

let create_options_for = (list) => {

    let options = '<option>Choose..</option>'

    list.forEach(function (o) {

        options += '<option>' + o + '</option>'

    })

    return options

}

let update_ingredient_dropdowns = () => {

    $('.components').find('.ingredient-select').html(create_options_for(ingredient_names))

}

let update_category_dropdowns = () => {

    $('.new-drink-form').find('.category-select').html(create_options_for(categories))

}

let update_unit_dropdowns = () => {

    $('.components').find('.unit-select').html(create_options_for(units))

}


let bind_add_component = (ctx) => {

    if (ctx == null) {
        ctx = $('.components')
    }

    // Handle new recipe step add
    ctx.on('click', '.add-component', function () {

        let _new = $(
            '<div class="form-row">\n' +
            '<div class="form-group col-md-12">\n' +
            '<div class="input-group">\n' +
            '<input type="number" class="form-control" placeholder="Quantity" name="quantity">\n' +
            '<select class="custom-select unit-select" name="unit">\n' +
            create_options_for(units) +
            '</select>\n' +
            '<select class="custom-select ingredient-select" name="ingredient">\n' +
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

        $(this).parents('.components').append(_new)

        _new.on('click', '.remove-component', function () {
            $(this).parents('.form-row').remove()
        })

    })


}


let bind_add_recipe_step = () => {

    $('.recipe').on('click', '.add-recipe-step', function () {

        let _recipe_step = $(
            '<div class="recipe-step"></div>'
        )

        let _header = $(
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
            '</div>\n'
        )

        let _components = $(

            '<div class="components">\n' +
            '<div class="form-row aa">\n' +
            '<div class="form-group col-md-12">\n' +
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
            '<button class="btn btn-outline-primary add-component" type="button">\n' +
            '<i class="fa fa-plus"></i>\n' +
            '</button>\n' +
            '</div>\n' +
            '</div>\n' +
            '</div>\n' +
            '</div>\n' +
            '</div>'

        )

        _recipe_step.append(_header)
        _recipe_step.append(_components)


        $(this).parents('.recipe').append(_recipe_step)

        _header.on('click', '.remove-recipe-step', function () {

            $(this).parents('.recipe-step').remove()


        })

        bind_add_component(_components)

    })

}


// ------------------------------------------- OBSERVERS -------------------------------------------


$(document).ready(function () {

    ui_log = (o) => {

        console.log(o)

        $('.server-log').append(o.toString() + '<br>')

    }

    let connection = new Connection(server, port)

    // ------------------------------------------- BINDING ---------------------------------------------

    connection.bind('fetch_ingredients', ws_ingredient_handler)
    connection.bind('fetch_categories', ws_category_handler)
    connection.bind('fetch_drinks', ws_drink_handler)


    $('.new-ingredient').on("click", ".add-ingredient", function () {

        let added = on_add_table('ingredient', connection)
        ws_ingredient_handler([added])
        update_ingredient_dropdowns()


    })

    $('.new-category').on("click", ".add-category", function () {

        let added = on_add_table('category', connection)
        ws_category_handler([added])
        update_category_dropdowns()


    })

    $('.new-drink-form').on("click", ".add-drink", function () {

        on_add_drink( connection)

    })

    // Handle new recipe step add

    bind_add_recipe_step()
    bind_add_component()

    // Update dropdowns on load
    update_unit_dropdowns()

})

