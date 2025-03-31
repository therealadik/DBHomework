WITH RECURSIVE
    subordinate_hierarchy AS (
        -- Базовый уровень: выбираем все прямые связи "менеджер – подчинённый"
        SELECT ManagerID, EmployeeID
        FROM Employees
        WHERE ManagerID IS NOT NULL
        UNION ALL
        -- Рекурсивно получаем подчинённых всех уровней
        SELECT sh.ManagerID, e.EmployeeID
        FROM subordinate_hierarchy sh
                 JOIN Employees e ON e.ManagerID = sh.EmployeeID),
    mgr_total AS (
        -- Для каждого менеджера подсчитываем общее количество подчинённых (на всех уровнях)
        SELECT ManagerID, COUNT(*) AS TotalSubordinates
        FROM subordinate_hierarchy
        GROUP BY ManagerID),
    tasks_agg AS (
        -- Агрегируем задачи для каждого сотрудника, назначенные ему (сортировка по TaskID DESC)
        SELECT AssignedTo, STRING_AGG(TaskName, ', ' ORDER BY TaskID DESC) AS TaskNames
        FROM Tasks
        GROUP BY AssignedTo),
    projects_agg AS (
        -- Агрегируем проекты по отделу: сотрудник относится к проекту своего отдела
        SELECT DepartmentID, STRING_AGG(ProjectName, ', ' ORDER BY ProjectID) AS ProjectNames
        FROM Projects
        GROUP BY DepartmentID)
SELECT e.EmployeeID,
       e.Name AS EmployeeName,
       e.ManagerID,
       d.DepartmentName,
       r.RoleName,
       pa.ProjectNames,
       ta.TaskNames,
       mt.TotalSubordinates
FROM Employees e
         JOIN Roles r ON e.RoleID = r.RoleID
         JOIN Departments d ON e.DepartmentID = d.DepartmentID
         LEFT JOIN projects_agg pa ON e.DepartmentID = pa.DepartmentID
         LEFT JOIN tasks_agg ta ON e.EmployeeID = ta.AssignedTo
-- Оставляем только сотрудников, у которых есть хотя бы один подчинённый (рекурсивный подсчёт)
         JOIN mgr_total mt ON e.EmployeeID = mt.ManagerID
WHERE r.RoleName = 'Менеджер'
ORDER BY e.EmployeeID;
