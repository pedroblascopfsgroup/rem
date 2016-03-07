package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dao;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.dao.ComiteDao;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dao.RecoveryAgendaMultifuncionAsuntoDao;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.RecoveryAgendaMultifuncionDtoBusquedaAsunto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;

@Repository("RecoveryAgendaMultifuncionAsuntoDao")
public class RecoveryAgendaMultifuncionAsuntoDaoImpl extends AbstractEntityDao<Asunto, Long> implements RecoveryAgendaMultifuncionAsuntoDao {

    @Resource
    private PaginationManager paginationManager;

    @Autowired
    private ComiteDao comiteDao;

    @Autowired
    GenericABMDao genericDao;

    @Override
    public Page buscarAsuntosPaginated(Usuario usuarioLogado, RecoveryAgendaMultifuncionDtoBusquedaAsunto dto) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        final int bufferSize = 1024;
        StringBuffer hql = new StringBuffer(bufferSize);
        hql.append("from Asunto a where a.id in (select distinct asu.id from Asunto asu");

        if (requiereContrato(dto) || requiereProcedimiento(dto) || requiereIACInfoAddContrato(dto)) {
            hql.append(", Procedimiento prc");
        }
        if (requiereContrato(dto) || requiereIACInfoAddContrato(dto)) {
            hql.append(", ProcedimientoContratoExpediente pce, ExpedienteContrato cex, Contrato cnt, EXTInfoAdicionalContrato iac ");
        }
        if (dto.getIdSesionComite() != null && !"".equals(dto.getIdSesionComite().toString()) || dto.getIdComite() != null && !"".equals(dto.getIdComite().toString())) {
            hql.append(", DecisionComite dco , DDEstadoItinerario estIti ");
        }
        if (requiereTarea(dto)) {
            hql.append(", TareaNotificacion tno");
        }
        if (requiereRegistro(dto)) {
            hql.append(", MEJRegistro reg");
            if (requiereInfoRegistro(dto)) {
                hql.append(", MEJInfoRegistro iReg");
            }
        }

        hql.append(" where asu.auditoria." + Auditoria.UNDELETED_RESTICTION);

        if (requiereContrato(dto) || requiereProcedimiento(dto) || requiereIACInfoAddContrato(dto)) {
            hql.append(" and prc.asunto.id = asu.id ");
            hql.append(" and prc.auditoria." + Auditoria.UNDELETED_RESTICTION);

        }
        if (requiereContrato(dto) || requiereIACInfoAddContrato(dto)) {
            hql.append(" and prc.id = pce.procedimiento and cex.id = pce.expedienteContrato and cex.contrato.id = cnt.id ");
            hql.append(" and cnt.id = iac.contrato.id ");
            hql.append(" and cex.auditoria." + Auditoria.UNDELETED_RESTICTION);
        }
        
