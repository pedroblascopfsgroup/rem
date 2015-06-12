package es.pfsgroup.plugin.recovery.procuradores.tareas.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.hibernate.SQLQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.PluginCoreextensionConstantes;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.dao.EXTTareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.procuradores.tareas.dao.PCDProcuradoresDao;
import es.pfsgroup.plugin.recovery.procuradores.tareas.dto.PCDProcuradoresDto;
import es.pfsgroup.plugin.recovery.procuradores.tareas.model.PCDProcuradores;
import es.pfsgroup.recovery.ext.factory.dao.HQLBuilderReutilizable;
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;


@Repository("PCDProcuradoresDao")
public class PCDProcuradoresDaoImpl extends AbstractEntityDao<PCDProcuradores, Long> implements PCDProcuradoresDao{

	@Autowired
	private EXTTareaNotificacionDao extTareaNotificacionDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private VTARBusquedaOptimizadaTareasDao vtarBusquedaOptimizadaTareasDao;
	
	@Override
	public Page getListadoTareasPendientesValidar(PCDProcuradoresDto dto){	
		
		HQLBuilder hb = new HQLBuilder(" from PCDProcuradores ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "asunto", dto.getAsunto(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "nombreTarea", dto.getTareaTarea(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idcategoria", dto.getIdCategoria());
		if(!Checks.esNulo(dto.getIdCategoria())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idcategorizacion", dto.getIdCategorizacion());
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "usuarioPendiente", dto.getUsuarioLogado().getId());
		List<String> vals = new ArrayList<String>();
		vals.add("'PRC'");
		vals.add("'PTV'");
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "estadoProcesoCodigo", vals);
		//hb.orderBy("fechaVencimiento", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);	
	}
	
	
	@Override
	public Page getListadoTareasPendientesValidarPausadas(PCDProcuradoresDto dto){	
		
		HQLBuilder hb = new HQLBuilder(" from PCDProcuradores ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "asunto", dto.getAsunto(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "nombreTarea", dto.getTareaTarea(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idcategoria", dto.getIdCategoria());
		if(!Checks.esNulo(dto.getIdCategoria())){
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idcategorizacion", dto.getIdCategorizacion());
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "usuarioPendiente", dto.getUsuarioLogado().getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "estadoProcesoCodigo", "PAU");

		//hb.orderBy("fechaVencimiento", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);	
	}

	@Override
	public Long getCountListadoTareasPendientesValidar(Long idUsuario) {
		
		/*
		 * select count(distinct id, usuarioPendiente) from PCDProcuradores;
		 */
		//HQLBuilder hb = new HQLBuilder(" select count(distinct pcd.id, pcd.usuarioPendiente) from PCDProcuradores pcd ");
		//HQLBuilder hb = new HQLBuilder(" from PCDProcuradores ");
		//HQLBuilder.addFiltroIgualQue(hb, "pcd.usuarioPendiente", idUsuario);
		
		//return (long) HibernateQueryUtils.list(this, hb).size();
		//HibernateQueryUtils.uniqueResult(this, hb);
		
		StringBuffer sql = new StringBuffer();
		sql.append("select count(*) from (select distinct tar_id, usu_pendientes from vtar_tarea_vs_procuradores ) vtar ");
		sql.append(" where vtar.usu_pendientes = " + idUsuario);

		String query = sql.toString();
		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory().getCurrentSession().createSQLQuery(sql.toString());
		
		return ((BigDecimal) sqlQuery.uniqueResult()).longValue();


	}
	
