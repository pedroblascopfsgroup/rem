package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.dao.AbstractDao;

public interface MEJTipoActuacionDao extends AbstractDao<DDTipoActuacion, Long>{

	DDTipoActuacion getByCodigo(String codigo);

}