        if (requiereTarea(dto)) {
            hql.append(" and tno.asunto.id = asu.id");
        }
        if (requiereRegistro(dto)) {
            hql.append(" and reg.tipoEntidadInformacion = :ddTipoAsunto");
            hql.append(" and reg.idEntidadInformacion = asu.id");
            params.put("ddTipoAsunto", DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
            if (requiereInfoRegistro(dto)) {
                hql.append(" and iReg.registro.id = reg.id");
            }
        }

        // PERMISOS DEL USUARIO (en caso de que sea externo)
        if (usuarioLogado.getUsuarioExterno()) {
            hql.append(" and (" + filtroGestorSupervisorAsuntoMonoGestor(usuarioLogado, params) + " or " + filtroGestorSupervisorAsuntoMultiGestor(usuarioLogado, params) + " or "
                    + filtroGestorSupervisorAsuntoMultiGestorVariasEntidades(usuarioLogado, params) + ")");

        }
        // ASUNTO
        if (dto.getCodigoAsunto() != null && !"".equals(dto.getCodigoAsunto().toString())) {
            hql.append(" and asu.id = :asuCod");
            params.put("asuCod", Long.parseLong(dto.getCodigoAsunto().toString()));
        }
        // NOMBRE
        if (dto.getNombre() != null && !"".equals(dto.getNombre())) {
            hql.append(" and lower(asu.nombre) like '%'|| :asuName ||'%'");
            params.put("asuName", dto.getNombre().toLowerCase());
        }
        // DESPACHO
        if (dto.getComboDespachos() != null && !"".equals(dto.getComboDespachos())) {
            hql.append(" and asu.id in (" + getIdsAsuntosDelDespacho(Long.parseLong(dto.getComboDespachos().toString()), params) + ")");
        }
        // GESTOR
        if (dto.getComboGestor() != null && !"".equals(dto.getComboGestor())) {
            hql.append(" and asu.id in (" + getIdsAsuntosParaGestor(dto.getComboGestor(), dto.getComboTiposGestor()) + ")");
        }

        // ESTADO ASUNTO
        if (dto.getComboEstados() != null && !"".equals(dto.getComboEstados())) {
            hql.append(" and asu.estadoAsunto.codigo = :estadoAsu");
            params.put("estadoAsu", dto.getComboEstados());
        }
        // ESTADO ITINERARIO ASUNTO
        if (dto.getEstadoItinerario() != null && !"".equals(dto.getEstadoItinerario())) {
            hql.append(" and asu.estadoItinerario.codigo = :estadoIti");
            params.put("estadoIti", dto.getEstadoItinerario());
        }
        // COMITE ASUNTO
        if (dto.getIdComite() != null && !"".equals(dto.getIdComite().toString())) {
            hql.append(" and (( asu.comite.id = :comiteId");
            params.put("comiteId", Long.parseLong(dto.getIdComite().toString()));
            hql.append(" and asu.estadoItinerario.id = estIti.id and estIti.codigo = :estadoDC");
            hql.append(" and asu.estadoAsunto.codigo = :estadoAsuntoPropuesto )");
            params.put("estadoDC", DDEstadoItinerario.ESTADO_DECISION_COMIT);
            params.put("estadoAsuntoPropuesto", DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO);
            Comite comite = comiteDao.get(dto.getIdComite());
            hql.append(" or (asu.decisionComite.id = dco.id and dco.sesion.id = :ultimaSesionComiteId))");
            params.put("ultimaSesionComiteId", Long.parseLong(comite.getUltimaSesion().getId().toString()));
        }
        if (dto.getIdSesionComite() != null && !"".equals(dto.getIdSesionComite().toString())) {
            hql.append(" and asu.decisionComite.id = dco.id and dco.sesion.id = :sesionComiteId");
            params.put("sesionComiteId", Long.parseLong(dto.getIdSesionComite().toString()));
        }

        // ESTADO ANALISIS
        // TODO VER CON FO: artf429805
        /*
         * if (dto.getEstadoAnalisis()!=null){ hql.append(" and ");
         * StringTokenizer tokensEstados = new
         * StringTokenizer(dto.getEstadoAnalisis(), ","); hql.append("("); while
         * (tokensEstados.hasMoreElements()){
         * hql.append(" as.gestor.gestorDespacho.id = '"
         * +tokensEstados.nextToken()+"'"); if
         * (tokensEstados.hasMoreElements()){ hql.append(" or "); } }
         * hql.append(")"); }
         */

        // CODIGO CONTRATO
        if (dto.getFiltroContrato() != null && dto.getFiltroContrato() > 0L) {
            hql.append(" and cnt.nroContrato like '%'|| :filtroCnt ||'%'");
            params.put("filtroCnt", dto.getFiltroContrato());
        }
        // FECHA DESDE
        if (dto.getFechaCreacionDesde() != null && !"".equals(dto.getFechaCreacionDesde())) {
            hql.append(" and asu.auditoria.fechaCrear >= :fechaCrearDesde");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            try {
                params.put("fechaCrearDesde", sdf1.parse(dto.getFechaCreacionDesde()));
            } catch (ParseException e) {
                logger.error("Error parseando la fecha desde", e);
            }
        }
        // FECHA HASTA
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

        //USUARIO_ORIGEN_TAREA
        if (StringUtils.hasText(dto.getUsuarioOrigenTarea())) {
            hql.append(" and tno.emisor = :usuarioEmisor");
            params.put("usuarioEmisor", dto.getUsuarioOrigenTarea());
        }
        
        //NUMERO_LITIGIO
//        if (StringUtils.hasText(dto.getCodigoNumeroLitigio())) {
//            hql.append(" and iac.value like '%'|| :numeroLitigio ||'%' ");
//            hql.append(" and iac.tipoInfoContrato.id = '32'");
//            params.put("numeroLitigio", dto.getCodigoNumeroLitigio());
//        }

        //USUARIO_DESTINATARIO_TAREA
        if (StringUtils.hasText(dto.getUsuarioDestinoTarea())) {
            hql.append(" and tno.destinatarioTarea.username = :usuarioDestinatario");
            params.put("usuarioDestinatario", dto.getUsuarioDestinoTarea());
        }

        //SE HA ENVIADO AL MENOS UN MAIL
        if (!Checks.esNulo(dto.getSoloAsuntosEnvioCorreo()) && dto.getSoloAsuntosEnvioCorreo() == true) {
            hql.append(" and reg.tipo.codigo = :registro_tipo_email");
            params.put("registro_tipo_email", MEJDDTipoRegistro.CODIGO_ENVIO_EMAILS);

            //Destinatarios de mail
            if (StringUtils.hasText(dto.getDestinatarioEmail())) {
                hql.append(" and iReg.clave = :info_registro_clave_destinatario_mail");
                hql.append(" and lower(iReg.valorCorto) = :destinatario_email");
                params.put("info_registro_clave_destinatario_mail", MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_DESTINO);
                params.put("destinatario_email", dto.getDestinatarioEmail().toLowerCase());
            }
        }

        //FILTRO DE TIPO ANOTACION
        if (StringUtils.hasText(dto.getTipoAnotacion())) {
            hql.append(" and (");
            hql.append(" (");
            hql.append(" reg.tipo.codigo = :registro_tipo_tarea ");
            hql.append(" and iReg.clave = :info_registro_clave_tarea_tipoAnotacion");
            hql.append(" ) or (");
            hql.append(" reg.tipo.codigo = :registro_tipo_notificacion ");
            hql.append(" and iReg.clave = :info_registro_clave_notificacion_tipoAnotacion");
            hql.append(" ) or (");
            hql.append(" reg.tipo.codigo = :registro_tipo_comentario ");
            hql.append(" and iReg.clave = :info_registro_clave_comentario_tipoAnotacion");
            hql.append(" )");
            hql.append(" )");

            hql.append(" and lower(iReg.valorCorto) = :tipoAnotacion");

            params.put("registro_tipo_tarea", AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA);
            params.put("info_registro_clave_tarea_tipoAnotacion", AgendaMultifuncionTipoEventoRegistro.EventoTarea.TIPO_ANOTACION);

            params.put("registro_tipo_notificacion", AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_NOTIFICACION);
            params.put("info_registro_clave_notificacion_tipoAnotacion", AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.TIPO_ANOTACION);

            params.put("registro_tipo_comentario", AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_COMENTARIO);
            params.put("info_registro_clave_comentario_tipoAnotacion", AgendaMultifuncionTipoEventoRegistro.EventoComentario.TIPO_ANOTACION);

            params.put("tipoAnotacion", dto.getTipoAnotacion().toLowerCase());

        }

        // FILTRO DE ZONAS
        if (dto.getJerarquia() != null && dto.getJerarquia().length() > 0) {
            hql.append(" and cnt.zona.nivel.id >= :nivelId");
            params.put("nivelId", Long.parseLong(dto.getJerarquia().toString()));

            if (dto.getCodigoZonas().size() > 0) {
                hql.append(" and ( ");
                for (String codigoZ : dto.getCodigoZonas()) {
                    // si alguno de los contratos del asunto tiene alguna de
                    // las
                    // zonas....
                    hql.append(" cnt.zona.codigo like '" + codigoZ + "%' OR");
                }
                hql.delete(hql.length() - 2, hql.length());
                hql.append(" ) ");
            }
        }

        if (requiereProcedimiento(dto)) {

            // Codigo de procedimiento en juzgado
            if (dto.getCodigoProcedimientoEnJuzgado() != null && !dto.getCodigoProcedimientoEnJuzgado().equals("")) {
                hql.append(" and (");
                hql.append(" prc.codigoProcedimientoEnJuzgado like '%" + dto.getCodigoProcedimientoEnJuzgado() + "%' ");
                hql.append(" ) ");
            }
            // Tipos de procedimiento
            if (dto.getTiposProcedimiento() != null && dto.getTiposProcedimiento().size() > 0) {
                hql.append(" and (");
                boolean first = true;
                for (String cod : dto.getTiposProcedimiento()) {
                    if (first) {
                        first = false;
                    } else {
                        hql.append(" OR ");
                    }
                    hql.append(" prc.tipoProcedimiento.codigo like '" + cod + "' ");
                }
                hql.append(" ) ");
            }

        }
        hql.append(" group by asu.id  ");

        hql.append(")"); // El que cierra la subquery
        // MAX MINS

        if (requiereProcedimiento(dto) && requiereFiltrarPorSaldoTotal(dto)) {

            if (dto.getMaxSaldoTotalContratos() == null) {
                dto.setMaxSaldoTotalContratos((float) Integer.MAX_VALUE);
            }
            if (dto.getMinSaldoTotalContratos() == null) {
                dto.setMinSaldoTotalContratos(0f);
            }

            hql.append(" and a.id in ");
            hql.append(" ( ");
            hql.append(" select distinct a.id from Movimiento m, Asunto a ");
            hql.append(" where (m.contrato.id, a.id) in ");
            hql.append(" ( ");
            hql.append(" select distinct d.id, a.id ");
            hql.append(" from Asunto a, Procedimiento p, ProcedimientoContratoExpediente x, ExpedienteContrato c, Contrato d, DDEstadoProcedimiento esp ");
            hql.append(" where a.id = p.asunto.id and p.auditoria.borrado = 0  ");
            hql.append(" and p.id = x.procedimiento and x.expedienteContrato = c.id");
            hql.append(" and c.contrato.id = d.id ");
            hql.append(" and p.estadoProcedimiento.id = esp.id");
            hql.append(" and  ( ");
            hql.append(" esp.codigo = '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO + "' or");
            hql.append(" esp.codigo = '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO + "' or");
            hql.append(" esp.codigo = '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO + "'");
            hql.append(" )");
            hql.append(" ) ");
            hql.append(" and m.fechaExtraccion =  ");
            hql.append(" ( ");
            hql.append(" select max(m2.fechaExtraccion) from Movimiento m2 where m2.contrato.id = m.contrato.id  ");
            hql.append(" ) ");
            hql.append(" group by a.id ");
            hql.append(" having (");
            hql.append(" sum(m.posVivaVencida + m.posVivaNoVencida) between :minSaldoTotalCnt and :maxSaldoTotalCnt ");
            hql.append(" ) ");
            hql.append(" ) ");

            params.put("minSaldoTotalCnt", dto.getMinSaldoTotalContratos());
            params.put("maxSaldoTotalCnt", dto.getMaxSaldoTotalContratos());

        }
        if (requiereProcedimiento(dto) && requiereFiltrarPorPadreNulo(dto)) {
            if (dto.getMaxImporteEstimado() == null) {
                dto.setMaxImporteEstimado((double) Integer.MAX_VALUE);
            }
            if (dto.getMinImporteEstimado() == null) {
                dto.setMinImporteEstimado(0d);
            }

            hql.append(" and a.id in ");
            hql.append("(");
            hql.append(" select distinct asu.id from Asunto asu, Procedimiento prc ");
            hql.append(" where asu.auditoria.borrado = 0 and prc.auditoria.borrado = 0 ");
            hql.append(" and asu.id = prc.asunto.id ");
            hql.append(" and prc.procedimientoPadre is null ");
            hql.append(" group by asu.id having ( ");
            hql.append(" sum( abs(prc.saldoRecuperacion)) between :minImporteEst and :maxImporteEst )");

            hql.append(")");

            params.put("minImporteEst", new BigDecimal(dto.getMinImporteEstimado()));
            params.put("maxImporteEst", new BigDecimal(dto.getMaxImporteEstimado()));

        }

        if (DtoBusquedaAsunto.SALIDA_XLS.equals(dto.getTipoSalida())) {
            dto.setLimit(Integer.MAX_VALUE);
        }
        return paginationManager.getHibernatePage(getHibernateTemplate(), hql.toString(), dto, params);
    }

    private boolean requiereRegistro(RecoveryAgendaMultifuncionDtoBusquedaAsunto dto) {
        return (dto.getSoloAsuntosEnvioCorreo() != null && dto.getSoloAsuntosEnvioCorreo()) || requiereInfoRegistro(dto);
    }

    private boolean requiereInfoRegistro(RecoveryAgendaMultifuncionDtoBusquedaAsunto dto) {
        return StringUtils.hasText(dto.getDestinatarioEmail()) || StringUtils.hasText(dto.getTipoAnotacion());
    }

    private boolean requiereTarea(RecoveryAgendaMultifuncionDtoBusquedaAsunto dto) {
        return StringUtils.hasText(dto.getUsuarioDestinoTarea()) || StringUtils.hasText(dto.getUsuarioOrigenTarea());
    }

    private boolean requiereFiltrarPorPadreNulo(DtoBusquedaAsunto dto) {

        return dto.getMaxImporteEstimado() != null || dto.getMinImporteEstimado() != null;
    }

    private boolean requiereFiltrarPorSaldoTotal(DtoBusquedaAsunto dto) {

        return dto.getMaxSaldoTotalContratos() != null || dto.getMinSaldoTotalContratos() != null;
    }

    private boolean requiereProcedimiento(DtoBusquedaAsunto dto) {
        return dto.getMaxImporteEstimado() != null || dto.getMinImporteEstimado() != null || dto.getMaxSaldoTotalContratos() != null || dto.getMinSaldoTotalContratos() != null
                || (dto.getCodigoProcedimientoEnJuzgado() != null && !dto.getCodigoProcedimientoEnJuzgado().equals(""))
                || (dto.getTiposProcedimiento() != null && dto.getTiposProcedimiento().size() > 0);
    }

    private boolean requiereContrato(DtoBusquedaAsunto dto) {
        return (dto.getCodigoZonas().size() > 0 || (dto.getFiltroContrato() != null && dto.getFiltroContrato() > 0L)
        		);
    }
    
    private boolean requiereIACInfoAddContrato(RecoveryAgendaMultifuncionDtoBusquedaAsunto dto) {
//    	return !Checks.esNulo(dto.getCodigoNumeroLitigio());
    	return false;
    }

    private String filtroGestorSupervisorAsuntoMonoGestor(Usuario usuarioLogado, HashMap<String, Object> params) {
        StringBuilder hql = new StringBuilder();
        hql.append(" (asu.id in (");
        hql.append("select a.id from Asunto a ");
        hql.append("where (a.gestor.usuario.id = :usuarioLogado) or (a.supervisor.usuario.id = :usuarioLogado)");
        hql.append("))");
        params.put("usuarioLogado", usuarioLogado.getId());
        return hql.toString();
    }

    private String filtroGestorSupervisorAsuntoMultiGestor(Usuario usuarioLogado, HashMap<String, Object> params) {
        StringBuilder hql = new StringBuilder();
        hql.append(" (asu.id in (");
        hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
        hql.append("where gaa.gestor.usuario.id = :usuarioLogado");
        hql.append("))");
        params.put("usuarioLogado", usuarioLogado.getId());
        return hql.toString();
    }

    private String filtroGestorSupervisorAsuntoMultiGestorVariasEntidades(Usuario usuarioLogado, HashMap<String, Object> params) {
        StringBuilder hql = new StringBuilder();
        hql.append(" (asu.id in (");
        hql.append("select ge.unidadGestionId from EXTGestorEntidad ge");
        hql.append(" where ge.tipoEntidad.codigo = " + DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
        hql.append(" and ge.gestor.id = :usuarioLogado");
        hql.append("))");
        params.put("usuarioLogado", usuarioLogado.getId());
        return hql.toString();
    }

    private String getIdsAsuntosDelDespacho(Long idDespacho, HashMap<String, Object> params) {
        params.put("despExtId", idDespacho);
        return "select asu.id from EXTGestorAdicionalAsunto gaa join gaa.asunto asu " + "where gaa.gestor.despachoExterno.id = :despExtId";
    }

    private String getIdsAsuntosParaGestor(String comboGestor, String comboTiposGestor) {
        if (Checks.esNulo(comboTiposGestor) && Checks.esNulo(comboGestor)) {
            throw new IllegalArgumentException("comboGestor y comboTiposGestor est�n vac�os.");
        }
        StringBuilder subhql = new StringBuilder("select asu.id from EXTGestorAdicionalAsunto gaa join gaa.asunto asu where ");
        String and = "";
        if (!Checks.esNulo(comboTiposGestor)) {
            subhql.append("gaa.tipoGestor.codigo = '" + comboTiposGestor + "'");
            and = " and ";
        }
        if (!Checks.esNulo(comboGestor)) {
            subhql.append(and + "gaa.gestor.usuario.id in (select usu.id from GestorDespacho gd join gd.usuario usu where gd.id in (");
            StringTokenizer tokensGestores = new StringTokenizer(comboGestor, ",");
            while (tokensGestores.hasMoreElements()) {
                subhql.append(tokensGestores.nextToken());
                if (tokensGestores.hasMoreElements()) {
                    subhql.append(",");
                }
            }
            subhql.append("))");
        }
        return subhql.toString();
    }

}
