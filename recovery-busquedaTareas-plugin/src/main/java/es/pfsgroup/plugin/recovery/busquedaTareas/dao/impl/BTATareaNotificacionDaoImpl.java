package es.pfsgroup.plugin.recovery.busquedaTareas.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.users.domain.FuncionPerfil;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTAGestorDespachoDao;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTATareaNotificacionDao;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTAUsuarioDao;
import es.pfsgroup.plugin.recovery.busquedaTareas.dto.BTADtoBusquedaTareas;
import es.pfsgroup.plugin.recovery.busquedaTareas.model.BTATareaEncontrada;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;

/**
 * Implementaciï¿œn del dao de notificaciones para Hibenate.
 * 
 * @author pamuller
 * 
 */
@Repository("BTATareaNotificacionDao")
public class BTATareaNotificacionDaoImpl extends AbstractEntityDao<BTATareaEncontrada, Long> implements BTATareaNotificacionDao { 

    @Autowired
    private BTAUsuarioDao btaUsuarioDao;
    
    private final Log logger = LogFactory.getLog(getClass());
    
    @Autowired
    private BTAGestorDespachoDao btaGestorDespachoDao;
    
	@Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;
	



    /**
     * Genera un listado List de zonas segï¿œn el filtro recivido
     * 
     * @param cadena
     *            con ids zona separados por coma
     * @return lista de zonas
     */
    private List<String> getListadoZonasFiltro(String cadenaConIdZonas) {
        if (cadenaConIdZonas != null) {
            List<String> listadoZonas = new ArrayList<String>();
            StringTokenizer tokens = new StringTokenizer(cadenaConIdZonas, ",");
            while (tokens.hasMoreTokens()) {
                listadoZonas.add(tokens.nextToken());
            }
            return listadoZonas;
        }
        return null;
    }
    
	public Integer buscarTareasCount(BTADtoBusquedaTareas dto) {
        
		HQLBuilder hb = new HQLBuilder("select DISTINCT tar from BTATareaEncontrada tar"); 
		hb = construyeQuery(hb, dto);
		
		final Page page = HibernateQueryUtils.page(this, hb, dto);
	    return page.getTotalCount();
  }
    
	public Page buscarTareas(BTADtoBusquedaTareas dto) {
        
		HQLBuilder hb = new HQLBuilder("select DISTINCT tar from BTATareaEncontrada tar"); 
		hb = construyeQuery(hb, dto);
                 
        return HibernateQueryUtils.page(this, hb, dto);
    }
	
	private HQLBuilder construyeQuery(HQLBuilder hb, final BTADtoBusquedaTareas dto) {
		
		// Pestañas filtros básicos y fechas
		hb = buscarTareasFiltrosBasicos(hb, dto);
        hb = buscarTareasFechas(hb, dto);
        
        // Pestañas Grupo o Individual
        if (!Checks.esNulo(dto.getAmbitoTarea())){
        	if (dto.getAmbitoTarea().equals("1")) {
        		hb = buscarTareasGrupo(hb, dto);
        	} else {
        		hb = buscarTareasIndividual(dto);
        	}
        }
        
        // PERMISOS DEL USUARIO (en caso de que sea externo)
        if (!Checks.esNulo(dto.getUsuarioExterno())	&& dto.getUsuarioExterno()) {
        	
        	// Monogestor
        	//hb.appendWhere(" ((tar.tarea.asunto.gestor.usuario.id = " + dto.getUsuarioId() + ")");
        	//hb.appendWhere(" tar.tarea.asunto.supervisor.usuario.id = " + dto.getUsuarioId() + ") ");
                	
        	// Multigestor
        	//hb.appendWhere(" tar.asunto.id in (SELECT gaa.asunto.id FROM EXTGestorAdicionalAsunto gaa where gaa.gestor.usuario.id = " + dto.getUsuarioLogado().getId() + " )");
        	
        	List<Long> idGrpsUsuario = extGrupoUsuariosDao.buscaGruposUsuarioById(dto.getUsuarioId());
        	String multigestor = filtroGestorGrupo(idGrpsUsuario);
        	String condicion = "(tar.tarea.asunto.id in (select gaa.asunto.id from EXTGestorAdicionalAsunto gaa where gaa.gestor.usuario.id = "+ dto.getUsuarioId()+")) or "+multigestor;
        	
        	hb.appendWhere(condicion);
        	     	
        }

        // En espera y Alerta
        if (dto.isEnEspera()) {
        	HQLBuilder.addFiltroIgualQue(hb, "tar.tarea.espera", true);
        }
        if (dto.isEsAlerta()) {
        	HQLBuilder.addFiltroIgualQue(hb, "tar.tarea.alerta", true);
        } else if (!Checks.esNulo(dto.getUgGestion()) && dto.getUgGestion().equals("2")){
        	// Si la unidad de gestión es Expedientes no se debe mostrar la tarea de DC, se accederá a través del menú del comité
        	HQLBuilder.addFiltroIgualQue(hb, "tar.tarea.subtipoTarea.codigoSubtarea", SubtipoTarea.CODIGO_DECISION_COMITE);
        	
        }
   
        // Pestañas dinámicas
        hb.appendExtensibleDto(dto);
        
        return hb;
	}
    
