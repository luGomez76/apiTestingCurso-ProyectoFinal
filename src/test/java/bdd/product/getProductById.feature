@automation-api

Feature: Obtener producto por ID

  Background:
    * def responseLogin = call read('classpath:bdd/auth/loginAuth.feature@login-exitoso')
    * def authToken = responseLogin.authToken
    * def responseAddProduct = call read('classpath:bdd/product/addProduct.feature@productoAgregado')
    * def idProduct = responseAddProduct.idProduct

  Scenario: Obtener producto existente - Status 200
    * def validateScheme = read('classpath:resources/schema/schemes.json')

    Given url urlQaTeam
    And path "/api/v1/producto/", idProduct
    And header Accept = "application/json"
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
    And match response == validateScheme.getProductId

  Scenario: Obtener producto que no existe - Status 404
    * def validateScheme = read('classpath:resources/schema/schemes.json')
    * def idNotFound = read('classpath:resources/json/idProductNotFound.json')

    Given url urlQaTeam
    And path "/api/v1/producto/", idNotFound
    And header Accept = "application/json"
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 404
    And match response contains { error: '#string' }
    And match response.error == "Producto no encontrado"
