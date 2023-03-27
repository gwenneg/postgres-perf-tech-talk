package com.redhat.cloud.notifications.persistence;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "event")
public class Event {

    @Id
    @GeneratedValue
    public UUID id;

    public LocalDateTime created;

    @Column(name = "account_id")
    public String accountId;

    @ManyToOne(optional = false)
    @JoinColumn(name = "event_type_id")
    public EventType eventType;

    @OneToMany(mappedBy = "event")
    public Set<NotificationHistory> historyEntries;

    public String payload;
}
