package es.capgemini.pfs.itinerario;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.itinerario.dao.ReglasElevacionDao;
import es.capgemini.pfs.itinerario.model.ReglasElevacion;

/**
 * Manager para ReglasElevacion.
 */
@Service
public class ReglasElevacionManager {

    @Autowired
    private ReglasElevacionDao reglasDao;

    /**
     * Retorna todas las reglas definidas de un tipo específico para un estado determinado.
     * @param idTipoRegla Long
     * @param idEstado Long
     * @return Lista de reglas de elevación.
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_REGLAS_MGR_FIND_BY_TIPO_AND_ESTADO)
    public List<ReglasElevacion> findByTipoAndEstado(Long idTipoRegla, Long idEstado) {
        return reglasDao.findByTipoAndEstado(idTipoRegla, idEstado);
    }

    /**
     * @param idRegla long
     * @return ReglasElevacion
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_REGLAS_MGR_GET)
    public ReglasElevacion get(Long idRegla) {
        return reglasDao.get(idRegla);
    }

}
