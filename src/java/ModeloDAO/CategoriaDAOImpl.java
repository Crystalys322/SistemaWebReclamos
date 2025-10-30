package ModeloDAO;

import Config_jvl.ClsConexion;
import Interfaces.ICategoriaDAO;
import Modelo_jvl.ClsCategoria_jvl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CategoriaDAOImpl implements ICategoriaDAO {

    private static final String SQL_SELECT_ALL = "SELECT idCategoria, nombreCategoria FROM categorias ORDER BY nombreCategoria";
    private static final String SQL_SELECT_BY_ID = "SELECT idCategoria, nombreCategoria FROM categorias WHERE idCategoria = ?";

    private final ClsConexion conexion;

    public CategoriaDAOImpl() {
        this.conexion = new ClsConexion();
    }

    @Override
    public List<ClsCategoria_jvl> listarCategorias() {
        List<ClsCategoria_jvl> categorias = new ArrayList<>();
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return categorias;
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_ALL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categorias.add(mapearCategoria(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error listarCategorias: " + e.getMessage());
        }
        return categorias;
    }

    @Override
    public Optional<ClsCategoria_jvl> obtenerPorId(int idCategoria) {
        Connection cn = conexion.getConnection();
        if (cn == null) {
            return Optional.empty();
        }
        try (PreparedStatement ps = cn.prepareStatement(SQL_SELECT_BY_ID)) {
            ps.setInt(1, idCategoria);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapearCategoria(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorId categoria: " + e.getMessage());
        }
        return Optional.empty();
    }

    private ClsCategoria_jvl mapearCategoria(ResultSet rs) throws SQLException {
        ClsCategoria_jvl categoria = new ClsCategoria_jvl();
        categoria.setIdCategoria(rs.getInt("idCategoria"));
        categoria.setNombreCategoria(rs.getString("nombreCategoria"));
        return categoria;
    }
}
