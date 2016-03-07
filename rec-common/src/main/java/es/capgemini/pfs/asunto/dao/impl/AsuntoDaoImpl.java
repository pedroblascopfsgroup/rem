package es.capgemini.pfs.asunto.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.dao.EstadoAsuntoDao;
import es.capgemini.pfs.asunto.dao.FichaAceptacionDao;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.FichaAceptacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.dto.DtoListadoAsuntos;
import es.capgemini.pfs.comite.dao.ComiteDao;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.dao.DDEstadoItinerarioDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * asuntos.
 *
 * @author mtorrado
 */
@Repository("AsuntoDao")
public class AsuntoDaoImpl extends AbstractEntityDao<Asunto, Long> implements AsuntoDao {

    @Autowired
    private DDEstadoItinerarioDao ddEstadoItinerarioDao;
    @Autowired
    private ComiteDao comiteDao;
    @Autowired
    private EstadoAsuntoDao estadoAsuntoDao;

    @Autowired
    private FichaAceptacionDao fichaAceptacionDao;

    @Resource
    private PaginationManager paginationManager;

    @Autowired
    private UsuarioManager usuarioManager;

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Asunto> obtenerAsuntosDeUnaPersona(Long idPersona) {
        List<Asunto> asuntos = null;
        String hsql = "select distinct asu from ExpedienteContrato cex, ProcedimientoContratoExpediente pce, ContratoPersona cpe, Asunto asu, Procedimiento prc ";
        hsql += " where cpe.contrato.id = cex.contrato.id ";
        //hsql += " and prod = prc";
        hsql += " and cex.id = pce.expedienteContrato and prc.id = pce.procedimiento ";
        hsql += " and prc.asunto.id = asu.id";
        hsql += " and asu.auditoria." + Auditoria.UNDELETED_RESTICTION;
        hsql += " and prc.auditoria." + Auditoria.UNDELETED_RESTICTION;
        hsql += " and cpe.persona.id = ?";

        asuntos = getHibernateTemplate().find(hsql, new Object[] { idPersona });

        return asuntos;
    }

    /**
     * {@inheritDoc}
     */
    public Page obtenerAsuntosDeUnaPersonaPaginados(DtoListadoAsuntos dto) {
        StringBuilder hql = new StringBuilder();
        
        // FASE 1154 Se deja la consulta anterior para hacer un estudio temporal lanzando al log los resultados que saldrian con esta consulta  y con la nueva. 
        // Una vez realizado el estudio podriamos eliminar la variable hqltemp y sus referencias.        
        hql.append("select distinct asu from Asunto asu, Procedimiento prc, ProcedimientoPersona prcper ");
		hql.append(" where prc.asunto.id = asu.id ");
		hql.append(" and prcper.procedimiento = prc");
		hql.append(" and asu.auditoria.borrado = false ");
		hql.append(" and prc.auditoria.borrado = false ");
		hql.append(" and prcper.persona.id = :idPersona "); 
		
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("idPersona", dto.getIdPersona());
        
        Page page = paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dto, params);

        return page;

    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Asunto> obtenerAsuntosDeUnAsunto(Long idAsunto) {
        String hql = "from Asunto asu where asu.asuntoOrigen.id = ? and asu.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql, new Object[] { idAsunto });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Asunto> obtenerAsuntosDeUnExpediente(Long idExpediente) {
        String hql = "from Asunto asu where asu.expediente.id = ? and asu.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql, new Object[] { idExpediente });
    }

