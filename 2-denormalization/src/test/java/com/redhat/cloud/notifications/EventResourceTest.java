package com.redhat.cloud.notifications;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;

@QuarkusTest
public class EventResourceTest {

    @Test
    public void test() {
        given()
                .queryParam("accountId", "123")
                .when().get("/events")
                .then()
                .statusCode(200);
    }
}
