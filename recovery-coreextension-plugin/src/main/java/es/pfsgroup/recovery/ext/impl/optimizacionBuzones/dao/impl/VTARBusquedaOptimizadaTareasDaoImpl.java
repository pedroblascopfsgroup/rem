package es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.hibernate.dao.AbstractHibernateDao;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.coreextension.utils.EXTHQLFieldsSelector;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import es.pfsgroup.recovery.ext.factory.dao.HQLBuilderReutilizable;
import es.pfsgroup.recovery.ext.factory.dao.HQLQueryCallback;
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.model.VTARTareaVsUsuario;

@Repository("VTARBusquedaOptimizadaTareasDao")
public class VTARBusquedaOptimizadaTareasDaoImpl extends AbstractEntityDao<TareaNotificacion, Long> implements VTARBusquedaOptimizadaTareasDao {
    
    @Autowired
    private EXTHQLFieldsSelector fielsSelector;

	@Autowired
	private EXTGrupoUsuariosDao grupoUsuarioDao;

    @Autowired
    private UsuarioDao usuarioDao;

    @Override
    public Long obtenerCantidadDeTareasPendientes(final DtoBuscarTareaNotificacion dto, final boolean conCarterizacion, final Usuario usuarioLogado) {
        dto.setLimit(1);

        final StringBuilder queryStringBuilder = new StringBuilder("select distinct vtar.tarea from VTARTareaVsUsuario vtar ");
        queryStringBuilder.append("where ").append(armaFiltrosBasicosString(dto,usuarioLogado));
        
        final HQLBuilder hb = new HQLBuilder(queryStringBuilder.toString());
        
        //armaFiltrosBasicos(dto, usuarioLogado, hb);

        final Page list = HibernateQueryUtils.page(this, hb, dto);

        return new Long(list != null ? list.getTotalCount() : 0);
    }

    @Override
    public Page buscarTareasPendiente(final DtoBuscarTareaNotificacion dto, final boolean conCarterizacion, final Usuario u, Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass) {

        HQLBuilderReutilizable rhql = createHQLBbuscarTareasPendiente(dto, u, modelClass);
        HQLBuilder hb = rhql.getHqlBuilder();
        HQLQueryCallback callback = rhql.getQueryCallback();
      

        final Page page = callback.getPage(this, hb, dto);
        return page;
    }
    
    
    /**
     * Este método crea un objeto HQL Builder reutilizable que permite extender la búsqueda de tareas pendientes
     * @param dto
     * @param u
     * @param modelClass
     * @return
     */
    public final HQLBuilderReutilizable createHQLBbuscarTareasPendiente(DtoBuscarTareaNotificacion dto, Usuario u, final Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass){
    	dto.setSort(reescribeParametro(dto.getSort()));

        //final StringBuilder queryStringBuilder = new StringBuilder(fielsSelector.selectAllFields(modelClass, "tartot", Arrays.asList(Integer.class, Long.class, String.class, Boolean.class, Float.class, Date.class))); 
        //queryStringBuilder.append(" FROM ((");
        
        final StringBuilder queryStringBuilder = new StringBuilder();
        queryStringBuilder.append(fielsSelector.selectAllFields(modelClass, "vtar", Arrays.asList(Integer.class, Long.class, String.class, Boolean.class, Float.class, Date.class)));
        queryStringBuilder.append(" from VTARTareaVsUsuario vtar ");
        queryStringBuilder.append("where ").append(armaFiltrosBasicosString(dto,u));
        
        if (dto.isBusqueda())
        	queryStringBuilder.append(armaFiltroBusquedaString(dto, u));
        
        
        final HQLBuilder hb = new HQLBuilder(queryStringBuilder.toString());
        
        HQLQueryCallback callback = new HQLQueryCallback() {

			@Override
			public TipoResultado getCallbackType() {
				return HQLQueryCallback.TipoResultado.PAGE;
			}

			@Override
			public Page getPage(AbstractHibernateDao ldao,
					HQLBuilder lhqlbuilder, WebDto ldto) {
				return returnPageTransformedFAKE(ldao, lhqlbuilder, ldto, modelClass);
			}
		};
        
        return new HQLBuilderReutilizable(hb, callback);
    }
    
