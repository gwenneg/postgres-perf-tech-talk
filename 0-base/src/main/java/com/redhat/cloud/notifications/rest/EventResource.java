package com.redhat.cloud.notifications.rest;

import com.redhat.cloud.notifications.persistence.Event;
import com.redhat.cloud.notifications.persistence.EventRepository;
import org.jboss.resteasy.reactive.RestQuery;

import javax.inject.Inject;
import javax.ws.rs.BadRequestException;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static com.redhat.cloud.notifications.rest.EventResource.PATH;
import static java.util.regex.Pattern.CASE_INSENSITIVE;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;

@Path(PATH)
public class EventResource {

    public static final String PATH = "/events";
    public static final Pattern SORT_BY_PATTERN = Pattern.compile("^([a-z0-9_-]+):(asc|desc)$", CASE_INSENSITIVE);

    @Inject
    EventRepository eventRepository;

    @GET
    @Produces(APPLICATION_JSON)
    public Page<EventLogEntry> getEvents(@RestQuery String accountId, @RestQuery Set<UUID> bundleIds, @RestQuery Set<UUID> appIds,
                                              @RestQuery String eventTypeDisplayName, @RestQuery LocalDate startDate, @RestQuery LocalDate endDate,
                                              @RestQuery Set<String> endpointTypes, @RestQuery Set<Boolean> invocationResults,
                                              @RestQuery @DefaultValue("10") int limit, @RestQuery @DefaultValue("0") int offset, @RestQuery String sortBy,
                                              @RestQuery boolean includeDetails, @RestQuery boolean includePayload) {
        if (limit < 1 || limit > 200) {
            throw new BadRequestException("Invalid 'limit' query parameter, its value must be between 1 and 200");
        }
        if (sortBy != null && !SORT_BY_PATTERN.matcher(sortBy).matches()) {
            throw new BadRequestException("Invalid 'sortBy' query parameter");
        }

        List<Event> events = eventRepository.getEvents(accountId, bundleIds, appIds, eventTypeDisplayName, startDate, endDate, endpointTypes, invocationResults, limit, offset, sortBy);
        List<EventLogEntry> eventLogEntries = events.stream().map(event -> {
            List<EventLogEntryAction> actions = event.historyEntries.stream().map(historyEntry -> {
                EventLogEntryAction action = new EventLogEntryAction();
                action.id = historyEntry.id;
                action.endpointId = historyEntry.endpointId;
                action.endpointType = historyEntry.endpointType;
                action.invocationResult = historyEntry.invocationResult;
                if (includeDetails) {
                    action.details = historyEntry.details;
                }
                return action;
            }).collect(Collectors.toList());

            EventLogEntry entry = new EventLogEntry();
            entry.id = event.id;
            entry.created = event.created;
            entry.bundle = event.eventType.application.bundle.displayName;
            entry.application = event.eventType.application.displayName;
            entry.eventType = event.eventType.displayName;
            entry.actions = actions;
            if (includePayload) {
                entry.payload = event.payload;
            }
            return entry;
        }).collect(Collectors.toList());

        Long count = eventRepository.count(accountId, bundleIds, appIds, eventTypeDisplayName, startDate, endDate, endpointTypes, invocationResults);
        Meta meta = new Meta();
        meta.count = count;

        Page<EventLogEntry> page = new Page<>();
        page.data = eventLogEntries;
        page.meta = meta;
        return page;
    }
}
