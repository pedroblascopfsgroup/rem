package es.capgemini.pfs.politica.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;

/**
 * Interfaz para acceso a datos del CicloMarcadoPolitica.
 * @author Pablo Jiménez
 *
 */
public interface CicloMarcadoPoliticaDao extends AbstractDao<CicloMarcadoPolitica, Long> {

    /**
     * Recupera los ciclos de marcado de un expediente
     * @param idExpediente
     * @return
     */
    List<CicloMarcadoPolitica> getCiclosMarcadoExpediente(Long idExpediente);
}
