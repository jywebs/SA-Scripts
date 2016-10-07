--JIRA User Account RTP
USE jira_scalearc;
SELECT d.directory_name AS "Directory",
    u.user_name AS "Username",
    from_unixtime((cast(attribute_value AS UNSIGNED)/1000)) AS "Last Login"
FROM cwd_user u
JOIN (
    SELECT DISTINCT child_name
    FROM cwd_membership m
    JOIN globalpermissionentry gp ON m.parent_name = gp.group_id
    WHERE gp.permission IN ('ADMINISTER', 'USE', 'SYSTEM_ADMIN')
    ) AS m ON m.child_name = u.user_name
LEFT JOIN (
    SELECT *
    FROM cwd_user_attributes
    WHERE attribute_name = 'login.lastLoginMillis'
    ) AS a ON a.user_id = u.id
JOIN cwd_directory d ON u.directory_id = d.id
WHERE u.user_name in (
	SELECT user_name
	FROM cwd_user
	WHERE active = 1)
ORDER BY "Last Login" DESC;

-- Confluence USER Account RPT
USE confluence_scalearc;
SELECT u.user_name, d.directory_name, l.successdate
FROM logininfo l
JOIN user_mapping m ON m.user_key = l.username
JOIN cwd_user u ON m.username = u.user_name
JOIN cwd_directory d ON u.directory_id = d.id
WHERE u.user_name not in (
	SELECT user_name
	from cwd_user
	where active = 'F')
ORDER BY successdate;