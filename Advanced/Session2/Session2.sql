SELECT * FROM student

INSERT INTO student(name, idClass)
VALUES
(N'Tuấn hacker mũ trắng', 1)

DROP PROCEDURE insert_display_student
CREATE PROCEDURE insert_display_student
-- declare parameters
@name nvarchar(50), -- @ +  name + " " + data type
@idClass int = 1
AS
BEGIN
	INSERT INTO student(name, idClass)
	VALUES
	(@name, @idClass)

	SELECT TOP 1 * FROM student
	ORDER BY id desc
END

-- pass arguments to procedure
EXECUTE insert_display_student @name = N'Long hacker mũ đỏ'

DROP PROCEDURE display_student
CREATE PROCEDURE display_student
@id int = -1
AS
BEGIN
	SELECT * FROM student
	WHERE id = @id or @id = -1
END

DROP PROCEDURE modify_student_with_id
CREATE PROCEDURE modify_student_with_id
@name nvarchar(50),
@idClass int = null,
@id int
AS
BEGIN
	exec display_student  @id = @id

	UPDATE student
	SET
	name = @name,
	idClass = CASE WHEN @idClass is null then idClass ELSE @idClass end
	WHERE id = @id

	exec display_student  @id = @id
END

modify_student_with_id @name = 'Long wibu', @id = 3

display_student @id = 2