package Interfaces;

import Modelo_jvl.ClsSeguimiento_jvl;
import java.util.List;

public interface ISeguimientoDAO {

    boolean registrarSeguimiento(ClsSeguimiento_jvl seguimiento);

    List<ClsSeguimiento_jvl> listarPorReclamo(int idReclamo);
}
