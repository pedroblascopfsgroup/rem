package es.pfsgroup.plugin.recovery.burofax.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.model.DDTipoIntervencion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.burofax.PluginBurofaxConstantsComponents;
import es.pfsgroup.plugin.recovery.burofax.dao.BURDDTipoIntervencionDao;

@Repository(PluginBurofaxConstantsComponents.DD_TIPO_INTERVENCION_REPOSITORY)
public class BURDDTipoIntervencionDaoImpl extends AbstractEntityDao<DDTipoIntervencion, Long> implements BURDDTipoIntervencionDao{

}
