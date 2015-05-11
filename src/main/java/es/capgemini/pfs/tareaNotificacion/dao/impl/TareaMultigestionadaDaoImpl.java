package es.capgemini.pfs.tareaNotificacion.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.dao.TareaMultigestionadaDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;

@Repository
public class TareaMultigestionadaDaoImpl extends
		AbstractEntityDao<EXTTareaNotificacion, Long> implements
		TareaMultigestionadaDao {
	
	@Resource
    private PaginationManager paginationManager;

	@Override
	public Page buscarTareasPendienteMultigestor(DtoBuscarTareaNotificacion dto) {
		Page page = null;

		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			String hql = construyeQueryTareasPendientes(dto, params);
			if (dto.isBusqueda()) {
				hql += " AND tar in ( ";
				hql += armarFiltroBusquedaTareas(dto, params) + " ) ";
			}
			page = paginationManager.getHibernatePage(getHibernateTemplate(),
					hql, dto, params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return page;
	}

	private String construyeQueryTareasPendientes(
			DtoBuscarTareaNotificacion dto, HashMap<String, Object> params) {
		List<String> listadoZonas = getListadoZonas(dto);
		String listadoPerfiles = getListadoPerfiles(dto);

		StringBuilder sb = new StringBuilder();
		sb.append(" select tar from EXTTareaNotificacion tar where ( ");
		sb.append(" tar in ( ").append(
				construyeQueryTareasPendienteAsuntos(dto, listadoPerfiles,
						params)).append(" ) ");
		sb.append(" ) ");
		//Filtros repetidos en todas las subconsultas
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

	private String construyeQueryTareasPendienteAsuntos(
			DtoBuscarTareaNotificacion dto, String listadoPerfiles,
			HashMap<String, Object> params) {
		StringBuffer hql = new StringBuffer();
        hql.append("select tn ");
        hql.append("from EXTTareaNotificacion tn ");
        hql.append("left join  tn.asunto asu ");
        hql.append("where tn.auditoria.borrado = 0 ");

        hql.append(" and (tn.tareaFinalizada is null or tn.tareaFinalizada= 0) ");
        hql.append(" and tn.tipoEntidad.codigo in (").append(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO).append(",").append(
                DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO).append(") ");

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

        //Filtros de perfil
        hql.append(" and (tn.subtipoTarea.gestor is null)"); //Devuelve sólo las tareas multi-gestor
        hql.append(" and (tn.subtipoTarea.tipoGestor is not null)");
        hql.append(" and (asu in (");
        hql.append("select a from EXTGestorAdicionalAsunto gaa join gaa.asunto a ");
        hql.append("where (gaa.tipoGestor.id = tn.subtipoTarea.tipoGestor.id) and (gaa.gestor.usuario.id = :usuarioLogado)");
        hql.append("))");
        params.put("usuarioLogado", dto.getUsuarioLogado().getId());
        

        return hql.toString();
	}
	
	/**
     * Arma el sql para la busqueda de tareas.
     * @param dto DtoBuscarTareaNotificacion
     * @param params Hashmap
     * @return query
     */
    private StringBuffer armarFiltroBusquedaTareas(DtoBuscarTareaNotificacion dto, HashMap<String, Object> params) {
        StringBuffer hql = new StringBuffer();
        hql.append("select tn ");
        hql.append("from EXTTareaNotificacion tn where 1=1 ");
        //Fecha Vto Desde

        if (!Checks.esNulo(dto.getFechaVencimientoDesde()) && !Checks.esNulo(dto.getFechaVencDesdeOperador())) {
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

        //Fecha Vto. Hasta
        if (!Checks.esNulo(dto.getFechaVencimientoHasta()) && !Checks.esNulo(dto.getFechaVencimientoHastaOperador())) {
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

        //Fecha Inicio Desde

        if (!Checks.esNulo(dto.getFechaInicioDesde()) && !Checks.esNulo(dto.getFechaInicioDesdeOperador())) {
            //Parsing fecha
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            Date fecha = null;
            try {
                fecha = sdf1.parse(dto.getFechaInicioDesde());
            } catch (ParseException e) {
                logger.error("Error parseando la fecha");
            }
            hql.append(" and trunc (tn.fechaInicio) " + dto.getFechaInicioDesdeOperador() + " trunc (:fechaInicioDesde) ");
            params.put("fechaInicioDesde", fecha);

        }

        //Fecha Inicio Hasta
        if (!Checks.esNulo(dto.getFechaInicioHasta()) && !Checks.esNulo(dto.getFechaInicioHastaOperador())) {
            //Parsing fecha
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            Date fecha = null;
            try {
                fecha = sdf1.parse(dto.getFechaInicioHasta());
            } catch (ParseException e) {
                logger.error("Error parseando la fecha");
            }
            hql.append(" and trunc (tn.fechaInicio) " + dto.getFechaInicioHastaOperador() + " trunc (:fechaInicioHasta) ");
            params.put("fechaInicioHasta", fecha);

        }
        //Descripcion Entidad Informacion
        if (dto.getDescripcionTarea() != null && !"".equals(dto.getDescripcionTarea())) {
            String sql = " and (";

            //Asunto
            sql += " tn in (select tn from EXTTareaNotificacion where (tn.tipoEntidad.codigo like " + DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO
                    + " and upper(tn.asunto.nombre) like upper('%" + dto.getDescripcionTarea() + "%'))) ";
            //Procedimiento
            sql += " or tn in (select tn from EXTTareaNotificacion where (tn.tipoEntidad.codigo like " + DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
                    + " and upper(tn.procedimiento.asunto.nombre||tn.procedimiento.tipoProcedimiento.descripcion) like upper('%"
                    + dto.getDescripcionTarea() + "%'))) ";
            //Cliente
            sql += " or tn in (select tn from EXTTareaNotificacion where (tn.tipoEntidad.codigo like " + DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE
                    + " and upper(tn.cliente.persona.apellido1||tn.cliente.persona.apellido2||tn.cliente.persona.nombre) like upper('%"
                    + dto.getDescripcionTarea() + "%'))) ";

            //Expediente
            sql += " or tn in (select tn from EXTTareaNotificacion where (tn.tipoEntidad.codigo like " + DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
                    + " and upper(tn.expediente.descripcionExpediente) like upper('%" + dto.getDescripcionTarea() + "%'))) ";
            sql += ")";
            hql.append(sql);
        }
        //Nombre Tarea (TareaNotificacion.getDescripcionTarea)
        if (dto.getNombreTarea() != null && !"".equals(dto.getNombreTarea())) {
            hql.append(" and upper (tn.descripcionTarea) like '%" + dto.getNombreTarea().toUpperCase() + "%' ");
        }

        //Tipo Solicitud
        //Gestor
        //Supervisor
        //Emisor
        //Volumen total de riesgos de la entidad -- OJO!!!
        //Volumen total de riesgos VENCIDOS de la entidad -- OJO!!!

        return hql;
    }

	private String getListadoPerfiles(DtoBuscarTareaNotificacion dto) {
		HashMap<Long, Long> controlPerfiles = new HashMap<Long, Long>();

		for (Perfil p : dto.getPerfiles()) {
			Long idPerfil = p.getId();
			if (!controlPerfiles.containsKey(idPerfil))
				controlPerfiles.put(idPerfil, idPerfil);
		}

		String listado = controlPerfiles.keySet().toString();
		listado = listado.substring(1, listado.length() - 1);
		return listado;
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

}