    public final HQLBuilderReutilizable createHQLBbuscarTareasPendienteExpediente(DtoBuscarTareaNotificacion dto, Usuario u, final Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass) {
    	dto.setSort(reescribeParametro(dto.getSort(),"vtarExp"));
    	
    	final HQLBuilder hb = new HQLBuilder(UnionTareasExpedientes(dto, modelClass, false).toString());
    	
    	HQLQueryCallback callback = new HQLQueryCallback() {
    		@Override
    		public TipoResultado getCallbackType() {
    			return HQLQueryCallback.TipoResultado.PAGE;
    		}
    		
    		@Override
    		public Page getPage(AbstractHibernateDao ldao,
    				HQLBuilder lhqlbuilder, WebDto ldto) {
    			return returnPageTransformedFAKE(ldao, lhqlbuilder, ldto, modelClass);
    		}
    	};
    	
    	return new HQLBuilderReutilizable(hb, callback);
    }
    
    private StringBuilder UnionTareasExpedientes (DtoBuscarTareaNotificacion dto, final Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass, boolean addUnion) {
        //Añadimos tareas de expediente
    	StringBuilder queryStringBuilder = new StringBuilder();
    	if (addUnion)
    		queryStringBuilder.append(" union (");
    	
    	if (!Checks.esNulo(modelClass))
    		queryStringBuilder.append(fielsSelector.selectAllFields(modelClass, "vtarExp", Arrays.asList(Integer.class, Long.class, String.class, Boolean.class, Float.class, Date.class)));
    	else
    		queryStringBuilder.append("select distinct vtarExp.tarea ");
    
    	queryStringBuilder.append(" from VTARTareaVsUsuarioP3Exp vtarExp ");
        
        
        StringBuilder params = new StringBuilder();
        
        /*queryStringBuilder.append(" and vtarExp.tipoEntidad.codigo = ")
				.append(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE).append(" ");*/
        
		if (dto.getCodigoTipoTarea() != null
				&& dto.getCodigoTipoTarea().length() > 0) {
	        if (params.length()>0)
	        	params.append(" and ");
			params.append("vtarExp.codigoTarea = " + dto.getCodigoTipoTarea());
		}
		
		if (dto.isEnEspera()) {
	        if (params.length()>0)
	        	params.append(" and ");			
			params.append("vtarExp.espera = true ");
		}
		if (dto.isEsAlerta()) {
	        if (params.length()>0)
	        	params.append(" and ");			
	        params.append("vtarExp.alerta = true ");
		}
		
		if (dto.getZonas().size()>0) {
	        if (params.length()>0)
	        	params.append(" and ");
	        params.append("(");
			for (DDZona zonCodigo : dto.getZonas()) {
				params.append(" vtarExp.zonCodigo like '")
						.append(zonCodigo.getCodigo()).append("%' OR");
			}
			params.deleteCharAt(params.length() - 1);
			params.deleteCharAt(params.length() - 1);
			params.append(")");
		}
		
		if (dto.getPerfiles().size()>0) {
			if (params.length()>0)
				params.append(" and ");
			params.append("(vtarExp.idPerfil IN (");
			for (Perfil idPerfil : dto.getPerfiles()) {
				params.append(idPerfil.getId().toString()).append(",");
			}		
			params.deleteCharAt(params.length() - 1);
			params.append(")) ");
		}
		
		if (params.length()>0)
			params.insert(0, "where ");
		
		queryStringBuilder.append(params);
		
		if (addUnion)
			queryStringBuilder.append(" ) ");
		
		return queryStringBuilder;
    	
    }
   
    private <T extends Serializable, K extends Serializable> Page returnPageTransformedFAKE(AbstractHibernateDao<T, K> dao, HQLBuilder hqlbuilder, PaginationParams dto, Class clazz) 
    {
		PageTransformHibernateFAKE page = new PageTransformHibernateFAKE(hqlbuilder.toString(), dto, hqlbuilder.getParameters(), clazz);
		dao.getHibernateTemplate().executeFind(page);
		return page;

    }

    @Override
    public Integer buscarTareasPendienteCount(final DtoBuscarTareaNotificacion dto, final boolean conCarterizacion, final Usuario usuarioLogado, Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass) {
        final Page page = buscarTareasPendiente(dto, conCarterizacion, usuarioLogado, modelClass);
        return Integer.valueOf(page.getResults().size());
    }