	public HQLBuilder buscarTareasFiltrosBasicos(HQLBuilder hb, final BTADtoBusquedaTareas dto) {
    	
    	// Descripcion Entidad Informacion y Nombre Tarea
        if (dto.getDescripcionTarea() != null && !"".equals(dto.getDescripcionTarea())) {

            // Asunto
            String sql = " (tar.tarea.tipoEntidad.codigo like '" + DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO
                    + "' and upper (tar.asuDesc) like '%" + dto.getDescripcionTarea().toUpperCase() + "%') ";
            // Procedimiento
            sql += " or (tar.tarea.tipoEntidad.codigo like '" + DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
                    + "' and upper (tar.asuDesc||tar.tipoPrcDesc) like '%" + dto.getDescripcionTarea().toUpperCase() + "%') ";
            
            // Cliente
            sql += " or (tar.tarea.tipoEntidad.codigo like '" + DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE
                    + "' and upper (tar.nombreCliente) like '%" + dto.getDescripcionTarea().toUpperCase() + "%') ";
            
            // Expediente
            sql += " or (tar.tarea.tipoEntidad.codigo like '" + DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
                    + "' and upper (tar.tarea.expediente.descripcionExpediente) like '%" + dto.getDescripcionTarea().toUpperCase() + "%') ";

            hb.appendWhere(sql);
        }
        

        if (dto.getNombreTarea() != null && !"".equals(dto.getNombreTarea())) {
            hb.appendWhere(" upper (tar.tarea.descripcionTarea) like '%" + dto.getNombreTarea().toUpperCase() + "%' ");
        }
        
        // Filtro Ambito y Unidad de Gestión
        
        if (dto.getUgGestion() == null || (dto.getUgGestion() != null && dto.getUgGestion().equals(""))) {
        
        	// Unidad Gestion Todas	
        	if (!Checks.esNulo(dto.getAmbitoTarea())) {
        		if (dto.getAmbitoTarea().equals("1")) {
            
          			// Ambito grupo
          			List <String> todasGrupo = new ArrayList<String>();
            		todasGrupo.add("'" + DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE + "'");
            		todasGrupo.add("'" + DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE + "'");
            	
            		Collection<String> cGrupo = todasGrupo;
            		HQLBuilder.addFiltroWhereInSiNotNull(hb, "tar.tarea.tipoEntidad.codigo", cGrupo);
            		
          		} else if (dto.getAmbitoTarea().equals("2")) {
                	
            		// Ambito individual	
            		List <String> todasInd = new ArrayList<String>();
                	todasInd.add("'" + DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO + "'");
                	todasInd.add("'" + DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO + "'");
                
                	Collection<String> cInd = todasInd;
                	HQLBuilder.addFiltroWhereInSiNotNull(hb, "tar.tarea.tipoEntidad.codigo", cInd);
            	}
        	}
        } else if (dto.getUgGestion().contentEquals("1")) {
           	// Unidad Gestion Cliente
           	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.tipoEntidad.codigo", DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
        } else if (dto.getUgGestion().contentEquals("2")) {
           	// Unidad Gestion Expediente
           	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.tipoEntidad.codigo", DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
        } else if (dto.getUgGestion().contentEquals("3")) {
           	// Unidad Gestion Asunto	
           	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.tipoEntidad.codigo", DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
        } else if (dto.getUgGestion().contentEquals("5")) {
           	// Unidad Gestion Procedimiento	
           	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.tipoEntidad.codigo", DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
        }

        
        // Estado Tarea
        if (dto.getEstadoTarea() != null && dto.getEstadoTarea().length() > 0) {
            // ['1','Pendientes'],['2','Terminadas'],['3','Terminadas y vencidas']
            if (dto.getEstadoTarea().equals("1")) {
            	hb.appendWhere("(tar.tarea.tareaFinalizada = 0 or tar.tarea.tareaFinalizada is null)");
            	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.auditoria.borrado", false);
            } else if (dto.getEstadoTarea().equals("2")) {
            	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.tareaFinalizada", true);
            	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.auditoria.borrado", true);
            } else if (dto.getEstadoTarea().equals("3")) {
            	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.tareaFinalizada", true);
            	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.auditoria.borrado", true);
            	hb.appendWhere("tar.tarea.fechaVenc < tar.tarea.fechaFin ");
            }
        }
        
        // Clasificación y Tipo de tarea
        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
        	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.subtipoTarea.tipoTarea.codigoTarea", dto.getCodigoTipoTarea());
        }
        if (dto.getCodigoTipoSubTarea() != null && dto.getCodigoTipoSubTarea().length() > 0) {
        	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.tarea.subtipoTarea.codigoSubtarea", dto.getCodigoTipoSubTarea());
        }
        
