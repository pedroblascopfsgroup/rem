package es.pfsgroup.plugin.recovery.itinerarios.ddTipoActuacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoActuacion.dao.ITIDDTipoActuacionDao;

@Repository("ITIDDTipoActuacionDao")
public class ITIDDTipoActuacionDaoImpl extends AbstractEntityDao<DDTipoActuacion, Long>
	implements ITIDDTipoActuacionDao{

}
