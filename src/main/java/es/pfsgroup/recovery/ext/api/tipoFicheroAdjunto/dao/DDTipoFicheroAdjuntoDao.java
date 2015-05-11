package es.pfsgroup.recovery.ext.api.tipoFicheroAdjunto.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

public interface DDTipoFicheroAdjuntoDao extends AbstractDao<DDTipoFicheroAdjunto,Long>{
	
	public List<DDTipoFicheroAdjunto> getListaPorTipoDeActuacion(List<DDTipoActuacion> actuaciones);

}
