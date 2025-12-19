@automation-api

Feature: Actualizar producto

  Background:
    * def data = read('classpath:resources/csv/newProduct.csv')
    * def getRequest = (row) => ({ codigo: row.codigo, nombre: row.nombre, medida: row.medida, marca: row.marca, categoria: row.categoria, precio: row.precio, stock: row.stock, estado: row.estado, descripcion: row.descripcion })
    * def responseLogin = call read('classpath:bdd/auth/loginAuth.feature@login-exitoso')
    * def authToken = responseLogin.authToken
    * def responseAddProduct = call read('classpath:bdd/product/addProduct.feature@productoAgregado')
    * def idProduct = responseAddProduct.idProduct

  Scenario: Actualizar producto existente - Status 200
    * def validateScheme = read('classpath:resources/schema/schemes.json')
    * def row = data[2]
    * def body = getRequest(row)

    Given url urlQaTeam
    And path "/api/v1/producto", idProduct
    And header Accept = "application/json"
    And header Authorization = 'Bearer ' + authToken
    And request body
    When method put
    Then status 200
    And match response == validateScheme.updateProduct

  Scenario: Actualizar producto existente con campos incompletos - Status 500
    * def row = data[1]
    * def body = getRequest(row)

    Given url urlQaTeam
    And path "/api/v1/producto/", idProduct
    And header Accept = "application/json"
    And header Authorization = 'Bearer ' + authToken
    And request body
    When method put
    Then status 500
    And assert JSON.stringify(response).includes("field is required.")

  Scenario: Actualizar producto que no existe- Status 500
    * def idNotFound = read('classpath:resources/json/idProductNotFound.json')
    * def row = data[2]
    * def body = getRequest(row)

    Given url urlQaTeam
    And path "/api/v1/producto/", idNotFound
    And header Accept = "application/json"
    And header Authorization = 'Bearer ' + authToken
    And request body
    When method put
    Then status 500
    And match response contains { error: '#string' }
    And match response.error == "Call to a member function update() on null"
