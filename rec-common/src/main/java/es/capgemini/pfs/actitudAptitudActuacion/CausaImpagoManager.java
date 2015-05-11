package es.capgemini.pfs.actitudAptitudActuacion;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.actitudAptitudActuacion.dao.CausaImpagoDao;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDCausaImpago;

/**
 * Clase de servicios de acceso de datos de causas impago.
 * @author mtorrado
 */
@Service
public class CausaImpagoManager {

	@Autowired
    private CausaImpagoDao causaImpagoDao;

    /**
     * Retorna una lista de causas impago.
     * @return List de causas impago.
     */
    @BusinessOperation
    public List<DDCausaImpago> getList() {
        return causaImpagoDao.getList();
    }

    /**
    * Retorna una situación.
    * @param id Long
    * @return DDSituacion
    */
    @Deprecated
    public DDCausaImpago get(Long id) {
        return causaImpagoDao.get(id);
    }

    /**
     * Obtiene el tipo de causa impago por su código.
     * @param codigo String
     * @return CausaImpago
     */
    @BusinessOperation
    public DDCausaImpago getByCodigo(String codigo) {
        return causaImpagoDao.getByCodigo(codigo);
    }
}
