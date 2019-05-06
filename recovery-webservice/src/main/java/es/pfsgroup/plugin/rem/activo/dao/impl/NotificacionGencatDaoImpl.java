package es.pfsgroup.plugin.rem.activo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.activo.dao.NotificacionGencatDao;
import es.pfsgroup.plugin.rem.model.NotificacionGencat;

@Repository("NotificacionGencat")
public class NotificacionGencatDaoImpl extends AbstractEntityDao<NotificacionGencat, Long> implements NotificacionGencatDao {

}
