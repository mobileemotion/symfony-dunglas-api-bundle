@dateFilter
Feature: Order filter on collections
  In order to retrieve ordered large collections of resources
  As a client software developer
  I need to retrieve collections ordered properties

  @createSchema
  Scenario: Get collection filtered by date
    Given there is "30" dummy objects with dummyDate
    When I send a "GET" request to "/dummies?dummyDate[after]=2015-04-28"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?dummyDate\\[after\\]=2015-04-28$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number", "maximum": 2},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/28$"},
                  {"pattern": "^/dummies/29$"}
                ]
              }
            }
          },
          "maxItems": 2
        }
      }
    }
    """

    When I send a "GET" request to "/dummies?dummyDate[before]=2015-04-05"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?dummyDate\\[before\\]=2015-04-05$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number", "maximum": 5},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/1$"},
                  {"pattern": "^/dummies/2$"},
                  {"pattern": "^/dummies/3$"}
                ]
              }
            }
          },
          "maxItems": 3
        }
      }
    }
    """

  Scenario: Search for entities within a range
    # The order should not influence the search
    When I send a "GET" request to "/dummies?dummyDate[before]=2015-04-05&dummyDate[after]=2015-04-05"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?dummyDate\\[before\\]=2015-04-05\\&dummyDate\\[after\\]=2015-04-05$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number", "maximum": 1},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/5$"}
                ]
              }
            }
          },
          "maxItems": 1
        }
      }
    }
    """

    When I send a "GET" request to "/dummies?dummyDate[after]=2015-04-05&dummyDate[before]=2015-04-05"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?dummyDate\\[after\\]=2015-04-05\\&dummyDate\\[before\\]=2015-04-05$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number", "maximum": 1},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/5$"}
                ]
              }
            }
          },
          "maxItems": 1
        }
      }
    }
    """

  Scenario: Search for entities within an impossible range
    When I send a "GET" request to "/dummies?dummyDate[after]=2015-04-06&dummyDate[before]=2015-04-04"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?dummyDate\\[after\\]=2015-04-06\\&dummyDate\\[before\\]=2015-04-04$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number", "maximum": 0},
        "hydra:member": {
          "type": "array",
          "maxItems": 0
        }
      }
    }
    """

  @dropSchema
  Scenario: Get collection filtered by association date
    Given there is "30" dummy objects with dummyDate and relatedDummy
    When I send a "GET" request to "/dummies?relatedDummy.dummyDate[after]=2015-04-28"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?relatedDummy\\.dummyDate\\[after\\]=2015-04-28$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number", "maximum": 3},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/58$"},
                  {"pattern": "^/dummies/59$"},
                  {"pattern": "^/dummies/60$"}
                ]
              }
            }
          },
          "maxItems": 3
        }
      }
    }
    """

    When I send a "GET" request to "/dummies?relatedDummy.dummyDate[after]=2015-04-28&relatedDummy_dummyDate[after]=2015-04-28"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?relatedDummy\\.dummyDate\\[after\\]=2015-04-28\\&relatedDummy_dummyDate\\[after\\]=2015-04-28$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number", "maximum": 3},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/58$"},
                  {"pattern": "^/dummies/59$"},
                  {"pattern": "^/dummies/60$"}
                ]
              }
            }
          },
          "maxItems": 3
        }
      }
    }
    """

  @createSchema
  @dropSchema
  Scenario: Search for entities within a range
    Given there is "2" dummy objects with dummyDate
    When I send a "GET" request to "/dummies?dummyDate[after]="
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON node "hydra:totalItems" should be equal to "2"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?dummyDate\\[after\\]=$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number"},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/1$"},
                  {"pattern": "^/dummies/2$"}
                ]
              }
            }
          }
        }
      }
    }
    """

    When I send a "GET" request to "/dummies?dummyDate[before]="
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON node "hydra:totalItems" should be equal to "2"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies\\?dummyDate\\[before\\]=$"},
        "@type": {"pattern": "^hydra:PagedCollection$"},
        "hydra:totalItems": {"type":"number"},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/1$"},
                  {"pattern": "^/dummies/2$"}
                ]
              }
            }
          }
        }
      }
    }
    """
