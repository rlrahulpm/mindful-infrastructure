-- Fix NULL dates in roadmap_items table by setting them to quarter start/end dates
-- This script updates all roadmap items that have NULL start_date or end_date

-- First, let's see the current state of roadmap items with NULL dates
SELECT 'Current roadmap items with NULL dates:' as Info;
SELECT
    ri.id,
    ri.roadmap_id,
    ri.epic_id,
    ri.epic_name,
    qr.year,
    qr.quarter,
    ri.start_date,
    ri.end_date
FROM roadmap_items ri
JOIN quarterly_roadmap qr ON ri.roadmap_id = qr.id
WHERE ri.start_date IS NULL OR ri.end_date IS NULL;

-- Update roadmap_items with NULL dates based on their roadmap's quarter
UPDATE roadmap_items ri
JOIN quarterly_roadmap qr ON ri.roadmap_id = qr.id
SET
    ri.start_date = CASE
        WHEN qr.quarter = 1 THEN CONCAT(qr.year, '-01-01')
        WHEN qr.quarter = 2 THEN CONCAT(qr.year, '-04-01')
        WHEN qr.quarter = 3 THEN CONCAT(qr.year, '-07-01')
        WHEN qr.quarter = 4 THEN CONCAT(qr.year, '-10-01')
    END,
    ri.end_date = CASE
        WHEN qr.quarter = 1 THEN CONCAT(qr.year, '-03-31')
        WHEN qr.quarter = 2 THEN CONCAT(qr.year, '-06-30')
        WHEN qr.quarter = 3 THEN CONCAT(qr.year, '-09-30')
        WHEN qr.quarter = 4 THEN CONCAT(qr.year, '-12-31')
    END,
    ri.updated_at = NOW()
WHERE ri.start_date IS NULL OR ri.end_date IS NULL;

-- Show the number of records updated
SELECT ROW_COUNT() as 'Number of records updated';

-- Verify the update - show all roadmap items with their dates
SELECT 'Updated roadmap items:' as Info;
SELECT
    ri.id,
    ri.roadmap_id,
    ri.epic_id,
    ri.epic_name,
    qr.year,
    qr.quarter,
    ri.start_date,
    ri.end_date,
    ri.status,
    ri.priority
FROM roadmap_items ri
JOIN quarterly_roadmap qr ON ri.roadmap_id = qr.id
ORDER BY qr.year, qr.quarter, ri.epic_name;

-- Additional check: Ensure no NULL dates remain
SELECT 'Checking for any remaining NULL dates:' as Info;
SELECT COUNT(*) as null_date_count
FROM roadmap_items
WHERE start_date IS NULL OR end_date IS NULL;

-- For future: Consider adding NOT NULL constraints to prevent this issue
-- ALTER TABLE roadmap_items MODIFY COLUMN start_date DATE NOT NULL;
-- ALTER TABLE roadmap_items MODIFY COLUMN end_date DATE NOT NULL;