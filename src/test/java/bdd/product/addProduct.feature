@automation-api

Feature: Agregar un producto

    Background:
        * def data = read('classpath:resources/csv/newProduct.csv')
        * def randomCode = (function() {var uuid = java.util.UUID.randomUUID().toString(); return 'CP' + uuid.substring(0, 4);})()
        * def getRequest = (row, codigo) => ({ codigo: codigo, nombre: row.nombre, medida: row.medida, marca: row.marca, categoria: row.categoria, precio: row.precio, stock: row.stock, estado: row.estado, descripcion: row.descripcion })
        * def responseLogin = call read('classpath:bdd/auth/loginAuth.feature@login-exitoso')
        * def authToken = responseLogin.authToken

    @productoAgregado
    Scenario: Agregar producto nuevo - Status 200
        * def row = data[0]
        * def codigo = row.codigo == 'random' ? randomCode : row.codigo
        * def body = getRequest(row, codigo)
        * def validateScheme = read('classpath:resources/schema/schemes.json')

        Given url urlQaTeam
        And path "/api/v1/producto"
        And header Accept = "application/json"
        And header Authorization = 'Bearer ' + authToken
        And request body
        When method post
        Then status 200
        And match response == validateScheme.newProduct
        * def idProduct = response.id
        And print "El id es:" + idProduct

    Scenario: Agregar producto nuevo con campos incompletos - Status 500
        * def row = data[1]
        * def codigo = row.codigo == 'random' ? randomCode : row.codigo
        * def body = getRequest(row, codigo)

        Given url urlQaTeam
        And path "/api/v1/producto"
        And header Accept = "application/json"
        And header Authorization = 'Bearer ' + authToken
        And request body
        When method post
        Then status 500
        And assert JSON.stringify(response).includes("field is required.")

    Scenario: Agregar producto nuevo sin autenticarse - Status 401
        * def row = data[0]
        * def codigo = row.codigo == 'random' ? randomCode : row.codigo
        * def body = getRequest(row, codigo)

        Given url urlQaTeam
        And path "/api/v1/producto"
        And header Accept = "application/json"
        And request body
        When method post
        Then status 401
        And match response contains { message: '#string' }
        And match response.message == "Unauthenticated."

    Scenario: Agregar producto con codigo existente - Status 500
        * def body = read('classpath:resources/json/existingProduct.json')

        Given url urlQaTeam
        And path "/api/v1/producto"
        And header Accept = "application/json"
        And header Authorization = 'Bearer ' + authToken
        And request body
        When method post
        Then status 500
        And match response contains { error: '#string' }
        And match response.error contains "Duplicate entry"

