package es.pfsgroup.recovery.panelcontrol.judicial.tareas.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.panelcontrol.judicial.manager.DtoBuscarTareasPanelControl;
import es.pfsgroup.recovery.panelcontrol.judicial.tareas.dao.PanelControlTareasPendientesDao;

@Repository
public class PanelControlTareasPendientesDaoImpl extends AbstractEntityDao<TareaNotificacion, Long> implements
		PanelControlTareasPendientesDao {

	@Resource
	private PaginationManager paginationManager;
	
	@Override
	public Page getListaTareasPendientesVencidas(DtoBuscarTareaNotificacion dto) {
		Date fechaActual = new Date();
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        dto.setFechaVencimientoHasta(sdf1.format(fechaActual));
        dto.setFechaVencimientoHastaOperador("<");
        dto.setEnEspera(false);
        dto.setEsAlerta(false);
        dto.setBusqueda(true);
        HashMap<String,Object> params = new  HashMap<String, Object>();
        String hql = construyeQueryTareasPendientes(dto, params);
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql, dto,params);
	}
	@Override
	public Page getListaTareasPendientesHoy(
			DtoBuscarTareaNotificacion dto) {
		Date fechaActual = new Date();
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        dto.setFechaVencimientoHasta(sdf1.format(fechaActual));
        dto.setFechaVencimientoHastaOperador("=");
        HashMap<String,Object> params = new  HashMap<String, Object>();
		String hql = construyeQueryTareasPendientes(dto,params);
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql, dto,params);
	}

	@Override
	public Page getListaTareasPendientesMes(
			DtoBuscarTareaNotificacion dto) {
		 SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
	        Date fechaActual = new Date();
	        dto.setFechaVencimientoDesde(sdf1.format(fechaActual));
	        dto.setFechaVencDesdeOperador(">=");
	        
	       	Calendar calendar = Calendar.getInstance();
	       	calendar.add(Calendar.DATE, 30);
	       	Date fechaSemana = calendar.getTime();
	        
	        dto.setFechaVencimientoHasta(sdf1.format(fechaSemana));
	        dto.setFechaVencimientoHastaOperador("<=");
	        
	        dto.setEnEspera(false);
	        dto.setEsAlerta(false);
	        dto.setBusqueda(true);
        HashMap<String,Object> params = new  HashMap<String, Object>();
		String hql = construyeQueryTareasPendientes(dto,params);
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql, dto,params);
	}

	@Override
	public Page getListaTareasPendientesSemana(
			DtoBuscarTareaNotificacion dto) {
		 SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
	        Date fechaActual = new Date();
	        
	        dto.setFechaVencimientoDesde(sdf1.format(fechaActual));
	        dto.setFechaVencDesdeOperador(">=");
	       	Calendar calendar = Calendar.getInstance();
	       	calendar.add(Calendar.DATE, 7);
	       	Date fechaSemana = calendar.getTime();
	       	dto.setFechaVencimientoHasta(sdf1.format(fechaSemana));
	        dto.setFechaVencimientoHastaOperador("<=");
	        
	        dto.setEnEspera(false);
	        dto.setEsAlerta(false);
	        dto.setBusqueda(true);
        HashMap<String,Object> params = new  HashMap<String, Object>();
		String hql = construyeQueryTareasPendientes(dto,params);
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql, dto,params);
	}
	@Override
	public Long obtenerCantidadDeTareasPendientesVencidas(DtoBuscarTareaNotificacion dto) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        Date fechaActual = new Date();
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        dto.setFechaVencimientoHasta(sdf1.format(fechaActual));
        dto.setFechaVencimientoHastaOperador("<");
        dto.setEnEspera(false);
        dto.setEsAlerta(false);
        dto.setBusqueda(true);
        String hql = construyeQueryTareasPendientes(dto, params);
        hql = hql.replaceFirst("select tar ", "select count(tar) ");
        Query query = getSession().createQuery(hql);
        setParameters(query, params);
        Long total = (Long) query.uniqueResult();
        
        return total;
    }
	@Override
	public Long obtenerCantidadDeTareasPendientesHoy(DtoBuscarTareaNotificacion dto) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        
        Date fechaActual = new Date();
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        dto.setFechaVencimientoHasta(sdf1.format(fechaActual));
        dto.setFechaVencimientoHastaOperador("=");
        dto.setEnEspera(false);
        dto.setEsAlerta(false);
        dto.setBusqueda(true);
        String hql = construyeQueryTareasPendientes(dto, params);
        hql = hql.replaceFirst("select tar ", "select count(tar) ");
        Query query = getSession().createQuery(hql);
        setParameters(query, params);
        Long total = (Long) query.uniqueResult();

        return total;
    }
	@Override
	public Long obtenerCantidadDeTareasPendientesSemana(DtoBuscarTareaNotificacion dto) {
        HashMap<String, Object> params = new HashMap<String, Object>();
       
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        Date fechaActual = new Date();
        
        dto.setFechaVencimientoDesde(sdf1.format(fechaActual));
        dto.setFechaVencDesdeOperador(">=");
       	Calendar calendar = Calendar.getInstance();
       	calendar.add(Calendar.DATE, 7);
       	Date fechaSemana = calendar.getTime();
       	dto.setFechaVencimientoHasta(sdf1.format(fechaSemana));
        dto.setFechaVencimientoHastaOperador("<=");
        
        dto.setEnEspera(false);
        dto.setEsAlerta(false);
        dto.setBusqueda(true);
        String hql = construyeQueryTareasPendientes(dto, params);
        hql = hql.replaceFirst("select tar ", "select count(tar) ");
        Query query = getSession().createQuery(hql);
        setParameters(query, params);
        Long total = (Long) query.uniqueResult();

        return total;
    }
	@Override
	public Long obtenerCantidadDeTareasPendientesMes(DtoBuscarTareaNotificacion dto) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
        Date fechaActual = new Date();
        dto.setFechaVencimientoDesde(sdf1.format(fechaActual));
        dto.setFechaVencDesdeOperador(">=");
        
       	Calendar calendar = Calendar.getInstance();
       	calendar.add(Calendar.DATE, 30);
       	Date fechaSemana = calendar.getTime();
        
        dto.setFechaVencimientoHasta(sdf1.format(fechaSemana));
        dto.setFechaVencimientoHastaOperador("<=");
        
        dto.setEnEspera(false);
        dto.setEsAlerta(false);
        dto.setBusqueda(true);
        String hql = construyeQueryTareasPendientes(dto, params);
        hql = hql.replaceFirst("select tar ", "select count(tar) ");
        Query query = getSession().createQuery(hql);
        setParameters(query, params);
        Long total = (Long) query.uniqueResult();

        return total;
    }
	
	
	
	


	private String construyeQueryTareasPendientes(DtoBuscarTareaNotificacion dto, HashMap<String, Object> params) {

        List<String> listadoZonas = getListadoZonas(dto);

        StringBuilder sb = new StringBuilder();
        sb.append(" select tar from TareaNotificacion tar where ( ");

        sb.append(" tar in ( ").append(construyeQueryTareasPendientesCliente(dto, listadoZonas, null, params)).append(" ) ");
        sb.append(" or tar in ( ").append(construyeQueryTareasPendienteExpedientes(dto, listadoZonas, null, params)).append(" ) ");
        sb.append(" ) ");

        sb.append(" and (tar.tareaFinalizada is null or tar.tareaFinalizada= 0)");
        sb.append(" and tar.auditoria.borrado = 0 ");

        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
            sb.append(" and tar.subtipoTarea.tipoTarea.codigoTarea = :codigoTarea ");
            params.put("codigoTarea", dto.getCodigoTipoTarea());
        }

        if (dto.isEnEspera()) {
            sb.append(" and tar.espera = true ");
        }
        if (dto.isEsAlerta()) {
            sb.append(" and tar.alerta = true ");
        }
        

        return sb.toString();
    }
	

	
	 private String construyeQueryTareasPendientesCliente(DtoBuscarTareaNotificacion dto, List<String> listadoZonas, String listadoPerfiles,
	            HashMap<String, Object> params) {
	        StringBuilder hql = new StringBuilder();
	        hql.append("select tn ");
	        hql.append("from TareaNotificacion tn ");
	        hql.append("left join tn.cliente.estadoItinerario.estados est ");
	        hql.append("where tn.auditoria.borrado = 0 ");

	        hql.append(" and tn.cliente.estadoItinerario.codigo = tn.estadoItinerario.codigo ");
	        hql.append(" and tn.cliente.arquetipo.itinerario = est.itinerario ");
	        hql.append(" and (tn.tareaFinalizada is null or tn.tareaFinalizada= 0)");
	        hql.append(" and tn.tipoEntidad.id = " + DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
	        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
	            hql.append(" and tn.subtipoTarea.tipoTarea.codigoTarea = :codigoTarea ");
	            params.put("codigoTarea", dto.getCodigoTipoTarea());
	        }
	        if (dto.isEnEspera()) {
	            hql.append(" and tn.espera = true ");
	        }
	        if (dto.isEsAlerta()) {
	            hql.append(" and tn.alerta = true ");
	        }

	        hql.append(" and ( ");
	        for (String zonCodigo : listadoZonas) {
	            hql.append(" tn.cliente.oficina.zona.codigo like '").append(zonCodigo).append("%' OR");
	        }
	        hql.deleteCharAt(hql.length() - 1);
	        hql.deleteCharAt(hql.length() - 1);
	        hql.append(" ) ");
	     
	        //Fecha Vto. Hasta
	        if (dto.getFechaVencimientoHasta() != null ) {
	            //Parsing fecha
	            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
	            Date fecha = null;
	            try {
	                fecha = sdf1.parse(dto.getFechaVencimientoHasta());
	            } catch (ParseException e) {
	                logger.error("Error parseando la fecha");
	            }

	            hql.append(" and trunc (tn.fechaVenc) " + dto.getFechaVencimientoHastaOperador() + " trunc (:fechaVencHasta) ");
	            params.put("fechaVencHasta", fecha);

	        }
	        //Fecha Vto Desde

	        if (dto.getFechaVencimientoDesde() != null) {
	            //Parsing fecha
	            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
	            Date fecha = null;
	            try {
	                fecha = sdf1.parse(dto.getFechaVencimientoDesde());
	            } catch (ParseException e) {
	                logger.error("Error parseando la fecha");
	            }
	            hql.append(" and trunc (tn.fechaVenc) " + dto.getFechaVencDesdeOperador() + " trunc (:fechaVencDesde) ");
	            params.put("fechaVencDesde", fecha);

	        }
	        

	        return hql.toString();
	    }

	    /**
	     * arma la query de expedientes.
	     * @param dto dto
	     * @return query
	     */
	    private String construyeQueryTareasPendienteExpedientes(DtoBuscarTareaNotificacion dto, List<String> listadoZonas, String listadoPerfiles,
	            HashMap<String, Object> params) {
	        StringBuffer hql = new StringBuffer();
	        hql.append("select tn ");
	        hql.append("from TareaNotificacion tn ");
	        hql.append("left join  tn.expediente.estadoItinerario.estados est ");
	        hql.append("where tn.auditoria.borrado = 0 ");

	        hql.append(" and tn.expediente.estadoItinerario.codigo = tn.estadoItinerario.codigo ");
	        hql.append(" and tn.expediente.arquetipo.itinerario = est.itinerario ");
	        hql.append(" and (tn.tareaFinalizada is null or tn.tareaFinalizada= 0) ");
	        hql.append(" and tn.tipoEntidad.codigo = ").append(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE).append(" ");
	        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
	            hql.append(" and tn.subtipoTarea.tipoTarea.codigoTarea = :codigoTarea ");
	            params.put("codigoTarea", dto.getCodigoTipoTarea());
	        }
	        if (dto.isEnEspera()) {
	            hql.append(" and tn.espera = true ");
	        }
	        if (dto.isEsAlerta()) {
	            hql.append(" and tn.alerta = true ");
	        } else {
	            //No se debe mostrar la tarea de DC, se acceder� atraves del menu de comite.
	            hql.append(" and tn.subtipoTarea.codigoSubtarea != ").append(SubtipoTarea.CODIGO_DECISION_COMITE).append(" ");
	        }
	        hql.append(" and ( ");
	        for (String zonCodigo : listadoZonas) {
	            hql.append(" tn.expediente.oficina.zona.codigo like '").append(zonCodigo).append("%' OR");
	        }
	        hql.deleteCharAt(hql.length() - 1);
	        hql.deleteCharAt(hql.length() - 1);
	        hql.append(" ) ");

	        //Fecha Vto. Hasta
	        if (dto.getFechaVencimientoHasta() != null ) {
	            //Parsing fecha
	            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
	            Date fecha = null;
	            try {
	                fecha = sdf1.parse(dto.getFechaVencimientoHasta());
	            } catch (ParseException e) {
	                logger.error("Error parseando la fecha");
	            }

	            hql.append(" and trunc (tn.fechaVenc) " + dto.getFechaVencimientoHastaOperador() + " trunc (:fechaVencHasta) ");
	            params.put("fechaVencHasta", fecha);
	        }
	      //Fecha Vto Desde

	        if (dto.getFechaVencimientoDesde() != null ) {
	            //Parsing fecha
	            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
	            Date fecha = null;
	            try {
	                fecha = sdf1.parse(dto.getFechaVencimientoDesde());
	            } catch (ParseException e) {
	                logger.error("Error parseando la fecha");
	            }
	            hql.append(" and trunc (tn.fechaVenc) " + dto.getFechaVencDesdeOperador() + " trunc (:fechaVencDesde) ");
	            params.put("fechaVencDesde", fecha);

	        }
	        return hql.toString();
	    }
    
    private List<String> getListadoZonas(DtoBuscarTareaNotificacion dto) {
        List<String> listadoZonas = new ArrayList<String>();
        HashMap<String, String> controlZonas = new HashMap<String, String>();
        for (DDZona zona : dto.getZonas()) {
            String zonCodigo = zona.getCodigo();
            if (controlZonas.get(zonCodigo) == null) {
                listadoZonas.add(zonCodigo);
                controlZonas.put(zonCodigo, zonCodigo);
            }
        }
        return listadoZonas;
    }
    
    private void setParameters(Query query, HashMap<String, Object> params) {
        if (params == null) { return; }
        for (String key : params.keySet()) {
            Object param = params.get(key);
            query.setParameter(key, param);
        }
    }
    
    
	@SuppressWarnings("static-access")
	@Override
	public Page getListaTareasByCodigo(
			DtoBuscarTareasPanelControl dtoBuscarTarea) {
		HQLBuilder hb = new HQLBuilder("select distinct tar from PCExpedienteTarea tar");
		hb.addFiltroIgualQueSiNotNull(hb, "tipo", dtoBuscarTarea.getPanelTareas());
		
		return HibernateQueryUtils.page(this, hb, dtoBuscarTarea);
	}

	
	
}
