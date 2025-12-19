@automation-api
Feature: Logueo de un usuario

  Background:
    * def data = karate.read('classpath:resources/csv/loginAuth.csv')
    * def validateScheme = read('classpath:resources/schema/schemes.json')
    * def getRequest = (row) => ({ email: row.email,  password: row.password})

  @login-exitoso
  Scenario: Log correcto - Status 200
    * def row = data[0]
    * def body = getRequest(row)

    Given url urlQaTeam
    And path "/api/login"
    And request body
    When method post
    Then status 200
    And match response.user == validateScheme.logResponseAuth
    * def authToken = response.access_token
    * print "Mi token es:"+ authToken


  Scenario: Log incorrecto - Status 401
    * def row = data[1]
    * def body = getRequest(row)

    Given url urlQaTeam
    And path "/api/login"
    And request body
    When method post
    Then status 401
    And match response.message == "Datos incorrectos"

