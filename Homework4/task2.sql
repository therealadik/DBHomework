WITH RECURSIVE
    emp_hierarchy AS (
        -- Начальный уровень: Иван Иванов (EmployeeID = 1)
        SELECT EmployeeID,
               Name AS EmployeeName,
               ManagerID,
               DepartmentID,
               RoleID
        FROM Employees
        WHERE EmployeeID = 1
        UNION ALL
        -- Рекурсивно выбираем сотрудников, у которых ManagerID совпадает с одним из найденных EmployeeID
        SELECT e.EmployeeID,
               e.Name,
               e.ManagerID,
               e.DepartmentID,
               e.RoleID
        FROM Employees e
                 INNER JOIN emp_hierarchy eh ON e.ManagerID = eh.EmployeeID),
-- Агрегация задач для каждого сотрудника
    tasks_agg AS (SELECT AssignedTo,
                         STRING_AGG(TaskName, ', ' ORDER BY TaskID) AS TaskNames,
                         COUNT(*)                                   AS TotalTasks
                  FROM Tasks
                  GROUP BY AssignedTo),
-- Подсчёт количества прямых подчинённых для каждого менеджера
    direct_subordinates AS (SELECT ManagerID,
                                   COUNT(*) AS TotalSubordinates
                            FROM Employees
                            WHERE ManagerID IS NOT NULL
                            GROUP BY ManagerID)
SELECT eh.EmployeeID,
       eh.EmployeeName,
       eh.ManagerID,
       d.DepartmentName,
       r.RoleName,
       p.ProjectName                     AS ProjectNames,
       t.TaskNames,
       COALESCE(t.TotalTasks, 0)         AS TotalTasks,
       COALESCE(ds.TotalSubordinates, 0) AS TotalSubordinates
FROM emp_hierarchy eh
         JOIN Departments d ON eh.DepartmentID = d.DepartmentID
         LEFT JOIN Roles r ON eh.RoleID = r.RoleID
-- Получаем проект, к которому относится сотрудник (определяется по его отделу)
         LEFT JOIN Projects p ON eh.DepartmentID = p.DepartmentID
-- Присоединяем агрегированные задачи, если таковые есть
         LEFT JOIN tasks_agg t ON eh.EmployeeID = t.AssignedTo
-- Присоединяем количество прямых подчинённых
         LEFT JOIN direct_subordinates ds ON eh.EmployeeID = ds.ManagerID
ORDER BY eh.EmployeeName;
