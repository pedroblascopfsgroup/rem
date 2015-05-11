package es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao;

import java.util.List;

import es.capgemini.pfs.asunto.dto.DtoReportAnotacionAgenda;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.dao.AbstractDao;

public interface MEJAsuntoDao extends AbstractDao<Asunto, Long> {

	/**
	 * Revuelve los Ids de las trazas con correo
	 * 
	 * @param idAsunto
	 * @return
	 */
	List<Long> getListTrazasConCorreo(Long idAsunto);
	
}
