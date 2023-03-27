package com.redhat.cloud.notifications.persistence;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "bundles")
public class Bundle {

    @Id
    @GeneratedValue
    public UUID id;

    public LocalDateTime created;

    public String name;

    @Column(name = "display_name")
    public String displayName;

    @OneToMany(mappedBy = "bundle")
    public Set<Application> applications;
}
