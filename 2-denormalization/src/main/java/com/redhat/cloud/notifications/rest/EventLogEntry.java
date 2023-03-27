package com.redhat.cloud.notifications.rest;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import static com.fasterxml.jackson.annotation.JsonFormat.Shape.STRING;
import static com.fasterxml.jackson.databind.PropertyNamingStrategies.SnakeCaseStrategy;

@JsonNaming(SnakeCaseStrategy.class)
public class EventLogEntry {

    public UUID id;

    @JsonFormat(shape = STRING)
    public LocalDateTime created;

    public String bundle;

    public String application;

    public String eventType;

    public String payload;

    public List<EventLogEntryAction> actions;
}
