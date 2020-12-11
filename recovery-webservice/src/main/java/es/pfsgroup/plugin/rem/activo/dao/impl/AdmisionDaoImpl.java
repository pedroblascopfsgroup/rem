package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.AdmisionDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgendaRevisionTitulo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.NotificacionGencat;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;
import es.pfsgroup.plugin.rem.model.VisitaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Repository("AdmisionDao")
public class AdmisionDaoImpl extends AbstractEntityDao<ActivoAgendaRevisionTitulo, Long> implements AdmisionDao{




}