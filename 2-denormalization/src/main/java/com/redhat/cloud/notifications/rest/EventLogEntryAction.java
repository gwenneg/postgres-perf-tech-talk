package com.redhat.cloud.notifications.rest;

import com.fasterxml.jackson.databind.annotation.JsonNaming;

import java.util.Map;
import java.util.UUID;

import static com.fasterxml.jackson.databind.PropertyNamingStrategies.SnakeCaseStrategy;

@JsonNaming(SnakeCaseStrategy.class)
public class EventLogEntryAction {

    public UUID id;

    public String endpointType;

    public Boolean invocationResult;

    public UUID endpointId;

    public Map<String, Object> details;
}
