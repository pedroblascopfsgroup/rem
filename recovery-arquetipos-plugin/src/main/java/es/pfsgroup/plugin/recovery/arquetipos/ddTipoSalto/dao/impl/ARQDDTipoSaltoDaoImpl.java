package es.pfsgroup.plugin.recovery.arquetipos.ddTipoSalto.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.arquetipo.model.DDTipoSaltoNivel;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.arquetipos.ddTipoSalto.dao.ARQDDTipoSaltoDao;




@Repository("ARQDDTipoSaltoDao")
public class ARQDDTipoSaltoDaoImpl extends AbstractEntityDao<DDTipoSaltoNivel, Long> implements ARQDDTipoSaltoDao {

}
