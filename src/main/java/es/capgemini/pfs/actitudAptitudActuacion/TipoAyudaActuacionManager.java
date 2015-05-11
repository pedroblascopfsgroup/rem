package es.capgemini.pfs.actitudAptitudActuacion;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.actitudAptitudActuacion.dao.TipoAyudaActuacionDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDTipoAyudaActuacion;

/**
 * Clase de servicios de acceso de datos tipo ayuda actuacion.
 * @author mtorrado
 *
 */
@Service
public class TipoAyudaActuacionManager {

    @Autowired
    private TipoAyudaActuacionDao tipoAyudaActuacionDao;

    /**
     * Retorna una lista de tipos ayuda actuación.
     * @return List tipos ayuda actuación.
     */
    @BusinessOperation
    public List<DDTipoAyudaActuacion> getList() {
        return tipoAyudaActuacionDao.getList();
    }

    /**
    * Retorna un tipo ayuda actuación.
    * @param id Long
    * @return TipoAyudaActuacion
    */
    @BusinessOperation
    @Deprecated
    public DDTipoAyudaActuacion get(Long id) {
        return tipoAyudaActuacionDao.get(id);
    }

    /**
    * Retorna un tipo ayuda actuación por su código.
    * @param codigo String
    * @return TipoAyudaActuacion
    */
    @BusinessOperation
    public DDTipoAyudaActuacion getByCodigo(String codigo) {
        return tipoAyudaActuacionDao.getByCodigo(codigo);
    }
}
