const db = require("../config/db");

class VendedorModel {
  static async listarTodos(page = 1, limit = 10) {
    const offset = (page - 1) * limit;
    const [rows] = await db.query(`
      SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nom_distrito as distrito
      FROM vendedor v
      JOIN distrito d ON v.id_distrito = d.id_distrito
      ORDER BY v.id_ven
      LIMIT ?, ?
    `, [offset, limit]);
    return rows;
  }

  static async contarTotal() {
    const [rows] = await db.query("SELECT COUNT(*) as total FROM vendedor");
    return rows[0].total;
  }

  static async buscarPor(busqueda, tipo, page = 1, limit = 10) {
    const offset = (page - 1) * limit;
    try {
      let query;
      let params;

      switch (tipo) {
        case "id":
          query = `
            SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nom_distrito as distrito
            FROM vendedor v
            JOIN distrito d ON v.id_distrito = d.id_distrito
            WHERE v.id_ven = ?
            LIMIT ?, ?
          `;
          params = [busqueda, offset, limit];
          break;
        case "nombre":
        case "apellido":
          query = `
            SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nom_distrito as distrito
            FROM vendedor v
            JOIN distrito d ON v.id_distrito = d.id_distrito
            WHERE v.nom_ven LIKE ? OR v.ape_ven LIKE ?
            ORDER BY v.id_ven
            LIMIT ?, ?
          `;
          params = [`%${busqueda}%`, `%${busqueda}%`, offset, limit];
          break;
        default:
          query = `
            SELECT v.id_ven, v.nom_ven, v.ape_ven, v.cel_ven, d.nom_distrito as distrito
            FROM vendedor v
            JOIN distrito d ON v.id_distrito = d.id_distrito
            ORDER BY v.id_ven
            LIMIT ?, ?
          `;
          params = [offset, limit];
      }

      const [rows] = await db.query(query, params);
      return rows;
    } catch (error) {
      console.error("Error en buscarPor:", error);
      return [];
    }
  }

  static async contarBusqueda(busqueda, tipo) {
    try {
      let query;
      let params;

      switch (tipo) {
        case "id":
          query = "SELECT COUNT(*) as total FROM vendedor WHERE id_ven = ?";
          params = [busqueda];
          break;
        case "nombre":
        case "apellido":
          query = "SELECT COUNT(*) as total FROM vendedor WHERE nom_ven LIKE ? OR ape_ven LIKE ?";
          params = [`%${busqueda}%`, `%${busqueda}%`];
          break;
        default:
          query = "SELECT COUNT(*) as total FROM vendedor";
          params = [];
      }

      const [rows] = await db.query(query, params);
      return rows[0].total;
    } catch (error) {
      console.error("Error en contarBusqueda:", error);
      return 0;
    }
  }

  static async listarDistritos() {
    const [rows] = await db.query("CALL sp_lisdistritos()");
    return rows[0];
  }

  static async buscarPorId(id) {
    try {
      const [rows] = await db.query("CALL sp_busven(?)", [id]);
      return rows[0] || []; // Aseguramos que siempre devuelva al menos un array vacío
    } catch (error) {
      console.error("Error en buscarPorId:", error);
      return []; // Devolvemos un array vacío en caso de error
    }
  }

  static async crear(nom_ven, ape_ven, cel_ven, id_distrito) {
    const [result] = await db.query("CALL sp_ingven(?, ?, ?, ?)", [
      nom_ven,
      ape_ven,
      cel_ven,
      id_distrito,
    ]);
    return result[0];
  }

  static async actualizar(id_ven, nom_ven, ape_ven, cel_ven, id_distrito) {
    return await db.query("CALL sp_modven(?, ?, ?, ?, ?)", [
      id_ven,
      nom_ven,
      ape_ven,
      cel_ven,
      id_distrito,
    ]);
  }

  static async eliminar(id_ven) {
    return await db.query("CALL sp_delven(?)", [id_ven]);
  }
}

module.exports = VendedorModel;