        return hb;
    	
    }
	
	public HQLBuilder buscarTareasFechas(HQLBuilder hb, final BTADtoBusquedaTareas dto) {

		// Filtro por fecha de vencimiento
		if ((!Checks.esNulo(dto.getFechaVencimientoDesde())) || (!Checks.esNulo(dto.getFechaVencimientoHasta()))) {
			String fechaVencimientoDesde = "";
			if (dto.getFechaVencimientoDesde() != null){
				fechaVencimientoDesde = dto.getFechaVencimientoDesde();
			}
			Date fechaDesde = parseaFecha(fechaVencimientoDesde, "dd/MM/yyyy");
            Calendar fechaDesdeParse = Calendar.getInstance();
            if (fechaDesde != null) {
                fechaDesdeParse.setTime(fechaDesde);
                if (dto.getFechaVencDesdeOperador().equals(">")) {
                    fechaDesdeParse.add(Calendar.DAY_OF_MONTH, 1);
                }
            }
            
            String fechaVencimientoHasta = "";
            if (dto.getFechaVencimientoHasta() != null){
            	fechaVencimientoHasta = dto.getFechaVencimientoHasta();
            }
            Date fechaHasta = parseaFecha(fechaVencimientoHasta, "dd/MM/yyyy");
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

            HQLBuilder.addFiltroBetweenSiNotNull(hb, "tar.tarea.fechaVenc", fechaDesdeFinal, fechaHastaFinal);

        }

		// Filtro por fecha de inicio
		if ((!Checks.esNulo(dto.getFechaInicioDesde())) || (!Checks.esNulo(dto.getFechaInicioHasta()))) {
			String fechaInicioDesde = "";
			if (dto.getFechaInicioDesde() != null){
				fechaInicioDesde = dto.getFechaInicioDesde();
			}
            Date fechaDesde = parseaFecha(fechaInicioDesde, "dd/MM/yyyy");
            Calendar fechaDesdeParse = Calendar.getInstance();
            if (fechaDesde != null) {
                fechaDesdeParse.setTime(fechaDesde);
                if (dto.getFechaInicioDesdeOperador().equals(">")) {
                    fechaDesdeParse.add(Calendar.DAY_OF_MONTH, 1);
                }
            }
            
            String fechaInicioHasta = "";
            if (dto.getFechaInicioHasta() != null){
            	fechaInicioHasta = dto.getFechaInicioHasta();
            }
            Date fechaHasta = parseaFecha(fechaInicioHasta, "dd/MM/yyyy");
            Calendar fechaHastaParsed = Calendar.getInstance();
            if (fechaHasta != null) {
                fechaHastaParsed.setTime(fechaHasta);
                if (dto.getFechaInicioHastaOperador().equals("<")) {
                    fechaHastaParsed.add(Calendar.DAY_OF_MONTH, -1);
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                } else if (dto.getFechaInicioHastaOperador().equals("<=")) {
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                }
            }

            if ((fechaDesdeParse != null) && (fechaHastaParsed != null) && fechaDesdeParse.getTime().equals(fechaHastaParsed.getTime()) && dto.getFechaInicioDesdeOperador().equals("=")) {
                fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                fechaHastaParsed.add(Calendar.MINUTE, 59);
                fechaHastaParsed.add(Calendar.SECOND, 59);
            }

            Date fechaDesdeFinal;
            if (!Checks.esNulo(dto.getFechaInicioDesde())) {
                fechaDesdeFinal = fechaDesdeParse.getTime();
            } else {
                fechaDesdeFinal = null;
            }

            Date fechaHastaFinal;
            if (!Checks.esNulo(dto.getFechaInicioHasta())) {
                fechaHastaFinal = fechaHastaParsed.getTime();
            } else {
                if (dto.getFechaInicioDesdeOperador().equals("=") && fechaDesdeParse != null) {
                    fechaHastaParsed = fechaDesdeParse;
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                    fechaHastaFinal = fechaHastaParsed.getTime();
                } else {
                    fechaHastaFinal = null;
                }
            }

            HQLBuilder.addFiltroBetweenSiNotNull(hb, "tar.tarea.fechaInicio", fechaDesdeFinal, fechaHastaFinal);

        }

		// Filtro por fecha de fin
		if ((!Checks.esNulo(dto.getFechaFinDesde())) || (!Checks.esNulo(dto.getFechaFinHasta()))) {
			String fechaFinDesde = "";
			if (dto.getFechaFinDesde() != null){
				fechaFinDesde = dto.getFechaFinDesde();
			}
            Date fechaDesde = parseaFecha(fechaFinDesde, "dd/MM/yyyy");
            Calendar fechaDesdeParse = Calendar.getInstance();
            if (fechaDesde != null) {
                fechaDesdeParse.setTime(fechaDesde);
                if (dto.getFechaFinDesdeOperador().equals(">")) {
                    fechaDesdeParse.add(Calendar.DAY_OF_MONTH, 1);
                }
            }
            
            String fechaFinHasta = "";
            if (dto.getFechaFinHasta() != null){
            	fechaFinHasta = dto.getFechaFinHasta();
            }
            Date fechaHasta = parseaFecha(fechaFinHasta, "dd/MM/yyyy");
            Calendar fechaHastaParsed = Calendar.getInstance();
            if (fechaHasta != null) {
                fechaHastaParsed.setTime(fechaHasta);
                if (dto.getFechaFinHastaOperador().equals("<")) {
                    fechaHastaParsed.add(Calendar.DAY_OF_MONTH, -1);
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                } else if (dto.getFechaFinHastaOperador().equals("<=")) {
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                }
            }

            if ((fechaDesdeParse != null) && (fechaHastaParsed != null) && fechaDesdeParse.getTime().equals(fechaHastaParsed.getTime()) && dto.getFechaFinDesdeOperador().equals("=")) {
                fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                fechaHastaParsed.add(Calendar.MINUTE, 59);
                fechaHastaParsed.add(Calendar.SECOND, 59);
            }

            Date fechaDesdeFinal;
            if (!Checks.esNulo(dto.getFechaFinDesde())) {
                fechaDesdeFinal = fechaDesdeParse.getTime();
            } else {
                fechaDesdeFinal = null;
            }

            Date fechaHastaFinal;
            if (!Checks.esNulo(dto.getFechaFinHasta())) {
                fechaHastaFinal = fechaHastaParsed.getTime();
            } else {
                if (dto.getFechaFinDesdeOperador().equals("=") && fechaDesdeParse != null) {
                    fechaHastaParsed = fechaDesdeParse;
                    fechaHastaParsed.add(Calendar.HOUR_OF_DAY, 23);
                    fechaHastaParsed.add(Calendar.MINUTE, 59);
                    fechaHastaParsed.add(Calendar.SECOND, 59);
                    fechaHastaFinal = fechaHastaParsed.getTime();
                } else {
                    fechaHastaFinal = null;
                }
            }

            HQLBuilder.addFiltroBetweenSiNotNull(hb, "tar.tarea.fechaFin", fechaDesdeFinal, fechaHastaFinal);

        }

		return hb;
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
	
	public HQLBuilder buscarTareasGrupo(HQLBuilder hb, final BTADtoBusquedaTareas dto) {
		
        if (!Checks.esNulo(dto.getZonasAbuscar())) {

        	// Filtrar por las zonas recibidas
        	List<String> listadoZonasSegunFiltro = getListadoZonasFiltro(dto.getZonasAbuscar());
            Collection<String> colZonasSegunFiltro = listadoZonasSegunFiltro;
            
            if (dto.getUgGestion() == null 
               		|| (!Checks.esNulo(dto.getUgGestion()) && (dto.getUgGestion().equals("") || dto.getUgGestion().equals("1")))){
           		HQLBuilder.addFiltroWhereInSiNotNull(hb, "tar.tarea.cliente.oficina.zona.codigo", colZonasSegunFiltro);
           	} else if (dto.getUgGestion().equals("2")){
           		HQLBuilder.addFiltroWhereInSiNotNull(hb, "tar.tarea.expediente.oficina.zona.codigo", colZonasSegunFiltro);
           	}	
            
        } else {
            // si filtro por usuario zonas del usuario introducido
            if (dto.getUsernameUsuario() != null && !"".equals(dto.getUsernameUsuario())) {
                Usuario usuario = btaUsuarioDao.getByUsername(dto.getUsernameUsuario());
                if (usuario == null) {
                    // el usuario no se encuentra y por tanto no se debe mostrar
                    // ningï¿œn resultado
                    hb.appendWhere(" and 1=0 ");
                } else {
                    //hql.append(" and ( ");
                	List<String> listadoZonasUsuario = new ArrayList<String>();
                    for (DDZona z : usuario.getZonas()) {
                    	listadoZonasUsuario.add(z.getCodigo());
                    }

                    if (dto.getUgGestion() == null 
                    		|| (!Checks.esNulo(dto.getUgGestion()) && (dto.getUgGestion().equals("") || dto.getUgGestion().equals("1")))){
                    	HQLBuilder.addFiltroWhereInSiNotNull(hb, "tar.tarea.cliente.oficina.zona.codigo", listadoZonasUsuario);
                    } else if (dto.getUgGestion().equals("2")){
                    	HQLBuilder.addFiltroWhereInSiNotNull(hb, "tar.tarea.expediente.oficina.zona.codigo", listadoZonasUsuario);
                    }

                    // control filtro supervisor o gestor
                    List<String> lisPerfilesUsuBuscado = new ArrayList<String>();
                    for (Perfil p : usuario.getPerfiles()) {
                    	lisPerfilesUsuBuscado.add(p.getId().toString());
                    }

                    if (!lisPerfilesUsuBuscado.equals("") && dto.getGestorSupervisorUsuario().equals("1")) {
                    	
                    	Collection<String> colPerfiles = lisPerfilesUsuBuscado;
                    	
                    	HQLBuilder.addFiltroWhereInSiNotNull(hb, "tar.gestorPerfil.id", colPerfiles);
                    	hb.appendWhere("tar.tarea.cliente.arquetipo.itinerario.id = tar.estado.itinerario.id");
                    	
                    } else if (!lisPerfilesUsuBuscado.equals("") && dto.getGestorSupervisorUsuario().equals("2")) {
                    		
                    	Collection<String> colPerfiles = lisPerfilesUsuBuscado;
                    	
                    	HQLBuilder.addFiltroWhereInSiNotNull(hb, "tar.supervisorPerfil.id", colPerfiles);
                    	hb.appendWhere("tar.tarea.cliente.arquetipo.itinerario.id = tar.estado.itinerario.id");
                    }

                }
            } else {
                // Filtrar por todas las zonas a las que el usuario tiene
                // visibilidad
            	if (!Checks.esNulo(dto.getZonas())){
            		List<String> listadoZonas = getListadoZonas(dto);

            		Collection<String> colZonas = listadoZonas;
            		for(String codZona : colZonas) {
            			if (dto.getUgGestion() == null 
                   		|| (!Checks.esNulo(dto.getUgGestion()) && (dto.getUgGestion().equals("") || dto.getUgGestion().equals("1")))){
            				HQLBuilder.addFiltroLikeSiNotNull(hb, "tar.tarea.cliente.oficina.zona.codigo", codZona);
		               	} 
            			else if (dto.getUgGestion().equals("2")) {
            				HQLBuilder.addFiltroLikeSiNotNull(hb, "tar.tarea.expediente.oficina.zona.codigo", codZona);
		               	}
            		}
            	}
            }
        } 
        
        // Decidir si puede o no ver todos los perfiles
        boolean verTodosLosPerfiles = false;
        if (!Checks.esNulo(dto.getUsuarioLogado()) && !Checks.esNulo(dto.getUsuarioLogado().getZonaPerfil())){
        	for (ZonaUsuarioPerfil zup : dto.getUsuarioLogado().getZonaPerfil()) {
        		for (FuncionPerfil fp : zup.getPerfil().getFuncionesPerfil()) {
        			if (fp.getFuncion().getDescripcion().contentEquals("VISIBILIDAD-TAREAS-NOPROPIAS")) {
        				verTodosLosPerfiles = true;
        			}
        		}
        	}
        }
        
        if (!verTodosLosPerfiles && !Checks.esNulo(dto.getPerfiles())) {

        	// si el usuario tiene en alguno de sus perfiles la funcion para ver
            // todos los perfiles saltar
            String listadoPerfiles = "";
            for (Perfil perfil : dto.getPerfiles()){
            	if (listadoPerfiles.equals(""))
            		listadoPerfiles.concat(perfil.getId().toString());
            	else
            		listadoPerfiles.concat(", " + perfil.getId().toString());
            }
            
        	hb = construyeFiltroPerfiles(hb, dto, listadoPerfiles);
        	
        } else if (dto.getPerfilesAbuscar() != null && !"".equals(dto.getPerfilesAbuscar())) {
        	
            hb = construyeFiltroPerfiles(hb, dto, dto.getPerfilesAbuscar());
        }

        // por USUARIO asignado a la unidad de gestiï¿œn
        if (dto.getUsernameUsuario() != null && !"".equals(dto.getUsernameUsuario())) {
            Usuario usuario = btaUsuarioDao.getByUsername(dto.getUsernameUsuario());
            if (usuario != null) {
                String listadoPerfilesEncontrados = "";
                for (Perfil p : usuario.getPerfiles()) {
                	if (listadoPerfilesEncontrados.equals(""))
                		listadoPerfilesEncontrados.concat(p.getCodigo());
                	else
                		listadoPerfilesEncontrados.concat(", " + p.getCodigo());
                }
                hb = construyeFiltroPerfiles(hb, dto, listadoPerfilesEncontrados);
            }
        }
		
		return hb;
	}
	
	/**
	 * 
	 * @param userID
	 * @return
	 */
	private String obtenerListaGrupoIDDeUsuarioYEntidad(String userID){
		StringBuffer resultado = new StringBuffer();
		resultado.append(userID).append(", ");
		Usuario u = new Usuario();
		u.setId(Long.valueOf(userID));
		List<Long> resultados = extGrupoUsuariosDao.buscaGruposUsuario(u);
		for (Object idUsuario : resultados) {
			resultado.append(idUsuario.toString()).append(", ");
		}
		return resultado.substring(0, resultado.length()-2).toString();
	}
	
	public HQLBuilder buscarTareasIndividual(final BTADtoBusquedaTareas dto) {
		HQLBuilder hb2;
		StringBuffer hql = new StringBuffer();
		String idTarea = dto.getComboTipoTarea();
		String idActuacion = dto.getComboTipoActuacion();
  		String idProcedimiento = dto.getComboTipoProcedimiento();
  		
		
		hql.append("select DISTINCT vtar from VTARTareaVsUsuario vtar, TareaProcedimiento tarea"); // Base.
		//hql.append(" inner join TareaNotificacion as tar on tar.tarea = vtar.nombreTarea"); // Filtro por tareas.
		//hql.append(" inner join vtar.nombreTarea tar"); // Filtro por tareas.
		hql.append(" where tarea.descripcion = vtar.nombreTarea and (vtar.usuarioPendiente = " + dto.getComboGestor()); // Filtro usuario.
		hql.append(" or vtar.usuarioPendiente in (select egu.grupo from EXTGrupoUsuarios egu where egu.grupo = " + dto.getComboGestor() + ")"); // Filtro grupo usuario.
        hql.append(" or vtar.usuarioPendiente in (" + obtenerListaGrupoIDDeUsuarioYEntidad(dto.getComboGestor()) + "))"); // Filtro por entidad.
        
  		if(idActuacion != null && idActuacion != ""){
  			hql.append(" and vtar.idActuacion = " + dto.getComboTipoActuacion()); // Filtro por actuacion.
  		}
  		if(idProcedimiento != null && idProcedimiento != ""){
  			hql.append(" and vtar.idProcedimiento   = " + dto.getComboTipoProcedimiento()); // Filtro por procedimiento.
  		}
  		if(idTarea != null && idTarea != ""){
  			//hql.append(" and tar.id = " + dto.getComboTipoTarea()); // Filtro por tareas.
  			hql.append(" and tarea.id = " + dto.getComboTipoTarea()); // Filtro por tareas.
  		}
        
		hb2 = new HQLBuilder(hql.toString());
		
		return hb2;
	}
	
	

	private String filtroGestorGrupo(List<Long> idsUsuariosGrupo) {
		if (idsUsuariosGrupo==null || idsUsuariosGrupo.size()==0)
			return "";
		
		StringBuilder hql = new StringBuilder();
		
		hql.append("(tar.tarea.asunto.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id IN (");
		
		StringBuilder idsUsuarios = new StringBuilder();
		for (Long idUsario : idsUsuariosGrupo) {
			idsUsuarios.append("," + idUsario.toString());
		}
		if (idsUsuarios.length()>1)
			hql.append(idsUsuarios.deleteCharAt(0).toString());
		
		hql.append(")))");
		return hql.toString();
	}
	

    /**
     * Genera un listado List de zonas del usuario
     * 
     * @param dto
     */
    private List<String> getListadoZonas(BTADtoBusquedaTareas dto) {
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

    private HQLBuilder construyeFiltroPerfiles(HQLBuilder hb, final BTADtoBusquedaTareas dto, String listadoPerfiles) {
    	
    	if (!listadoPerfiles.equals("")) {
    		String aux = " case when tar.tarea.subtipoTarea.gestor = true then ";
    
    		// Si no es una tarea en espera ni una alerta, es una tarea normal,
    		// se tiene en cuenta el tipo de tarea
    		if (!dto.isEnEspera() && !dto.isEsAlerta()) {
    			aux = aux + "tar.gestorPerfil.id else tar.supervisorPerfil.id end in ("; 
    			hb.appendWhere(aux + listadoPerfiles + ")");
    		} else if ((dto.isEnEspera() && !dto.isEsAlerta()) || (!dto.isEnEspera() && dto.isEsAlerta())) {
    			aux = aux + "tar.supervisorPerfil.id else tar.gestorPerfil.id end in ("; 
    			hb.appendWhere(aux + listadoPerfiles + ")");
    		// En caso contrario (es espera y es alerta a la vez)
    		} else {
    			aux = aux + "tar.gestorPerfil.id else tar.supervisorPerfil.id end in ("; 
    			hb.appendWhere(aux + listadoPerfiles + ")");
    		}

    	}
    	
    	return hb;
    	
    }
    
	private String getUsuarioByGestor (String idGestor){
    	
    	String usuarios = "";
		List<GestorDespacho> listaGestDes = btaGestorDespachoDao.getGestoresDespachoByUsd(idGestor);
		
		if (!Checks.esNulo(listaGestDes)){
			for (int i = 0; i < listaGestDes.size(); i++) {
				if (i == listaGestDes.size() - 1)
					usuarios = listaGestDes.get(i).getUsuario().getId().toString();
				else
					usuarios = listaGestDes.get(i).getUsuario().getId().toString() + ",";
			}
		}
		return usuarios;
    }

}