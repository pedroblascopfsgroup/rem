package es.pfsgroup.plugin.recovery.itinerarios.estadoTelecobro.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;

public interface ITIEstadoTelecobroDao extends AbstractDao<EstadoTelecobro, Long>{

	public EstadoTelecobro createNewEstadoTelecobro();

}
