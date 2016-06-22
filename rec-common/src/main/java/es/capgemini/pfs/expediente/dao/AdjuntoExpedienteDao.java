package es.capgemini.pfs.expediente.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;

/**
 * Interfaz dao para los Adjuntos.
 *
 * @author Nicolás Cornaglia
 *
 */
public interface AdjuntoExpedienteDao extends AbstractDao<AdjuntoExpediente, Long> {

	List<AdjuntoExpediente> getAdjuntoExpedienteByIdNombreTipoDocumento(
			Long idExpediente, String nombre, String tipoDocumento);


}
