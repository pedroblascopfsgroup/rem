package es.capgemini.pfs.segmento;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.segmento.dao.SegmentoDao;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * @author Mariano Ruiz
 */
@Service
public class SegmentoManager implements Serializable {

    private static final long serialVersionUID = -2923808453045206230L;

    @Autowired
    private SegmentoDao segmentoDao;

    /**
     * Retorna la lista del diccionario de segmentos.
     * @return List
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_SEGMENTO_MGR_GET_SEGMENTOS)
    public List<DDSegmento> getSegmentos() {
        return segmentoDao.getList();
    }

	/**
	 * Retorna la lista de segmentos en base a la lista de códigos pasada.
	 * @param codigos Set String
	 * @return List Segmento
	 */
    @BusinessOperation(PrimariaBusinessOperation.BO_SEGMENTO_MGR_GET_SEGMENTOS_BY_CODIGOS)
    public List<DDSegmento> getSegmentosByCodigos(Set<String> codigos) {
    	return segmentoDao.getSegmentosByCodigos(codigos);
    }
}
