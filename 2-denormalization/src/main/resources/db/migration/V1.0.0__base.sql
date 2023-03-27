CREATE TABLE bundles (
    id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    display_name VARCHAR NOT NULL,
    created TIMESTAMP NOT NULL,
    updated TIMESTAMP,
    CONSTRAINT pk_bundles PRIMARY KEY (id),
    CONSTRAINT uq_bundles_name UNIQUE (name)
);

CREATE TABLE applications (
    id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    display_name VARCHAR NOT NULL,
    created TIMESTAMP NOT NULL,
    updated TIMESTAMP,
    bundle_id UUID,
    CONSTRAINT pk_applications PRIMARY KEY (id),
    CONSTRAINT uq_applications_bundle_id_name UNIQUE (bundle_id, name),
    CONSTRAINT fk_applications_bundle_id FOREIGN KEY (bundle_id) REFERENCES bundles(id) ON DELETE CASCADE
);

CREATE TABLE event_type (
    name VARCHAR(255) NOT NULL,
    display_name VARCHAR NOT NULL,
    application_id UUID,
    description VARCHAR,
    id UUID NOT NULL,
    CONSTRAINT pk_event_type PRIMARY KEY (id),
    CONSTRAINT uq_event_type_application_id_name UNIQUE (application_id, name),
    CONSTRAINT fk_event_type_application_id FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE
);
CREATE INDEX ix_event_type_name ON event_type (name);

CREATE TABLE event (
    id UUID NOT NULL,
    account_id VARCHAR(50) NOT NULL,
    event_type_id UUID NOT NULL,
    payload TEXT,
    created TIMESTAMP NOT NULL,
    CONSTRAINT pk_event PRIMARY KEY (id),
    CONSTRAINT fk_event_event_type_id FOREIGN KEY (event_type_id) REFERENCES event_type(id) ON DELETE CASCADE
);
CREATE INDEX ix_event_account_id ON event (account_id);
-- For demo purposes, not in production initially:
ALTER TABLE event SET (autovacuum_enabled = false);

CREATE TABLE notification_history (
    endpoint_id UUID,
    created TIMESTAMP NOT NULL,
    invocation_time INTEGER NOT NULL,
    invocation_result BOOLEAN NOT NULL,
    details TEXT,
    id UUID NOT NULL,
    event_id UUID NOT NULL,
    endpoint_type INTEGER NOT NULL,
    CONSTRAINT pk_notification_history PRIMARY KEY (id),
    CONSTRAINT fk_notification_history_event_id FOREIGN KEY (event_id) REFERENCES event(id) ON DELETE CASCADE
);
CREATE INDEX ix_notification_history_event_id ON notification_history (event_id);
CREATE INDEX ix_notification_history_endpoint_id_created ON notification_history (endpoint_id, created DESC);
-- For demo purposes, not in production initially:
ALTER TABLE notification_history SET (autovacuum_enabled = false);

INSERT INTO bundles (id, name, display_name, created)
VALUES ('acd2d648-26fe-407e-8bed-f93873cf2576', 'application-services', 'Application Services', NOW()),
       ('889366df-8be3-4099-830a-a39012263bde', 'ansible', 'Ansible', NOW()),
       ('35773a5d-cd19-42d9-b6eb-711c0f024056', 'console', 'Console', NOW()),
       ('26b68b28-58a9-4267-92cb-c3e2d3bf7b64', 'openshift', 'OpenShift', NOW()),
       ('552bb2b0-e300-446f-a0ca-f3eb6f64068a', 'rhel', 'Red Hat Enterprise Linux', NOW());

