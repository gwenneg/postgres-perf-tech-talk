package com.redhat.cloud.notifications.rest;

import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
import org.jboss.resteasy.reactive.RestQuery;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import java.util.Set;

import static com.redhat.cloud.notifications.rest.EventResource.PATH;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;

@RegisterRestClient(configKey = "event-resource")
@Path(PATH)
public interface EventResourceClient {

    @GET
    @Produces(APPLICATION_JSON)
    Page<EventLogEntry> getEvents(@RestQuery String accountId, @RestQuery Set<String> bundleIds,
                                  @RestQuery String startDate, @RestQuery String endDate, @RestQuery String sortBy);
}
