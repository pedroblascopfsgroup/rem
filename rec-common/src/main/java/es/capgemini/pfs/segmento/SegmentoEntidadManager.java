package es.capgemini.pfs.segmento;

import java.io.Serializable;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.segmento.dao.SegmentoEntidadDao;
import es.capgemini.pfs.segmento.model.DDSegmentoEntidad;

/**
 * @author Mariano Ruiz
 */
@Service
public class SegmentoEntidadManager implements Serializable {

    private static final long serialVersionUID = -2923808453045206230L;

    @Autowired
    private SegmentoEntidadDao segmentoEntidadDao;

    /**
     * Retorna la lista del diccionario de segmentos de entidad.
     * @return List
     */
    @BusinessOperation
    public List<DDSegmentoEntidad> getSegmentosEntidad() {
        return segmentoEntidadDao.getList();
    }
}