INSERT INTO applications (id, name, display_name, bundle_id, created)
VALUES ('04572b2e-99f6-48d2-a955-389ecd6000e2', 'advisor', 'Advisor', '26b68b28-58a9-4267-92cb-c3e2d3bf7b64', NOW()),
       ('851d3f5a-6204-47cc-a161-c4d5af56cd8b', 'cost-management', 'Cost Management', '26b68b28-58a9-4267-92cb-c3e2d3bf7b64', NOW()),
       ('a8e7a3e9-c2d1-4a45-a8f4-40494ac048d8', 'advisor', 'Advisor', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('c27a9b87-d6f6-4eeb-974f-bc3a5f78e7fa', 'compliance', 'Compliance', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('2d45905a-091d-4f98-abc4-09b770240cc0', 'drift', 'Drift', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('560fca17-5055-483b-8b6d-b6917ba61c24', 'inventory', 'Inventory', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('0acda52c-1616-4f98-80fc-1bd60661dd19', 'malware-detection', 'Malware Detection', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('a7ba556d-69dc-4ad0-9af1-7a81da8bbde9', 'patch', 'Patch', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('c5b3df32-b3d8-4287-a012-351673436f21', 'policies', 'Policies', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('b97a6819-b961-488d-b362-bab6dee7ddcf', 'resource-optimization', 'Resource Optimization', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('0fe08bac-1087-4916-bbd2-7937e6709094', 'vulnerability', 'Vulnerability', '552bb2b0-e300-446f-a0ca-f3eb6f64068a', NOW()),
       ('efdcbe9b-ee0b-462e-abad-f0a555b93f03', 'rhosak', 'RHOSAK', 'acd2d648-26fe-407e-8bed-f93873cf2576', NOW()),
       ('9a399b8d-34d4-4367-a9ef-fbf5f4420251', 'integrations', 'Integrations', '35773a5d-cd19-42d9-b6eb-711c0f024056', NOW()),
       ('39dba920-c427-4909-9925-90e00b3d0849', 'rbac', 'User Access', '35773a5d-cd19-42d9-b6eb-711c0f024056', NOW()),
       ('9887602e-004e-4224-be51-537c4b4c2c17', 'sources', 'Sources', '35773a5d-cd19-42d9-b6eb-711c0f024056', NOW());

INSERT INTO event_type (id, name, display_name, application_id)
VALUES ('58cfbee1-621a-4262-a38e-1ca2047d336e', 'new-advisory', 'New advisory', 'a7ba556d-69dc-4ad0-9af1-7a81da8bbde9'),
       ('578f10ef-9062-4251-87fd-a86e33cc6263', 'validation-error', 'Validation error', '560fca17-5055-483b-8b6d-b6917ba61c24'),
       ('42def7ca-828a-4489-8d7b-632d17cba793', 'drift-baseline-detected', 'Drift from baseline detected', '2d45905a-091d-4f98-abc4-09b770240cc0'),
       ('2ed6c661-28aa-49c0-83b5-f5b616fa94ea', 'availability-status', 'Availability Status', '9887602e-004e-4224-be51-537c4b4c2c17'),
       ('92ee4c4a-274c-40af-b40c-611b83dd776d', 'policy-triggered', 'Policy triggered', 'c5b3df32-b3d8-4287-a012-351673436f21'),
       ('d5031957-2dbf-40a7-b21b-b319d03cfb08', 'deactivated-recommendation', 'Deactivated recommendation', 'a8e7a3e9-c2d1-4a45-a8f4-40494ac048d8'),
       ('30e791ec-6abf-4487-8692-5ef8608f4268', 'new-recommendation', 'New recommendation', 'a8e7a3e9-c2d1-4a45-a8f4-40494ac048d8'),
       ('a8d1b9b6-bdf1-4d73-9f64-6663c74afba2', 'resolved-recommendation', 'Resolved recommendation', 'a8e7a3e9-c2d1-4a45-a8f4-40494ac048d8'),
       ('ec22d3f1-f2d5-43fd-a7a5-4694347fe07d', 'new-recommendation', 'New recommendation', '04572b2e-99f6-48d2-a955-389ecd6000e2'),
       ('7527a10c-4ca1-4d84-9e5e-f681301f539b', 'detected-malware', 'Detected Malware', '0acda52c-1616-4f98-80fc-1bd60661dd19'),
       ('d090ef45-2340-4359-9d56-b8513885f768', 'compliance-below-threshold', 'System is non compliant to SCAP policy', 'c27a9b87-d6f6-4eeb-974f-bc3a5f78e7fa'),
       ('b75f50b7-40b6-4606-9173-4c43ec0bcec5', 'report-upload-failed', 'Policy report failed to upload', 'c27a9b87-d6f6-4eeb-974f-bc3a5f78e7fa'),
       ('714c8994-1ee2-484c-8ce9-43dad23a7ed9', 'integration-disabled', 'Integration disabled', '9a399b8d-34d4-4367-a9ef-fbf5f4420251'),
       ('60f5b1d0-2479-4da8-b5a2-84eec194e4a3', 'integration-test', 'Integration Test', '9a399b8d-34d4-4367-a9ef-fbf5f4420251'),
       ('9fee9146-6895-4cce-9a7a-08f1ab449005', 'disruption', 'Service Disruption', 'efdcbe9b-ee0b-462e-abad-f0a555b93f03'),
       ('dfbc546c-c73d-4324-beff-39e2ba52da65', 'scheduled-upgrade', 'Scheduled Upgrade', 'efdcbe9b-ee0b-462e-abad-f0a555b93f03'),
       ('029aa80d-f8b6-4ba7-9761-a8a81af867d1', 'new-suggestion', 'New suggestion', 'b97a6819-b961-488d-b362-bab6dee7ddcf'),
       ('10f6232b-eeaf-4e15-9458-6ec067e4d881', 'custom-default-access-updated', 'Custom platform default access group updated', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('9b91d4f1-d41c-44c5-b1e0-3dcb155db41e', 'custom-role-created', 'Custom role created', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('134c51d6-5973-473b-b06f-84190c4e1510', 'custom-role-deleted', 'Custom role deleted', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('07fb5d83-0294-4608-9703-24908456f9e5', 'custom-role-updated', 'Custom role updated', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('0e1c484a-ae95-480e-8fa2-b2f825c3bef4', 'group-created', 'Group created', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('a3e2fc26-4ff0-48e5-baee-98b755f3b2e7', 'group-deleted', 'Group deleted', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('4921245a-a5ac-49bc-b778-12f2b55a6b7f', 'group-updated', 'Group updated', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('8d4994cd-13b8-454a-839d-c192899d0d56', 'platform-default-group-turned-into-custom', 'Platform default access group turned into custom', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('378b7bd9-8808-494d-84da-5c9d6f7955da', 'rh-new-role-added-to-default-access', 'New Red Hat role added to platform default access group', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('465cabfb-391e-43e7-a1e4-540aa85972cc', 'rh-new-role-available', 'New Red Hat role available', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('54cb22b7-e7c8-4c89-b071-650c562212d2', 'rh-non-platform-default-role-updated', 'Red Hat role not in platform default access group updated', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('57a6e44f-6d26-418c-bbcc-6ca1bafda5ff', 'rh-platform-default-role-updated', 'Red Hat role in platform default access group updated', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('813b0998-d8f3-44eb-a2b5-dafc42e3cdef', 'rh-role-removed-from-default-access', 'Red Hat role removed from platform default access group', '39dba920-c427-4909-9925-90e00b3d0849'),
       ('f2415283-f353-4e8d-af9a-4cca3e531bef', 'any-cve-known-exploit', 'Any vulnerability with known exploit', '0fe08bac-1087-4916-bbd2-7937e6709094'),
       ('58dceccb-c022-4c4d-b437-05d475a40518', 'new-cve-cvss', 'New vulnerability with CVSS >= 7.0', '0fe08bac-1087-4916-bbd2-7937e6709094'),
       ('cf927bee-ba35-45b6-8312-cb0f7422cf84', 'new-cve-security-rule', 'New vulnerability containing Security rule', '0fe08bac-1087-4916-bbd2-7937e6709094'),
       ('bf0e9b5c-8b21-4b58-b2a3-0de053a250a0', 'new-cve-severity', 'New vulnerability with Critical Severity', '0fe08bac-1087-4916-bbd2-7937e6709094'),
       ('f22a761c-e451-415b-b10c-8bf7a1a71a39', 'cm-operator-stale', 'CM Operator Stale Data', '851d3f5a-6204-47cc-a161-c4d5af56cd8b'),
       ('ca597c60-d226-4dbc-9e86-50cd4bd8fe9f', 'missing-cost-model', 'Missing Openshift Cost Model', '851d3f5a-6204-47cc-a161-c4d5af56cd8b');

DROP PROCEDURE IF EXISTS initData();
CREATE PROCEDURE initData() LANGUAGE plpgsql AS $$
DECLARE
event_type_count INTEGER;
BEGIN
SELECT INTO event_type_count COUNT(*) FROM event_type;
DELETE FROM event;
RAISE INFO '% event types found', event_type_count;
FOR i IN 1..33 LOOP
        RAISE INFO 'Simulating day %', i;
CALL insertEvents(event_type_count, 200000 + FLOOR(RANDOM() * 50000)::INT);
IF i > 30 THEN
            CALL deleteEvents(200000 + FLOOR(RANDOM() * 50000)::INT);
END IF;
END LOOP;
END;
$$;

DROP PROCEDURE IF EXISTS insertEvents(INTEGER, INTEGER);
CREATE PROCEDURE insertEvents(event_type_count INTEGER, events_number INTEGER) LANGUAGE plpgsql AS $$
DECLARE
inserted_or_deleted INTEGER;
BEGIN
WITH ranks AS (
    SELECT id, RANK() OVER (ORDER BY application_id, name) AS rank
    FROM event_type
)
INSERT INTO event (id, account_id, event_type_id, payload, created)
SELECT
    gen_random_uuid(),
    'account-' || (CASE WHEN MOD(i, 100) < 50 THEN MOD(i, 100) ELSE '50' END),
    (
        SELECT id FROM ranks WHERE rank = MOD(i, event_type_count) + 1
    ),
    MD5(RANDOM()::TEXT),
    NOW()
FROM GENERATE_SERIES(1, events_number) S(i);
GET DIAGNOSTICS inserted_or_deleted = ROW_COUNT;
RAISE INFO '% events inserted', inserted_or_deleted;
END;
$$;

DROP PROCEDURE IF EXISTS deleteEvents(INTEGER);
CREATE PROCEDURE deleteEvents(events_number INTEGER) LANGUAGE plpgsql AS $$
DECLARE
inserted_or_deleted INTEGER;
BEGIN
DELETE FROM event
WHERE ctid IN (
    SELECT ctid
    FROM event
    ORDER BY created
    LIMIT events_number
    );
GET DIAGNOSTICS inserted_or_deleted = ROW_COUNT;
RAISE INFO '% events deleted', inserted_or_deleted;
END;
$$;
