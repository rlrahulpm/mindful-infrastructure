-- Populate roadmap_items from backlog_epics and epic_efforts for published roadmap
-- This fixes the issue where roadmap publishing didn't properly create roadmap items

-- First, clear existing roadmap items for this roadmap
DELETE FROM roadmap_items WHERE roadmap_id = 1;

-- Insert roadmap items from backlog epics and capacity planning data
INSERT INTO roadmap_items (
    roadmap_id, 
    epic_id, 
    epic_name, 
    epic_description, 
    priority, 
    status, 
    estimated_effort, 
    assigned_team,
    initiative_name,
    theme_name,
    theme_color,
    published,
    published_date,
    created_at,
    updated_at
)
SELECT DISTINCT
    1 as roadmap_id,
    be.epic_id,
    be.epic_name,
    COALESCE(be.epic_description, '') as epic_description,
    'Medium' as priority,
    'Committed' as status,
    CONCAT(COALESCE(SUM(ee.effort_days), 0), ' days') as estimated_effort,
    GROUP_CONCAT(t.name SEPARATOR ', ') as assigned_team,
    be.initiative_name,
    be.theme_name,
    be.theme_color,
    1 as published,
    '2025-09-12' as published_date,
    NOW() as created_at,
    NOW() as updated_at
FROM backlog_epics be
LEFT JOIN epic_efforts ee ON be.epic_id = ee.epic_id
LEFT JOIN teams t ON ee.team_id = t.id
WHERE be.product_id = 1
GROUP BY be.id, be.epic_id, be.epic_name, be.epic_description, be.initiative_name, be.theme_name, be.theme_color;

-- Verify the data was inserted
SELECT 'Roadmap items created:' as Info;
SELECT COUNT(*) as count FROM roadmap_items WHERE roadmap_id = 1;

SELECT 'Sample roadmap items:' as Info;
SELECT epic_id, epic_name, theme_name, theme_color, estimated_effort, assigned_team 
FROM roadmap_items WHERE roadmap_id = 1 LIMIT 5;