    private void armaFiltrosBasicos(final DtoBuscarTareaNotificacion dto, final Usuario u, final HQLBuilder hb) {
    	List<Long> grupos = grupoUsuarioDao.buscaGruposUsuario(u);
    	grupos.add(u.getId()); // incluimos el usuario
    	StringBuilder listaIdUsuarios = new StringBuilder();
    	String sep = "";
    	for (Long str : grupos) {
    		listaIdUsuarios.append(sep).append(str);
    	    sep = ",";
    	}
        if (dto.isEnEspera()) {
        	String usuIdWhere = String.format("vtar.usuarioEnEspera in (%s)", listaIdUsuarios);
        	hb.appendWhere(usuIdWhere);
        } else if (dto.isEsAlerta()) {
        	String usuIdWhere = String.format("vtar.usuarioAlerta in (%s)", listaIdUsuarios);
        	hb.appendWhere(usuIdWhere);
        } else {
        	String usuIdWhere = String.format("vtar.usuarioPendiente in (%s)", listaIdUsuarios);
        	hb.appendWhere(usuIdWhere);
        }

        // Que la tarea est� pendiente
        hb.appendWhere("vtar.tarea.tareaFinalizada is null or vtar.tarea.tareaFinalizada = 0");
        hb.appendWhere("vtar.borrado = 0");

        // Filtro por tipo de tarea
        HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vtar.codigoTipoTarea", dto.getCodigoTipoTarea());

        // Alertas y espera
        if (dto.isEnEspera()) {
            hb.appendWhere("vtar.espera = 1 ");
        }
        if (dto.isEsAlerta()) {
            hb.appendWhere("vtar.alerta = 1 ");
            // alertasLetradosActivos(hb);
        }
    }
    
    private StringBuilder armaFiltrosBasicosString(final DtoBuscarTareaNotificacion dto, final Usuario u) {
    	final StringBuilder hb = new StringBuilder("(");
    	
    	
    	List<Long> grupos = grupoUsuarioDao.buscaGruposUsuario(u);
    	grupos.add(u.getId()); // incluimos el usuario
    	StringBuilder listaIdUsuarios = new StringBuilder();
    	String sep = "";
    	for (Long str : grupos) {
    		listaIdUsuarios.append(sep).append(str);
    	    sep = ",";
    	}
    	hb.append(" ( ");
        if (dto.isEnEspera()) {
        	String usuIdWhere = String.format(" vtar.usuarioEnEspera in (%s)", listaIdUsuarios);
        	hb.append(usuIdWhere);
        } else if (dto.isEsAlerta()) {
        	String usuIdWhere = String.format(" vtar.usuarioAlerta in (%s)", listaIdUsuarios);
        	hb.append(usuIdWhere);
        } else {
        	String usuIdWhere = String.format(" vtar.usuarioPendiente in (%s)", listaIdUsuarios);
        	hb.append(usuIdWhere);
        }

        // Que la tarea est� pendiente
        if (hb.length()>0)
        	hb.append(" and ");
        hb.append("(vtar.tarea.tareaFinalizada is null or vtar.tarea.tareaFinalizada = 0)");
        hb.append(" and vtar.borrado = 0");

        // Filtro por tipo de tarea
        //HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vtar.codigoTipoTarea", dto.getCodigoTipoTarea());
        hb.append(" and vtar.codigoTipoTarea = " + dto.getCodigoTipoTarea());

        // Alertas y espera
        if (dto.isEnEspera()) {
            hb.append(" and vtar.espera = 1 ");
        }
        if (dto.isEsAlerta()) {
            hb.append(" and vtar.alerta = 1 ");
            // alertasLetradosActivos(hb);
        }
        
        //Parte Expedientes
        hb.append(") OR (");
        
		if (dto.getZonas().size()>0) {
			hb.append(" (");
			for (DDZona zonCodigo : dto.getZonas()) {
				hb.append(" vtar.zonCodigo like '")
						.append(zonCodigo.getCodigo()).append("%' OR");
			}
			hb.deleteCharAt(hb.length() - 1);
			hb.deleteCharAt(hb.length() - 1);
			hb.append(" )");
		}
		
		if (dto.getPerfiles().size()>0) {
			if (dto.getZonas().size()>0)
				hb.append(" and ");
			hb.append(" (vtar.idPerfil IN (");
			for (Perfil idPerfil : dto.getPerfiles()) {
				hb.append(idPerfil.getId().toString()).append(",");
			}		
			hb.deleteCharAt(hb.length() - 1);
			hb.append(")");
			hb.append(") ");
		}
		hb.append("))" );
		
        return hb;
    }

