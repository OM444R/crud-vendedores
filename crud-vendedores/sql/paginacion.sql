-- Procedimiento para listar vendedores con paginación
DELIMITER //
CREATE PROCEDURE sp_lisven_paginado(IN p_offset INT, IN p_limit INT)
BEGIN
    SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nom_distrito as distrito
    FROM vendedor v
    JOIN distrito d ON v.id_distrito = d.id_distrito
    ORDER BY v.id_ven
    LIMIT p_offset, p_limit;
END //
DELIMITER ;

-- Procedimiento para buscar vendedor por ID con paginación
DELIMITER //
CREATE PROCEDURE sp_busven_paginado(IN p_id_ven INT, IN p_offset INT, IN p_limit INT)
BEGIN
    SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nom_distrito as distrito
    FROM vendedor v
    JOIN distrito d ON v.id_distrito = d.id_distrito
    WHERE v.id_ven = p_id_ven
    LIMIT p_offset, p_limit;
END //
DELIMITER ;

-- Procedimiento para buscar vendedor por nombre/apellido con paginación
DELIMITER //
CREATE PROCEDURE sp_searchven_paginado(IN p_busqueda VARCHAR(100), IN p_offset INT, IN p_limit INT)
BEGIN
    SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nom_distrito as distrito
    FROM vendedor v
    JOIN distrito d ON v.id_distrito = d.id_distrito
    WHERE v.nom_ven LIKE CONCAT('%', p_busqueda, '%')
       OR v.ape_ven LIKE CONCAT('%', p_busqueda, '%')
    ORDER BY v.id_ven
    LIMIT p_offset, p_limit;
END //
DELIMITER ;

-- Procedimiento para contar resultados de búsqueda por ID
DELIMITER //
CREATE PROCEDURE sp_contar_busven(IN p_id_ven INT)
BEGIN
    SELECT COUNT(*) as total
    FROM vendedor
    WHERE id_ven = p_id_ven;
END //
DELIMITER ;

-- Procedimiento para contar resultados de búsqueda por nombre/apellido
DELIMITER //
CREATE PROCEDURE sp_contar_searchven(IN p_busqueda VARCHAR(100))
BEGIN
    SELECT COUNT(*) as total
    FROM vendedor
    WHERE nom_ven LIKE CONCAT('%', p_busqueda, '%')
       OR ape_ven LIKE CONCAT('%', p_busqueda, '%');
END //
DELIMITER ; 