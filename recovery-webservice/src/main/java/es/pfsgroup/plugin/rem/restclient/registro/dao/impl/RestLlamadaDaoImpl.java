package es.pfsgroup.plugin.rem.restclient.registro.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;

@Repository
public class RestLlamadaDaoImpl extends AbstractEntityDao<RestLlamada, Long> implements RestLlamadaDao{

}
