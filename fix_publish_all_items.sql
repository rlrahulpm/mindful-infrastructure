-- Fix publishing issue: When a quarterly_roadmap is published, ALL its items should be published
-- This script ensures all items in a published roadmap are marked as published

-- Check current state
SELECT 'Items in published roadmaps that are not published:' as Info;
SELECT
    ri.id,
    ri.epic_id,
    ri.epic_name,
    ri.start_date,
    ri.end_date,
    ri.published as item_published,
    ri.updated_at,
    qr.published as roadmap_published,
    qr.published_date
FROM roadmap_items ri
JOIN quarterly_roadmap qr ON ri.roadmap_id = qr.id
WHERE qr.published = 1
  AND ri.published = 0;

-- Fix: Update all items in published roadmaps to be published
UPDATE roadmap_items ri
JOIN quarterly_roadmap qr ON ri.roadmap_id = qr.id
SET
    ri.published = 1,
    ri.published_date = qr.published_date,
    ri.updated_at = NOW()
WHERE qr.published = 1
  AND ri.published = 0;

SELECT ROW_COUNT() as 'Number of items fixed';

-- Verify the fix
SELECT 'After fix - All items in roadmap 1:' as Info;
SELECT
    ri.id,
    ri.epic_id,
    ri.epic_name,
    ri.start_date,
    ri.end_date,
    ri.published,
    ri.published_date,
    ri.updated_at
FROM roadmap_items ri
WHERE ri.roadmap_id = 1
ORDER BY ri.epic_name;