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

import static javax.persistence.FetchType.LAZY;

@Entity
@Table(name = "applications")
public class Application {

    @Id
    @GeneratedValue
    public UUID id;

    public LocalDateTime created;

    public String name;

    @Column(name = "display_name")
    public String displayName;

    @ManyToOne(fetch = LAZY, optional = false)
    @JoinColumn(name = "bundle_id")
    public Bundle bundle;

    @OneToMany(mappedBy = "application")
    public Set<EventType> eventTypes;
}
