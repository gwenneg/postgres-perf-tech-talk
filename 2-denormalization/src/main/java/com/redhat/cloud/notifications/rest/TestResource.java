package com.redhat.cloud.notifications.rest;

import io.quarkus.logging.Log;
import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.jboss.resteasy.reactive.RestQuery;

import javax.inject.Inject;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import java.time.LocalDate;
import java.util.Set;

@Path("/test")
public class TestResource {

    @Inject
    @RestClient
    EventResourceClient eventResourceClient;

    @GET
    public String test(@RestQuery String accountId, @RestQuery @DefaultValue("10") int calls) {
        long start = System.currentTimeMillis();
        Page<EventLogEntry> events = null;
        for (int i = 0; i < calls; i++) {
            Log.infof("Call #%d", i);
            events = getEvents(accountId);
        }
        long average = (System.currentTimeMillis() - start) / calls;
        return "Account = " + accountId + ", events = " + events.meta.count + ", calls = " + calls + ", average response time = " + average + " ms";
    }

    private Page<EventLogEntry> getEvents(String accountId) {
        return eventResourceClient.getEvents(
                accountId,
                Set.of("552bb2b0-e300-446f-a0ca-f3eb6f64068a"),
                LocalDate.now().minusDays(14L).toString(),
                LocalDate.now().toString(),
                "created:DESC"
        );
    }
}
