package es.capgemini.pfs.analisisExterna;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.analisisExterna.dao.DDPlazoAceptacionDao;
import es.capgemini.pfs.analisisExterna.model.DDPlazoAceptacion;

@Service("DDPlazoAceptacionManager")
public class DDPlazoAceptacionManager {
    @Autowired
    private DDPlazoAceptacionDao plazoAceptacionDao;

    /**
     * Recupera un listado de los plazos de aceptacion validos
     * @return
     */
    @BusinessOperation
    public List<DDPlazoAceptacion> getPlazosAceptacion() {
        return plazoAceptacionDao.getList();
    }

}