    // private void alertasLetradosActivos(HQLBuilder hb) {
    // hb.appendWhere("vtar.emisor not in (" +
    // "select distinct usu.username " +
    // "from LssLetradoSituacionSuper let, Usuario usu " +
    // "where let.idLetrado = usu.id and let.letradoActivo = 0)");
    // hb.appendWhere("vtar.emisor not in (" +
    // "select distinct concat(case when (usu_apellido1 is not null) then concat(usu_apellido1, ' ') end, "
    // +
    // "case when (usu_apellido2 is not null) then concat(usu_apellido2, ', ') end, usu_nombre) "
    // +
    // "from LssLetradoSituacionSuper let, Usuario usu " +
    // "where let.idLetrado = usu.id and let.letradoActivo = 0)");
    // }

    private void armaFiltroBusqueda(final DtoBuscarTareaNotificacion dto, final Usuario u, final HQLBuilder hb) {

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

            HQLBuilder.addFiltroBetweenSiNotNull(hb, "vtar.fechaVenc", fechaDesdeFinal, fechaHastaFinal);

        }

        // Filtro por fecha de inicio
        if ((!Checks.esNulo(dto.getFechaInicioDesde())) || (!Checks.esNulo(dto.getFechaInicioHasta()))) {
            Date fechaDesde = parseaFecha(dto.getFechaInicioDesde(), "dd/MM/yyyy");
            Date fechaHasta = parseaFecha(dto.getFechaInicioHasta(), "dd/MM/yyyy");
            HQLBuilder.addFiltroBetweenSiNotNull(hb, "vtar.fechaInicio", fechaDesde, fechaHasta);
        }

        // Descripcion Entidad Informacion
        HQLBuilder.addFiltroLikeSiNotNull(hb, "vtar.descripcionTarea", dto.getDescripcionTarea(), true);

