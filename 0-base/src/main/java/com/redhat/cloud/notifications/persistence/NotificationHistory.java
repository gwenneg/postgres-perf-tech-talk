package com.redhat.cloud.notifications.persistence;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

import static javax.persistence.FetchType.LAZY;

@Entity
@Table(name = "notification_history")
public class NotificationHistory {

    @Id
    @GeneratedValue
    public UUID id;

    public LocalDateTime created;

    @Column(name = "invocation_time")
    public Long invocationTime;

    @Column(name = "invocation_result")
    public Boolean invocationResult;

    @ManyToOne(fetch = LAZY, optional = false)
    @JoinColumn(name = "event_id")
    public Event event;

    @Column(name = "endpoint_id")
    public UUID endpointId;

    @Column(name = "endpoint_type")
    public String endpointType;

    @Convert(converter = NotificationHistoryDetailsConverter.class)
    public Map<String, Object> details;
}