    /**
     * {@inheritDoc}
     */
    public Long crearAsunto(GestorDespacho gestorDespacho, GestorDespacho supervisor, GestorDespacho procurador, String nombreAsunto,
            Expediente expediente, String observaciones) {
        Asunto asunto = new Asunto();
        asunto.setObservacion(observaciones);
        asunto.setSupervisor(supervisor);
        asunto.setGestor(gestorDespacho);
        asunto.setProcurador(procurador);
        asunto.setEstadoAsunto(estadoAsuntoDao.buscarPorCodigo(DDEstadoAsunto.ESTADO_ASUNTO_EN_CONFORMACION));
        asunto.setNombre(nombreAsunto);
        asunto.setExpediente(expediente);
        asunto.setFechaEstado(new Date(System.currentTimeMillis()));
        asunto.setEstadoItinerario(ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_ASUNTO).get(0));
        FichaAceptacion ficha = new FichaAceptacion();
        Long idAsunto = save(asunto);
        ficha.setAsunto(asunto);
        fichaAceptacionDao.save(ficha);
        return idAsunto;
    }

    /**
     * {@inheritDoc}
     */
    public Long modificarAsunto(Long idAsunto, GestorDespacho gestorDespacho, GestorDespacho supervisor, GestorDespacho procurador,
            String nombreAsunto, String observaciones) {
        Asunto asunto = get(idAsunto);
        if (gestorDespacho.getId().longValue() != asunto.getGestor().getId().longValue()) {
            asunto.setGestor(gestorDespacho);
        }
        asunto.setProcurador(procurador);
        asunto.setObservacion(observaciones);
        asunto.setSupervisor(supervisor);
        asunto.setNombre(nombreAsunto);
        update(asunto);
        return idAsunto;
    }

    private boolean requiereProcedimiento(DtoBusquedaAsunto dto) {
        return dto.getMaxImporteEstimado() != null || dto.getMinImporteEstimado() != null || dto.getMaxSaldoTotalContratos() != null
                || dto.getMinSaldoTotalContratos() != null
                || (dto.getCodigoProcedimientoEnJuzgado() != null && !dto.getCodigoProcedimientoEnJuzgado().equals(""))
                || (dto.getTiposProcedimiento() != null && dto.getTiposProcedimiento().size() > 0);
    }

    private boolean requiereContrato(DtoBusquedaAsunto dto) {
        return (dto.getCodigoZonas().size() > 0 || (dto.getFiltroContrato() != null && dto.getFiltroContrato() > 0L));
    }

    /**
     * {@inheritDoc}
     */
    public Page buscarAsuntosPaginated(DtoBusquedaAsunto dto) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        final int bufferSize = 1024;
        StringBuffer hql = new StringBuffer(bufferSize);
        hql.append("from Asunto a where a.id in (select distinct asu.id from Asunto asu");

        if (requiereContrato(dto) || requiereProcedimiento(dto)) {
            hql.append(", Procedimiento prc");
        }
        if (requiereContrato(dto)) {
            hql.append(", ProcedimientoContratoExpediente pce, ExpedienteContrato cex, Contrato cnt ");
        }
        if (dto.getIdSesionComite() != null && !"".equals(dto.getIdSesionComite()) || dto.getIdComite() != null && !"".equals(dto.getIdComite())) {
            hql.append(", DecisionComite dco , DDEstadoItinerario estIti ");
        }
        hql.append(" where asu.auditoria." + Auditoria.UNDELETED_RESTICTION);

        if (requiereContrato(dto) || requiereProcedimiento(dto)) {
            hql.append(" and prc.asunto.id = asu.id ");
            hql.append(" and prc.auditoria." + Auditoria.UNDELETED_RESTICTION);
        }
        if (requiereContrato(dto)) {
            hql.append(" and prc.id = pce.procedimiento and cex.id = pce.expedienteContrato and cex.contrato.id = cnt.id ");
            hql.append(" and cex.auditoria." + Auditoria.UNDELETED_RESTICTION);
        }

        //PERMISOS DEL USUARIO (en caso de que sea externo)
        Usuario usuarioLogado = usuarioManager.getUsuarioLogado();
        if (usuarioLogado.getUsuarioExterno()) {
            hql.append(" and (asu.gestor.usuario.id = " + usuarioLogado.getId() + " or asu.supervisor.usuario.id = " + usuarioLogado.getId() + ") ");
        }
        //ASUNTO
        if (dto.getCodigoAsunto() != null && !"".equals(dto.getCodigoAsunto())) {
            hql.append(" and asu.id = :asuCod");
            params.put("asuCod", new Long(dto.getCodigoAsunto()));
        }
        //NOMBRE
        if (dto.getNombre() != null && !"".equals(dto.getNombre())) {
            hql.append(" and lower(asu.nombre) like '%'|| :asuName ||'%'");
            params.put("asuName", dto.getNombre().toLowerCase());
        }
        //DESPACHO
        if (dto.getComboDespachos() != null && !"".equals(dto.getComboDespachos())) {
            hql.append(" and asu.gestor.despachoExterno.id = :despExtId");
            params.put("despExtId", new Long(dto.getComboDespachos()));
        }
        //GESTOR
        if (dto.getComboGestor() != null && !"".equals(dto.getComboGestor())) {
            hql.append(" and (");
            StringTokenizer tokensGestores = new StringTokenizer(dto.getComboGestor(), ",");
            while (tokensGestores.hasMoreElements()) {
                hql.append(" asu.gestor.id = '" + tokensGestores.nextToken() + "'");
                if (tokensGestores.hasMoreElements()) {
                    hql.append(" or ");
                }
            }
            hql.append(")");
        }
        //ESTADO ASUNTO
        if (dto.getComboEstados() != null && !"".equals(dto.getComboEstados())) {
            hql.append(" and asu.estadoAsunto.codigo = :estadoAsu");
            params.put("estadoAsu", dto.getComboEstados());
        }
        //ESTADO ITINERARIO ASUNTO
        if (dto.getEstadoItinerario() != null && !"".equals(dto.getEstadoItinerario())) {
            hql.append(" and asu.estadoItinerario.codigo = :estadoIti");
            params.put("estadoIti", dto.getEstadoItinerario());
        }
        //COMITE ASUNTO
        if (dto.getIdComite() != null && !"".equals(dto.getIdComite())) {
            hql.append(" and (( asu.comite.id = :comiteId");
            params.put("comiteId", new Long(dto.getIdComite()));
            hql.append(" and asu.estadoItinerario.id = estIti.id and estIti.codigo = :estadoDC");
            hql.append(" and asu.estadoAsunto.codigo = :estadoAsuntoPropuesto )");
            params.put("estadoDC", DDEstadoItinerario.ESTADO_DECISION_COMIT);
            params.put("estadoAsuntoPropuesto", DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO);
            Comite comite = comiteDao.get(dto.getIdComite());
            hql.append(" or (asu.decisionComite.id = dco.id and dco.sesion.id = :ultimaSesionComiteId))");
            params.put("ultimaSesionComiteId", new Long(comite.getUltimaSesion().getId()));
        }
        if (dto.getIdSesionComite() != null && !"".equals(dto.getIdSesionComite())) {
            hql.append(" and asu.decisionComite.id = dco.id and dco.sesion.id = :sesionComiteId");
            params.put("sesionComiteId", new Long(dto.getIdSesionComite()));
        }
        //SUPERVISOR
        if (dto.getComboSupervisor() != null && !"".equals(dto.getComboSupervisor())) {
            hql.append(" and asu.supervisor.usuario.id = :supervisorId");
            params.put("supervisorId", new Long(dto.getComboSupervisor()));
        }
        //ESTADO ANALISIS
        //TODO VER CON FO: artf429805
        /*if (dto.getEstadoAnalisis()!=null){
        	hql.append(" and ");
        	StringTokenizer tokensEstados = new StringTokenizer(dto.getEstadoAnalisis(), ",");
        	hql.append("(");
        	while (tokensEstados.hasMoreElements()){
        		hql.append(" as.gestor.gestorDespacho.id = '"+tokensEstados.nextToken()+"'");
        		if (tokensEstados.hasMoreElements()){
        			hql.append(" or ");
        		}
        	}
        	hql.append(")");
        }*/

        //CODIGO CONTRATO
        if (dto.getFiltroContrato() != null && dto.getFiltroContrato() > 0L) {
            hql.append(" and cnt.nroContrato like '%'|| :filtroCnt ||'%'");
            params.put("filtroCnt", dto.getFiltroContrato());
        }
        //FECHA DESDE
        if (dto.getFechaCreacionDesde() != null && !"".equals(dto.getFechaCreacionDesde())) {
            hql.append(" and asu.auditoria.fechaCrear >= :fechaCrearDesde");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            try {
                params.put("fechaCrearDesde", sdf1.parse(dto.getFechaCreacionDesde()));
            } catch (ParseException e) {
                logger.error("Error parseando la fecha desde", e);
            }
        }
        //FECHA HASTA
        if (dto.getFechaCreacionHasta() != null && !"".equals(dto.getFechaCreacionHasta())) {
            hql.append(" and asu.auditoria.fechaCrear <= :fechaCrearHasta");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            try {
                Calendar c = new GregorianCalendar();
                c.setTime(sdf1.parse(dto.getFechaCreacionHasta()));
                c.add(Calendar.DAY_OF_YEAR, 1);
                params.put("fechaCrearHasta", c.getTime());
            } catch (ParseException e) {
                logger.error("Error parseando la fecha hasta", e);
            }
        }

        //VISIBILIDAD
        //Se suma la visibilidad por pertenencia al asunto + la visibilidad por zonas
        hql.append(" and (");
        hql.append(" (asu.gestor.usuario.id = " + usuarioLogado.getId() + " or asu.supervisor.usuario.id = " + usuarioLogado.getId()
                + " or asu.supervisorComite.id  = " + usuarioLogado.getId() + ") ");

        //O visibilidad por zonas
        if (dto.getCodigoZonas().size() > 0) {
            hql.append(" or ( ");
            for (String codigoZ : dto.getCodigoZonas()) {
                //si alguno de los contratos del asunto tiene alguna de las zonas....
                hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR");
            }
            hql.delete(hql.length() - 2, hql.length());
            hql.append(" ) ");
        }
        hql.append(")");

        //FILTRO DE ZONAS
        if (dto.getJerarquia() != null && dto.getJerarquia().length() > 0) {
            hql.append(" and cnt.zona.nivel.id >= :nivelId");
            params.put("nivelId", new Long(dto.getJerarquia()));

            if (dto.getCodigoZonas().size() > 0) {
                hql.append(" and ( ");
                for (String codigoZ : dto.getCodigoZonas()) {
                    //si alguno de los contratos del asunto tiene alguna de las zonas....
                    hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR");
                }
                hql.delete(hql.length() - 2, hql.length());
                hql.append(" ) ");
            }
        }

        if (requiereProcedimiento(dto)) {

            //Codigo de procedimiento en juzgado
            if (dto.getCodigoProcedimientoEnJuzgado() != null && !dto.getCodigoProcedimientoEnJuzgado().equals("")) {
                hql.append(" and (");
                hql.append(" prc.codigoProcedimientoEnJuzgado like '%" + dto.getCodigoProcedimientoEnJuzgado() + "%' ");
                hql.append(" ) ");
            }
            //Tipos de procedimiento
            if (dto.getTiposProcedimiento() != null && dto.getTiposProcedimiento().size() > 0) {
                hql.append(" and (");
                boolean first = true;
                for (String cod : dto.getTiposProcedimiento()) {
                    if (first)
                        first = false;
                    else
                        hql.append(" OR ");
                    hql.append(" prc.tipoProcedimiento.codigo like '" + cod + "' ");
                }
                hql.append(" ) ");
            }

        }
        //MAX MINS
        if (requiereProcedimiento(dto)) {
            if (dto.getMaxSaldoTotalContratos() == null) {
                dto.setMaxSaldoTotalContratos((float) Integer.MAX_VALUE);
            }
            if (dto.getMinSaldoTotalContratos() == null) {
                dto.setMinSaldoTotalContratos(0f);
            }
            if (dto.getMaxImporteEstimado() == null) {
                dto.setMaxImporteEstimado((double) Integer.MAX_VALUE);
            }
            if (dto.getMinImporteEstimado() == null) {
                dto.setMinImporteEstimado(0d);
            }

            hql.append(" group by asu.id having ( ");
            hql.append(" (sum(abs(prc.saldoOriginalVencido) + abs(prc.saldoOriginalNoVencido)) between :minSaldoTotalCnt and :maxSaldoTotalCnt)");
            hql.append(" and sum(abs(prc.saldoRecuperacion)) between :minImporteEst and :maxImporteEst)");
            params.put("minSaldoTotalCnt", new BigDecimal(dto.getMinSaldoTotalContratos()));
            params.put("maxSaldoTotalCnt", new BigDecimal(dto.getMaxSaldoTotalContratos()));
            params.put("minImporteEst", new BigDecimal(dto.getMinImporteEstimado()));
            params.put("maxImporteEst", new BigDecimal(dto.getMaxImporteEstimado()));
        }
        hql.append(")"); //El que cierra la subquery

        if (DtoBusquedaAsunto.SALIDA_XLS.equals(dto.getTipoSalida())) {
            dto.setLimit(Integer.MAX_VALUE);
        }
        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dto, params);
    }

    /**
     * Indica si el usuario logueado tiene que responder alguna comunicaciÃ³n.
     * @param idAsunto el id del asunto.
     * @param usuarioLogado el usuario logueado
     * @return true o false;
     */
    @SuppressWarnings("unchecked")
    public TareaNotificacion buscarTareaPendiente(Long idAsunto, Long usuarioLogado) {
        String hql = "Select t from TareaNotificacion t, Asunto a where " + "t.asunto = a " + "and a.id = ? " + "and ((a.gestor.usuario.id = ? "
                + "and t.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR + ") " + "or "
                + "(a.supervisor.usuario.id = ? " + "and t.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR + ")) "
                + "and t.auditoria.borrado = 0";
        List<TareaNotificacion> tareas = getHibernateTemplate().find(hql, new Object[] { idAsunto, usuarioLogado, usuarioLogado });
        if (tareas.size() > 0) { return tareas.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Persona> obtenerPersonasDeUnAsunto(Long idAsunto) {
        String hql = "select distinct prcPer " + " from Asunto asu join asu.procedimientos prc " + "      join prc.personasAfectadas prcPer "
                + " where asu.id = ? and prc.auditoria." + Auditoria.UNDELETED_RESTICTION;

        return getHibernateTemplate().find(hql, idAsunto);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Persona> obtenerPersonasDeUnAsuntoConAdjuntos(Long idAsunto) {
        String hql = "select distinct prcPer " + " from Asunto asu join asu.procedimientos prc " + "      join prc.personasAfectadas prcPer "
                + "      join prcPer.adjuntos adj " + " where asu.id = ? and prc.auditoria." + Auditoria.UNDELETED_RESTICTION;

        return getHibernateTemplate().find(hql, idAsunto);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Contrato> getContratosQueTienenAdjuntos(Long asuntoId) {
        String hql = "select distinct cex.contrato "
                + " from Asunto asu, Procedimiento prc, ProcedimientoContratoExpediente pce, ExpedienteContrato cex " + " where asu.id = ? "
                + "       and asu.id = prc.asunto.id and prc.id = pce.procedimiento and pce.expedienteContrato = cex.id "
                + "       and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + "       and asu.auditoria." + Auditoria.UNDELETED_RESTICTION
                + "       and prc.auditoria." + Auditoria.UNDELETED_RESTICTION;

        return getHibernateTemplate().find(hql, asuntoId);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Procedimiento> getProcedimientosOrderNroJuzgado(Long idAsunto) {
        String hql = "select p from Procedimiento p where p.asunto.id = ? and p.auditoria.borrado = false ";
        hql += " and not exists (select id from ProcedimientoDerivado where decisionProcedimiento.estadoDecision.codigo IN (?,?) and procedimiento.id = p.id)";
        hql += " order by p.codigoProcedimientoEnJuzgado, p.id";

        return getHibernateTemplate().find(hql, new Object[] { idAsunto, DDEstadoDecision.ESTADO_PROPUESTO, DDEstadoDecision.ESTADO_RECHAZADO });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Boolean isNombreAsuntoDuplicado(String nombreAsunto, Long idAsuntoOriginal) {
        DetachedCriteria crit = DetachedCriteria.forClass(Asunto.class);
        crit.add(Restrictions.eq("nombre", nombreAsunto));
        crit.add(Restrictions.eq("auditoria.borrado", false));
        if (idAsuntoOriginal != null) crit.add(Restrictions.ne("id", idAsuntoOriginal));

        List<Asunto> listado = getHibernateTemplate().findByCriteria(crit);
        if (listado == null || listado.size() == 0)
            return false;
        else
            return true;
    }

    @Override
    public Long getNumAsuntosMismoNombre(String nombreAsunto) {
        String hql = "select count(*) from Asunto where nombre like :nombreAsunto";

        Query query = getSession().createQuery(hql);
        query.setParameter("nombreAsunto", nombreAsunto);

        return (Long) query.uniqueResult();
    }
}
