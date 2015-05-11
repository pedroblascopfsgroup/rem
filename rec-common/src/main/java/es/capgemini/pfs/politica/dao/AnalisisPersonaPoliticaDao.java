package es.capgemini.pfs.politica.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.AnalisisPersonaPolitica;
import es.capgemini.pfs.politica.model.DDParcelasPersonas;

/**
 * Dao para AnalisisPersonaPolitica.
 * @author Pablo Müller
*/
public interface AnalisisPersonaPoliticaDao extends AbstractDao<AnalisisPersonaPolitica, Long> {

    /**
     * Devuelve todas las parcelas que todavía no se han completado de una persona en un expediente
     * @param idPersona
     * @param idExpediente
     * @return
     */
    List<DDParcelasPersonas> getParcelasSinCompletar(Long idPersona, Long idExpediente);

}
