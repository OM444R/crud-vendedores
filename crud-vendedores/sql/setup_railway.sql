-- Crear tablas si no existen
CREATE TABLE IF NOT EXISTS Distrito (
    id_distrito INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Vendedor (
    id_ven INT PRIMARY KEY AUTO_INCREMENT,
    nom_ven VARCHAR(25) NOT NULL,
    ape_ven VARCHAR(25) NOT NULL,
    cel_ven CHAR(9) NOT NULL,
    id_distrito INT,
    FOREIGN KEY (id_distrito) REFERENCES Distrito(id_distrito) ON DELETE SET NULL
);

-- Insertar distritos si la tabla está vacía
INSERT INTO Distrito (nombre)
SELECT * FROM (
    SELECT 'San Juan de Lurigancho' UNION
    SELECT 'San Martín de Porres' UNION
    SELECT 'Ate' UNION
    SELECT 'Comas' UNION
    SELECT 'Villa El Salvador' UNION
    SELECT 'Villa María del Triunfo' UNION
    SELECT 'San Juan de Miraflores' UNION
    SELECT 'Los Olivos' UNION
    SELECT 'Puente Piedra' UNION
    SELECT 'Santiago de Surco'
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM Distrito LIMIT 1);

-- Procedimientos de paginación
DELIMITER //
CREATE PROCEDURE sp_lisven_paginado(IN p_offset INT, IN p_limit INT)
BEGIN
    SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nombre as distrito
    FROM Vendedor v
    JOIN Distrito d ON v.id_distrito = d.id_distrito
    ORDER BY v.id_ven
    LIMIT p_offset, p_limit;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_busven_paginado(IN p_id_ven INT, IN p_offset INT, IN p_limit INT)
BEGIN
    SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nombre as distrito
    FROM Vendedor v
    JOIN Distrito d ON v.id_distrito = d.id_distrito
    WHERE v.id_ven = p_id_ven
    LIMIT p_offset, p_limit;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_searchven_paginado(IN p_busqueda VARCHAR(100), IN p_offset INT, IN p_limit INT)
BEGIN
    SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nombre as distrito
    FROM Vendedor v
    JOIN Distrito d ON v.id_distrito = d.id_distrito
    WHERE v.nom_ven LIKE CONCAT('%', p_busqueda, '%')
       OR v.ape_ven LIKE CONCAT('%', p_busqueda, '%')
    ORDER BY v.id_ven
    LIMIT p_offset, p_limit;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_contar_busven(IN p_id_ven INT)
BEGIN
    SELECT COUNT(*) as total
    FROM Vendedor
    WHERE id_ven = p_id_ven;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_contar_searchven(IN p_busqueda VARCHAR(100))
BEGIN
    SELECT COUNT(*) as total
    FROM Vendedor
    WHERE nom_ven LIKE CONCAT('%', p_busqueda, '%')
       OR ape_ven LIKE CONCAT('%', p_busqueda, '%');
END //
DELIMITER ; 