        // Nombre Tarea (TareaNotificacion.getDescripcionTarea)
        HQLBuilder.addFiltroLikeSiNotNull(hb, "vtar.nombreTarea", dto.getNombreTarea(), true);

    }
    
    private StringBuilder armaFiltroBusquedaString(final DtoBuscarTareaNotificacion dto, final Usuario u) {
    	final SimpleDateFormat formateaFecha = new SimpleDateFormat("dd/MM/yyyy");
    	
    	final StringBuilder hb = new StringBuilder(); 
    	
        // Filtro por fecha de vencimiento
        if ((!Checks.esNulo(dto.getFechaVencimientoDesde())) || (!Checks.esNulo(dto.getFechaVencimientoHasta()))) {
        	Calendar fechaDesdeParse = null;
        	Calendar fechaHastaParsed = null;
        	if (!Checks.esNulo(dto.getFechaVencimientoDesde()) && !dto.getFechaVencimientoDesde().isEmpty()) {
	            Date fechaDesde = parseaFecha(dto.getFechaVencimientoDesde(), "dd/MM/yyyy");
	            fechaDesdeParse = Calendar.getInstance();
	            if (fechaDesde != null) {
	                fechaDesdeParse.setTime(fechaDesde);
	                if (dto.getFechaVencDesdeOperador().equals(">")) {
	                    fechaDesdeParse.add(Calendar.DAY_OF_MONTH, 1);
	                }
	            }
        	}

        	if (!Checks.esNulo(dto.getFechaVencimientoHasta()) && !dto.getFechaVencimientoHasta().isEmpty()) {
	            Date fechaHasta = parseaFecha(dto.getFechaVencimientoHasta(), "dd/MM/yyyy");
	            fechaHastaParsed = Calendar.getInstance();
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

            //HQLBuilder.addFiltroBetweenSiNotNull(hb, "vtar.fechaVenc", fechaDesdeFinal, fechaHastaFinal);
            if (!Checks.esNulo(fechaDesdeFinal) && !Checks.esNulo(fechaHastaFinal))
            	hb.append(" vtar.fechaVenc BETWEEN TO_DATE('" +  formateaFecha.format(fechaDesdeFinal) + "','dd/MM/yyyy') and TO_DATE('" + formateaFecha.format(fechaHastaFinal) + "','dd/MM/yyyy')" );

        }

        // Filtro por fecha de inicio
        if ((!Checks.esNulo(dto.getFechaInicioDesde())) || (!Checks.esNulo(dto.getFechaInicioHasta()))) {
            //Date fechaDesde = parseaFecha(dto.getFechaInicioDesde(), "dd/MM/yyyy");
            //Date fechaHasta = parseaFecha(dto.getFechaInicioHasta(), "dd/MM/yyyy");
            //HQLBuilder.addFiltroBetweenSiNotNull(hb, "vtar.fechaInicio", fechaDesde, fechaHasta);
        	if (hb.length()>0)
        		hb.append(" and ");
            hb.append(" vtar.fechaInicio BETWEEN TO_DATE('" + dto.getFechaInicioDesde() + "','dd/MM/yyyy') and TO_DATE('" + dto.getFechaInicioHasta() + "','dd/MM/yyyy')");
        }

        // Descripcion Entidad Informacion
        //HQLBuilder.addFiltroLikeSiNotNull(hb, "vtar.descripcionTarea", dto.getDescripcionTarea(), true);
        if (!Checks.esNulo(dto.getDescripcionTarea())) {
        	if (hb.length()>0)
        		hb.append(" and ");
        	//hb.append(" UPPER(vtar.descripcionTarea) like '%" + dto.getDescripcionTarea().toUpperCase() + "%'");
        	//La descripcion expediente es el campo descripcion que se muestra en la grid
        	hb.append(" UPPER(vtar.descripcionExpediente) like '%" + dto.getDescripcionTarea().toUpperCase() + "%'"); 
        }

        // Nombre Tarea (TareaNotificacion.getDescripcionTarea)
        //HQLBuilder.addFiltroLikeSiNotNull(hb, "vtar.nombreTarea", dto.getNombreTarea(), true);
        if (!Checks.esNulo(dto.getNombreTarea())) {
        	if (hb.length()>0)
        		hb.append(" and ");
        	hb.append(" UPPER(vtar.nombreTarea) like '%" + dto.getNombreTarea().toUpperCase() + "%'");
        }
        
        if (hb.length()>0) {
        	hb.insert(0, " AND (");
        	hb.append(") ");
        }
        
        return hb;

    }    

    private Date parseaFecha(final String fecha, final String formato) {
        final SimpleDateFormat sdf = new SimpleDateFormat(formato);
        try {
        	if(!Checks.esNulo(fecha)){
        		return sdf.parse(fecha);
        	}else{
        		return null;
        	}
        } catch (ParseException e) {
            logger.error("No se ha podido parsear la fecha '" + fecha + "' al formato '" + formato + "'");
            logger.error(e.getMessage(), e);
            return null;
        }
    }

    private String reescribeParametro(final String parametro) {
        if (Checks.esNulo(parametro)) {
            return parametro;
        }

        return "vtar." + parametro;

    }
    
    private String reescribeParametro(final String parametro, final String alias) {
        if (Checks.esNulo(parametro)) {
            return parametro;
        }

        return alias + "." + parametro;
    }

    @Override
    public Usuario obtenerResponsableTarea(Long idTarea) {
       //Criteria criteria = this.getSession().createCriteria(VTARTareaVsUsuario.class, "vTarUsu");
       //criteria.add(Restrictions.eq("vTarUsu.id", idTarea));
       //criteria.add(Restrictions.isNotEmpty("vTarUsu.usuarioPendiente"));
       //List<VTARTareaVsUsuario> list = criteria.setMaxResults(1).list();
       
	   	Query q = this.getSession().createQuery("from VTARTareaVsUsuario t where t.id = :id and t.usuarioPendiente != null");
        q.setParameter( "id", idTarea);
        List<VTARTareaVsUsuario> list = q.setMaxResults(1).list();

        Usuario usuario = null;
       if (list.size()>0) {
           usuario = usuarioDao.get(list.get(0).getUsuarioPendiente());
       }
       
       return usuario;
       }

}
