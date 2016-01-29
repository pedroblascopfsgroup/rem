package es.pfsgroup.plugin.recovery.itinerarios.ddTipoReclamacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReclamacion.dao.ITIDDTipoReclamacionDao;

@Repository("ITIDDTipoReclamacionDao")
public class ITIDDTipoReclamacionDaoImpl extends AbstractEntityDao<DDTipoReclamacion, Long>
	implements ITIDDTipoReclamacionDao{

}
