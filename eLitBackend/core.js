var newIngredients = 0;
var oldIngredients = 0

var server = "http://localhost"



// Dinamically adds ingredients
$(document).ready(function () {

    loadIngredients()

    $("#ingredients").on("click", ".addIngredient", function () {

        var newRow = $("<tr>");
        var cols = "";

        cols += '<td><input type="text" class="form-control" name="name"/></td>';
        cols += '<td><input type="text" class="form-control" name="grade"/></td>';
        cols += '<td><input type="text" class="form-control" name="image"/></td>';
        cols += '<td><input type="text" class="form-control" name="description"/></td>';

        cols += '<td><input type="button" class="deleteIngredient btn btn-md btn-danger "  value="Delete"></td>';
        newRow.append(cols);

        $("#ingredients").append(newRow);
        newIngredients++;
    });


    $("#ingredients").on("click", ".saveIngredients", function (event) {
        saveIngredientsToDB()
    })


    $("#ingredients").on("click", ".deleteIngredient", function (event) {
        $(this).closest("tr").remove();
        newIngredients -= 1
    });


});


function loadIngredients() {

    var json = ''

    $.ajax({
        url: server,
        type: 'post',
        data: {request : 'fetch_ingredients'},
        xhrFields: {
            withCredentials: true
        },
        dataType: 'json',

        success: function (data) {
            console.info(data);
        }
    });

    console.log(json)

    /*
    var ingredients = JSON.parse(json)
    
    ingredients.forEach(function (ingredient) {

        var newRow = $("<tr>");
        var cols = "";

        cols += '<td><input type="text" class="form-control" name="name"/></td>';
        cols += '<td><input type="text" class="form-control" name="grade"/></td>';
        cols += '<td><input type="text" class="form-control" name="image"/></td>';
        cols += '<td><input type="text" class="form-control" name="description"/></td>';
        newRow.append(cols);

        $("#ingredients").append(newRow);

        oldIngredients++


    })*/



}

function saveIngredientsToDB() {

    var rows = $("#ingredients > tbody > tr")


    rows.each(function(index) {

        if ((index + 1) <= oldIngredients) { return } // Skip old ingredients

        let request = {request: 'insert_ingredient', data : {}}

        $(this).find('input').each(function () {

            if ($(this).attr('type') != 'button') {

                var key = $(this).attr('name')
                var val = $(this).val()

                request.data[key] = val


            }
        })

        console.log(request)

        $.post( server, request)
            .done(function( data ) {
                alert( "Data saved to db: ");
            });
    });


}