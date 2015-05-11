package es.capgemini.pfs.dsm;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;

/**
 * Clase manager de EntidadConfig.
 * @author Lisandro Medrano
 *
 */
@Service
public class EntidadManager {

    @Autowired
    private EntidadDao entidadDao;

    /**
     * Recupera la lista de entidades.
     * @return lista de entidades
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ENTIDAD_MGR_GET_LISTA_ENTIDADES)
    public List<Entidad> getListaEntidades() {
        return entidadDao.getList();
    }
}
