WITH RECURSIVE subordinates AS (
    -- Начинаем с сотрудника Иван Иванов
    SELECT EmployeeID,
           Name,
           ManagerID,
           DepartmentID,
           RoleID
    FROM Employees
    WHERE EmployeeID = 1
    UNION ALL
    -- Рекурсивно добавляем сотрудников, чьим менеджером является кто-либо из уже найденных
    SELECT e.EmployeeID,
           e.Name,
           e.ManagerID,
           e.DepartmentID,
           e.RoleID
    FROM Employees e
             INNER JOIN subordinates s ON e.ManagerID = s.EmployeeID)
SELECT s.EmployeeID,
       s.Name AS EmployeeName,
       s.ManagerID,
       d.DepartmentName,
       r.RoleName,
       -- Для проектов – выбираем проекты, где DepartmentID сотрудника совпадает с DepartmentID проекта.
       p.ProjectNames,
       -- Для задач – агрегируем задачи, назначенные сотруднику, если они есть.
       t.TaskNames
FROM subordinates s
         JOIN Departments d ON s.DepartmentID = d.DepartmentID
         LEFT JOIN Roles r ON s.RoleID = r.RoleID
         LEFT JOIN (SELECT DepartmentID,
                           STRING_AGG(ProjectName, ', ') AS ProjectNames
                    FROM Projects
                    GROUP BY DepartmentID) p ON s.DepartmentID = p.DepartmentID
         LEFT JOIN (SELECT AssignedTo,
                           STRING_AGG(TaskName, ', ' ORDER BY TaskID DESC) AS TaskNames
                    FROM Tasks
                    GROUP BY AssignedTo) t ON s.EmployeeID = t.AssignedTo
ORDER BY s.Name;
