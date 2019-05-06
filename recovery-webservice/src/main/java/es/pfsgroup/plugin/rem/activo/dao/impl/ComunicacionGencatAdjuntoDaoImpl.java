package es.pfsgroup.plugin.rem.activo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.model.ComunicacionGencatAdjunto;

@Repository("ComunicacionGencatAdjunto")
public class ComunicacionGencatAdjuntoDaoImpl extends AbstractEntityDao<ComunicacionGencatAdjunto, Long> implements ComunicacionGencatAdjuntoDao {

}
