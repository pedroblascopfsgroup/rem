package es.pfsgroup.plugin.rem.activo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTributoDao;
import es.pfsgroup.plugin.rem.model.ActivoTributos;

@Repository("ActivoTributoDao")
public class ActivoTributoDaoImpl extends AbstractEntityDao<ActivoTributos, Long> implements ActivoTributoDao {

	private static final String REST_USER_USERNAME = "REST-USER";

}
