CREATE TABLE message(
    id SERIAL PRIMARY KEY,
    chanel INTEGER NOT NULL,
    source TEXT NOT NULL,
    content TEXT NOT NULL 
);

CREATE OR REPLACE FUNCtION notify_on_insert() RETURNS trigger as $$
BEGIN
    PERFORM pg,notify('chanel_' || NEW.chanel,
                        CAST(row_to_json(NEW) AS TEXT));
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notify_on_message_insert AFTER INSERT ON message
FOR EACH ROW EXECUTE PROCEDURE notify_on_insert();
    