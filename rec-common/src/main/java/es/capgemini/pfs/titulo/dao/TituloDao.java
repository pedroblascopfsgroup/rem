package es.capgemini.pfs.titulo.dao;

import java.util.List;

import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.titulo.model.Titulo;

/**
 * Clase que agrupa m�todo para la creaci�n y acceso de datos de los
 * títulos.
 * @author mtorrado
 */
public interface TituloDao extends AbstractDao<Titulo, Long> {

    /**
     * M�todo encargado de encontrar un título en base al id de contrato.
     * @param contrato DtoBuscarContrato
     * @return Titulo
     * @throws DataAccessException
     */
    List<Titulo> findTitulobyContrato(DtoBuscarContrato contrato);

    /**
     * M�todo encargado de encontrar un título en base al id de contrato.
     * @param id Long
     * @return Titulo
     * @throws DataAccessException
     */
    List<Titulo> findTitulobyContrato(Long id);

    /**
     * Devuelve la lista de títulos asosciados a los contratos de un expediente.
     * @param idExpediente el id del expediente
     * @return la lista de títulos.
     */
    List<Titulo> findTituloByExpediente(Long idExpediente);

}
