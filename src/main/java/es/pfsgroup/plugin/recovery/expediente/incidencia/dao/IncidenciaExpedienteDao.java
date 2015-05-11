package es.pfsgroup.plugin.recovery.expediente.incidencia.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoFiltroIncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.IncidenciaExpediente;

public interface IncidenciaExpedienteDao extends AbstractDao<IncidenciaExpediente, Long> {

	public Page getListadoIncidenciaExpediente(DtoFiltroIncidenciaExpediente dto);

	public DespachoExterno buscarDespachoUnico(Usuario usuario);

}
