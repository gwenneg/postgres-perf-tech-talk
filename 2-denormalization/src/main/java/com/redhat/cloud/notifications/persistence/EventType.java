package com.redhat.cloud.notifications.persistence;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import java.util.UUID;

import static javax.persistence.FetchType.LAZY;

@Entity
@Table(name = "event_type")
public class EventType {

    @Id
    @GeneratedValue
    public UUID id;

    public String name;

    @Column(name = "display_name")
    public String displayName;

    public String description;

    @ManyToOne(fetch = LAZY, optional = false)
    @JoinColumn(name = "application_id")
    public Application application;
}
