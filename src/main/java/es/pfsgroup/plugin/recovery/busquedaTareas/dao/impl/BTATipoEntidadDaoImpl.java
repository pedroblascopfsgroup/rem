package es.pfsgroup.plugin.recovery.busquedaTareas.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTATipoEntidadDao;

@Repository("BTATipoEntidadDao")
public class BTATipoEntidadDaoImpl extends AbstractEntityDao<DDTipoEntidad, Long> implements BTATipoEntidadDao {

}
