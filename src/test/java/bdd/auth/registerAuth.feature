@automation-api

Feature: Registro de un usuario

  Background:
    * def data = karate.read('classpath:resources/csv/registerAuth.csv')
    * def randomEmail = (function() {var uuid = java.util.UUID.randomUUID().toString(); return 'email_' + uuid + '@gmail.com';})()
    * def getRequest = (row, email) => ({ email: email,  password: row.password,  nombre: row.nombre,  tipo_usuario_id: row.tipo_usuario_id,  estado: row.estado  })
    * def validateScheme = read('classpath:resources/schema/schemes.json')


  Scenario: Registro correcto - Status 200
    * def row = data[0]
    * def email = row.email == 'random' ? randomEmail : row.email
    * def body = getRequest(row, email)

    Given url urlQaTeam
    And path "/api/register"
    And request body
    When method post
    Then status 200
    And match response.data == validateScheme.registerAuth

  Scenario: Registro con correo ya existente - Status 500
    * def row = data[1]
    * def email = row.email == 'random' ? randomEmail : row.email
    * def body = getRequest(row, email)

    Given url urlQaTeam
    And path "/api/register"
    And request body
    When method post
    Then status 500
    And match response.email == ["The email has already been taken."]

  Scenario: Registro con correo inválido - Status 500
    * def row = data[2]
    * def email = row.email == 'random' ? randomEmail : row.email
    * def body = getRequest(row, email)

    Given url urlQaTeam
    And path "/api/register"
    And request body
    When method post
    Then status 500
    And match response.email == ["The email must be a valid email address."]