-- Fix published status for roadmap items
-- When a quarterly_roadmap is published, all its items should also be marked as published

-- Check current status
SELECT 'Current status of roadmap items:' as Info;
SELECT
    ri.id,
    ri.epic_id,
    ri.epic_name,
    ri.start_date,
    ri.end_date,
    ri.published as item_published,
    qr.published as roadmap_published
FROM roadmap_items ri
JOIN quarterly_roadmap qr ON ri.roadmap_id = qr.id
WHERE ri.roadmap_id = 1;

-- Update all items to match the published status of their roadmap
UPDATE roadmap_items ri
JOIN quarterly_roadmap qr ON ri.roadmap_id = qr.id
SET
    ri.published = qr.published,
    ri.published_date = qr.published_date
WHERE ri.roadmap_id = 1
  AND qr.published = 1;

SELECT ROW_COUNT() as 'Number of items marked as published';

-- Verify the update
SELECT 'After update:' as Info;
SELECT
    ri.id,
    ri.epic_id,
    ri.epic_name,
    ri.start_date,
    ri.end_date,
    ri.published as item_published,
    ri.published_date
FROM roadmap_items ri
WHERE ri.roadmap_id = 1;