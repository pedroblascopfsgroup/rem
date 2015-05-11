package es.capgemini.pfs.titulo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.titulo.dao.TituloDao;
import es.capgemini.pfs.titulo.model.Titulo;

/**
 * Clase que implementa los métodos de la interfaz TituloDao.
 *
 * @author mtorrado
 *
 */
@Repository("TituloDao")
public class TituloDaoImpl extends AbstractEntityDao<Titulo, Long> implements TituloDao {

    /**
     * M�todo encargado de encontrar un título en base al id de contrato.
     *
     * @param contrato DtoBuscarContrato
     * @return Titulo
     * @throws DataAccessException
     */
    public List<Titulo> findTitulobyContrato(DtoBuscarContrato contrato) {
        return findTitulobyContrato(contrato.getId());
    }

    /**
     * Busca titulos por id de expediente.
     * @param idExpediente Long
     * @return List lista de títulos
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Titulo> findTituloByExpediente(Long idExpediente) {
        String hql = "select t from Titulo t, Expediente e, Contrato c where t.contrato = c "
                + "and c in (select cntId from expediente.contratos where expediente.id = ?)";

        List<Titulo> titulos = getHibernateTemplate().find(hql, new Object[] { idExpediente });
        return titulos;
    }

    /**
     * Busca titulos por id de contrato.
     * @param id Long
     * @return List lista de títulos
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Titulo> findTitulobyContrato(Long id) {
        logger.debug("Buscando titulo para el contrato con id: " + id);

        List<Titulo> titulos;

        String hsql = "from Titulo where ";
        hsql += "contrato.id = ? and auditoria.borrado = false";

        titulos = getHibernateTemplate().find(hsql, new Object[] { id });

        logger.debug("Se encontraron títulos: " + titulos.size());

        return titulos;
    }

}
