ALTER TABLE event
    ADD COLUMN bundle_id UUID,
    ADD COLUMN bundle_display_name VARCHAR,
    ADD COLUMN application_id UUID,
    ADD COLUMN application_display_name VARCHAR,
    ADD COLUMN event_type_display_name VARCHAR,
    ADD CONSTRAINT fk_event_bundle_id FOREIGN KEY (bundle_id) REFERENCES bundles (id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_event_application_id FOREIGN KEY (application_id) REFERENCES applications (id) ON DELETE CASCADE;

CREATE INDEX ix_event_index_only_scan ON event (account_id, bundle_id, application_id, event_type_display_name, created DESC, id);

DROP PROCEDURE IF EXISTS denormalize();
CREATE PROCEDURE denormalize() LANGUAGE plpgsql AS $$
BEGIN
UPDATE event e
SET bundle_id = b.id, bundle_display_name = b.display_name, application_id = a.id, application_display_name = a.display_name, event_type_display_name = et.display_name
FROM event_type et, applications a, bundles b
WHERE e.event_type_id = et.id AND et.application_id = a.id AND a.bundle_id = b.id;
END;
$$;
