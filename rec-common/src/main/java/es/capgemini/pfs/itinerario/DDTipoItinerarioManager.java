package es.capgemini.pfs.itinerario;

import java.io.Serializable;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.itinerario.dao.DDTipoItinerarioDao;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;

/**
 * @author pajimene
 */
@Service("ddTipoItinerarioManager")
public class DDTipoItinerarioManager implements Serializable {

    private static final long serialVersionUID = -2923808453045206230L;

    @Autowired
    private DDTipoItinerarioDao tipoItinerarioDao;

    /**
     * Retorna la lista del diccionario de segmentos.
     * @return List
     */
    @BusinessOperation
    public List<DDTipoItinerario> getTipoItinerarios() {
        return tipoItinerarioDao.getList();
    }
}
