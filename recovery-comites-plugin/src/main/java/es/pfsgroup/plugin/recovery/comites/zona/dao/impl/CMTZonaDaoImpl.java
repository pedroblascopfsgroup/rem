package es.pfsgroup.plugin.recovery.comites.zona.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.plugin.recovery.comites.zona.dao.CMTZonaDao;

@Repository("CMTZonaDao")
public class CMTZonaDaoImpl extends AbstractEntityDao<DDZona, Long> implements CMTZonaDao{

}