//	@Override
//	public Page buscarTareasPendientes(DtoBuscarTareaNotificacion dto, String comboEstado, Long comboCtgResol, Long idCategorizacion){
//		
//		HQLBuilder hb = new HQLBuilder(" from PCDProcuradores ");
//		
//		parseaOperadores(dto);
//		armaFiltroBusqueda(dto, hb);
//		
//        HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idcategoria", comboCtgResol);
//        HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idcategorizacion", idCategorizacion);
//        HQLBuilder.addFiltroIgualQueSiNotNull(hb, "usuarioPendiente", dto.getUsuarioLogado().getId());
//		List<String> vals = new ArrayList<String>();
//		vals.add("'PRC'");
//		vals.add("'PTV'");
//		HQLBuilder.addFiltroWhereInSiNotNull(hb, "estadoProcesoCodigo", vals);
//        
//		//Aquí hay que añadir la categoría filtrada
//		
//		return HibernateQueryUtils.page(this,  hb, dto);
//
//	}
	
	
	@Override
	public Page buscarTareasPendientes(DtoBuscarTareaNotificacion dto, String comboEstado, Long comboCtgResol, Long idCategorizacion, Usuario usuarioLogado, Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass){
		
		parseaOperadores(dto);
		
		HQLBuilderReutilizable reuthql = vtarBusquedaOptimizadaTareasDao.createHQLBbuscarTareasPendiente(dto, usuarioLogado, modelClass);
		HQLBuilder hb = reuthql.getHqlBuilder();
		hb.changeFrom("VTARTareaVsUsuario", "PCDProcuradores");
		
        HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idcategoria", comboCtgResol);
        HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idcategorizacion", idCategorizacion);
        HQLBuilder.addFiltroIgualQueSiNotNull(hb, "usuarioPendiente", dto.getUsuarioLogado().getId());
		List<String> vals = new ArrayList<String>();
		vals.add("'PRC'");
		vals.add("'PTV'");
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "estadoProcesoCodigo", vals);
		
		return reuthql.getQueryCallback().getPage(this, hb, dto);

	}
	
	private void parseaOperadores(final DtoBuscarTareaNotificacion dto)
	{
		if (dto.getFechaVencDesdeOperador() != null) {
            if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencDesdeOperador(">=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("<=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("=");
            }
        }
        if (dto.getFechaVencimientoHastaOperador() != null) {
            if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador(">=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("<=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("=");
            }
        }
	}
	
	
	
    private void armaFiltroBusqueda(final DtoBuscarTareaNotificacion dto, final HQLBuilder hb) {

        // Filtro por fecha de vencimiento
        if ((!Checks.esNulo(dto.getFechaVencimientoDesde())) || (!Checks.esNulo(dto.getFechaVencimientoHasta()))) {
            Date fechaDesde = parseaFecha(dto.getFechaVencimientoDesde(), "dd/MM/yyyy");
            Calendar fechaDesdeParse = Calendar.getInstance();
            if (fechaDesde != null) {
                fechaDesdeParse.setTime(fechaDesde);
                if (dto.getFechaVencDesdeOperador().equals(">")) {
                    fechaDesdeParse.add(Calendar.DAY_OF_MONTH, 1);
                }
            }

            Date fechaHasta = parseaFecha(dto.getFechaVencimientoHasta(), "dd/MM/yyyy");
            Calendar fechaHastaParsed = Calendar.getInstance();
            if (fechaHasta != null) {
                fechaHastaParsed.setTime(fechaHasta);
                if (dto.getFechaVencimientoHastaOperador().equals("<")) {
                    fechaHastaParsed.add(Calendar.DAY_OF_MONTH, -1);
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                } else if (dto.getFechaVencimientoHastaOperador().equals("<=")) {
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                }
            }

            if ((fechaDesdeParse != null) && (fechaHastaParsed != null) && fechaDesdeParse.getTime().equals(fechaHastaParsed.getTime()) && dto.getFechaVencDesdeOperador().equals("=")) {
                fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                fechaHastaParsed.add(Calendar.MINUTE, 59);
                fechaHastaParsed.add(Calendar.SECOND, 59);
            }

            Date fechaDesdeFinal;
            if (!Checks.esNulo(dto.getFechaVencimientoDesde())) {
                fechaDesdeFinal = fechaDesdeParse.getTime();
            } else {
                fechaDesdeFinal = null;
            }

            Date fechaHastaFinal;
            if (!Checks.esNulo(dto.getFechaVencimientoHasta())) {
                fechaHastaFinal = fechaHastaParsed.getTime();
            } else {
                if (dto.getFechaVencDesdeOperador().equals("=") && fechaDesdeParse != null) {
                    fechaHastaParsed = fechaDesdeParse;
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                    fechaHastaFinal = fechaHastaParsed.getTime();
                } else {
                    fechaHastaFinal = null;
                }
            }

            HQLBuilder.addFiltroBetweenSiNotNull(hb, "fechaVenc", fechaDesdeFinal, fechaHastaFinal);

        }

        // Filtro por fecha de inicio
        if ((!Checks.esNulo(dto.getFechaInicioDesde())) || (!Checks.esNulo(dto.getFechaInicioHasta()))) {
            Date fechaDesde = parseaFecha(dto.getFechaInicioDesde(), "dd/MM/yyyy");
            Date fechaHasta = parseaFecha(dto.getFechaInicioHasta(), "dd/MM/yyyy");
            HQLBuilder.addFiltroBetweenSiNotNull(hb, "fechaInicio", fechaDesde, fechaHasta);
        }

        // Descripcion Entidad Informacion
        HQLBuilder.addFiltroLikeSiNotNull(hb, "descripcionTarea", dto.getDescripcionTarea(), true);

        // Nombre Tarea (TareaNotificacion.getDescripcionTarea)
        HQLBuilder.addFiltroLikeSiNotNull(hb, "nombreTarea", dto.getNombreTarea(), true);
        

    }
    
    private Date parseaFecha(final String fecha, final String formato) {
        final SimpleDateFormat sdf = new SimpleDateFormat(formato);
        try {
            return sdf.parse(fecha);
        } catch (ParseException e) {
            logger.error("No se ha podido parsear la fecha '" + fecha + "' al formato '" + formato + "'");
            return null;
        }
    }
    
    
}
