-- Create a trigger that automatically publishes ALL items when a roadmap is published
-- This fixes the backend bug where modified items don't get published

DELIMITER $$

DROP TRIGGER IF EXISTS publish_all_roadmap_items$$

CREATE TRIGGER publish_all_roadmap_items
AFTER UPDATE ON quarterly_roadmap
FOR EACH ROW
BEGIN
    -- When a quarterly_roadmap is marked as published, publish ALL its items
    IF NEW.published = 1 AND OLD.published != NEW.published THEN
        UPDATE roadmap_items
        SET published = 1,
            published_date = NEW.published_date,
            updated_at = NOW()
        WHERE roadmap_id = NEW.id;
    END IF;
END$$

DELIMITER ;

-- Test: Update all items for published roadmaps right now
UPDATE roadmap_items ri
JOIN quarterly_roadmap qr ON ri.roadmap_id = qr.id
SET ri.published = 1, ri.published_date = qr.published_date
WHERE qr.published = 1;

SELECT 'Trigger created and existing items fixed' as Status;
SELECT epic_id, epic_name, published FROM roadmap_items WHERE roadmap_id = 1;