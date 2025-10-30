package Interfaces;

import Modelo_jvl.ClsCategoria_jvl;
import java.util.List;
import java.util.Optional;

public interface ICategoriaDAO {

    List<ClsCategoria_jvl> listarCategorias();

    Optional<ClsCategoria_jvl> obtenerPorId(int idCategoria);
}
