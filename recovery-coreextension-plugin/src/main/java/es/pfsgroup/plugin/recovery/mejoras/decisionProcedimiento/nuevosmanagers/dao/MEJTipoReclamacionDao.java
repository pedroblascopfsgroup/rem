package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao;

import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.dao.AbstractDao;

public interface MEJTipoReclamacionDao extends AbstractDao<DDTipoReclamacion, Long>{

	DDTipoReclamacion getByCodigo(String codigo);

}
