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
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
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

        final HQLBuilder hb = new HQLBuilder("select distinct vtar.tarea from VTARTareaVsUsuario vtar");
        armaFiltrosBasicos(dto, usuarioLogado, hb);

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

        final StringBuilder queryStringBuilder = fielsSelector.selectAllFields(modelClass, "vtar", Arrays.asList(Integer.class, Long.class, String.class, Boolean.class, Float.class, Date.class));
        queryStringBuilder.append(" from VTARTareaVsUsuario vtar ");
        
        final HQLBuilder hb = new HQLBuilder(queryStringBuilder.toString());
        //final HQLBuilder hb = new HQLBuilder("select distinct vtar from VTARTareaVsUsuario vtar");
        
        armaFiltrosBasicos(dto, u, hb);

        if (dto.isBusqueda()) {
            armaFiltroBusqueda(dto, u, hb);
        }
        
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
