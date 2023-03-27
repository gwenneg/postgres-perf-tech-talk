CREATE INDEX ix_event_account_id_created_event_type_id_id_asc ON event (account_id, created, event_type_id, id);
CREATE INDEX ix_event_account_id_created_event_type_id_id_desc ON event (account_id, created DESC, event_type_id, id);
