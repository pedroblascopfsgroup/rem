package es.pfsgroup.plugin.rem.trabajo.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionEconomicaTrabajo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VBusquedaTrabajosGastos;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoHistorificadorCampos;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoGridFilter;

@Repository("TrabajoDao")
public class TrabajoDaoImpl extends AbstractEntityDao<Trabajo, Long> implements TrabajoDao{
	
	@Autowired
	private ProveedoresDao proveedorDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	protected static final Log logger = LogFactory.getLog(TrabajoDaoImpl.class);
	private static final String NIE_HAYA = "A86744349";
	private static final String PERFIL_PROV = "HAYAPROV";
	
	
	@Override
	public Page findAll(DtoTrabajoFilter dto) {
		GastoProveedor gasto = null;
		if (!Checks.esNulo(dto.getNumGasto())) {
			gasto = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGasto()));
		}
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaTrabajos tbj");
		
		this.rellenarFiltrosBusquedaTrabajos(dto, hb, gasto);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "tbj.proveedor", dto.getProveedor(), true);
		
		if (!Checks.esNulo(dto.getNumGasto())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.enOtroGasto", false );
		}
		
		if(!Checks.esNulo(dto.getIdProveedor()) && (Checks.esNulo(gasto))){
			if(Checks.esNulo(gasto.getPropietario())) {
				return new PageHibernate();
			}
		}
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Page findAllFilteredByProveedorContacto(DtoTrabajoFilter dto, Long idUsuario) {
		GastoProveedor gasto = null;
		if (!Checks.esNulo(dto.getNumGasto())) {
			gasto = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGasto()));
		}
		HQLBuilder hb = new HQLBuilder(" from VBusquedaTrabajos tbj");
		
		this.rellenarFiltrosBusquedaTrabajos(dto, hb, gasto);

		List<Long> proveedorId = proveedorDao.getIdsProveedorByIdUsuario(idUsuario);
		if(!Checks.estaVacio(proveedorId)) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.idProveedor", proveedorId);
		}
		else {
			//Si no hay proveedores, no debe mostrar ningún trabajo en el listado
			hb.appendWhere("tbj.id is null");
		}
		
   		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	//Prepara lso filtros de la consulta 
	private void rellenarFiltrosBusquedaTrabajos(DtoTrabajoFilter dto, HQLBuilder hb, GastoProveedor gasto) {
		
		if(dto!= null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numTrabajo", dto.getNumTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.idTrabajoWebcom", dto.getIdTrabajoWebcom());
	   		Collection<String> listaTipo = new ArrayList<String>();
	   		if (dto.getCodigoTipo()!=null) {
	   			listaTipo.add(dto.getCodigoTipo());
	   		}
	   		if (dto.getCodigoTipo2()!=null) {
	   			listaTipo.add(dto.getCodigoTipo2());
	   		}
	   		HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.codigoTipo", listaTipo);
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoSubtipo",dto.getCodigoSubtipo());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoEstado", dto.getCodigoEstado());
	   		HQLBuilder.addFiltroLikeSiNotNull(hb, "tbj.descripcionPoblacion", dto.getDescripcionPoblacion(), true);
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoProvincia", dto.getCodigoProvincia());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codPostal", dto.getCodPostal());
	   		HQLBuilder.addFiltroLikeSiNotNull(hb, "tbj.solicitante", dto.getSolicitante(), true);
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numActivoRem", dto.getNumActivoRem());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numAgrupacionRem", dto.getNumAgrupacionRem());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.idActivo", dto.getIdActivo());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.cartera", dto.getCartera());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.gestorActivo", dto.getGestorActivo());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.cubreSeguro", dto.getCubreSeguro());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.idProveedor", dto.getIdProveedor());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.conCierreEconomico", dto.getConCierreEconomico());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.facturado", dto.getFacturado());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numActivo", dto.getNumActivo());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.gestorActual", dto.getGestorActual());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.areaPeticionaria", dto.getAreaPeticionaria());
	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.responsableTrabajo", dto.getResponsableTrabajo());

	   		if(!Checks.esNulo(dto.getIdProveedor())) {
	   			hb.appendWhere("tbj.importeTotal > " +BigDecimal.ZERO);
	   	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoEstado", DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
	   	   		if(gasto != null && !Checks.esNulo(gasto.getPropietario())) {
	   	   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.propietario", gasto.getPropietario().getId());
	   	   		}
	   		}
	   		
	   		try {
	   			

				if (dto.getFechaPeticionDesde() != null) {
					Date fechaDesde = DateFormat.toDate(dto.getFechaPeticionDesde());
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "tbj.fechaSolicitud", fechaDesde, null);
				}
				
				if (dto.getFechaPeticionHasta() != null) {
					Date fechaHasta = DateFormat.toDate(dto.getFechaPeticionHasta());
			
					// Se le añade un día para que encuentre las fechas del día anterior hasta las 23:59
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaHasta); // Configuramos la fecha que se recibe
					calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0

					HQLBuilder.addFiltroBetweenSiNotNull(hb, "tbj.fechaSolicitud", null, calendar.getTime());
				}
				
				if (dto.getFechaCambioEstadoDesde() != null) {
					Date fechaDesde = DateFormat.toDate(dto.getFechaCambioEstadoDesde());
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "tbj.fechaCambioEstado", fechaDesde, null);
				}
				
				if (dto.getFechaCambioEstadoHasta() != null) {
					Date fechaHasta = DateFormat.toDate(dto.getFechaCambioEstadoHasta());
			
					// Se le añade un día para que encuentre las fechas del día anterior hasta las 23:59
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaHasta); // Configuramos la fecha que se recibe
					calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0

					HQLBuilder.addFiltroBetweenSiNotNull(hb, "tbj.fechaCambioEstado", null, calendar.getTime());
				}
				
	   		} catch (ParseException e) {
	   			logger.error(e);
			}
		}
	}
 
    public Long getNextNumTrabajo() {
		String sql = "SELECT S_TBJ_NUM_TRABAJO.NEXTVAL FROM DUAL ";
		return ((BigDecimal)this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
	}

	@Override
	public Page getListActivosTrabajo(DtoActivosTrabajoFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivosTrabajoParticipa acttbj");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.idTrabajo", dto.getIdTrabajo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.idActivo", dto.getIdActivo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.estadoContable", dto.getEstadoContable());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.codigoEstado", dto.getEstadoCodigo());
		if(dto.getSort() == null) {
			dto.setSort("numActivo");
			dto.setDir("ASC");
		}
   		return HibernateQueryUtils.page(this, hb, dto);
	}

	
	
	@Override
	public Page getActivoMatrizPresupuesto(DtoActivosTrabajoFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivoMatrizPresupuesto acttbj");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.activoMatriz", dto.getIdActivo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.ejercicioAnyo", dto.getEjercicioPresupuestario());
		
   		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page getObservaciones(DtoTrabajoFilter dto) {
		HQLBuilder hb = new HQLBuilder(" from TrabajoObservacion tbo");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbo.trabajo.id", Long.parseLong(dto.getIdTrabajo()));
		
   		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page getListActivosAgrupacion(DtoAgrupacionFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VActivosAgrupacionTrabajo agracttbj");
		
   		if (!Checks.esNulo(dto.getAgrupacionId())) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agracttbj.agrId", Long.valueOf(dto.getAgrupacionId()));
   		}

		return HibernateQueryUtils.page(this, hb, dto);
 
	}  
	
	@Override
	public Page getSeleccionTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, Usuario usuarioLogado)
	{		
		
		Page page = null; 
		
		if (!Checks.esNulo(filtro) || !Checks.esNulo(usuarioLogado)) {
		
			page = getSeleccionTarifasTrabajoConSubcartera(filtro, usuarioLogado);
			
			if (page.getTotalCount() == 0 
					&& !DDSubcartera.CODIGO_JAIPUR_INMOBILIARIO.equals(filtro.getSubcarteraCodigo()) 
					&& !DDSubcartera.CODIGO_JAIPUR_FINANCIERO.equals(filtro.getSubcarteraCodigo())
					&& !DDSubcartera.CODIGO_ZEUS_INMOBILIARIO.equals(filtro.getSubcarteraCodigo())
					&& !DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(filtro.getSubcarteraCodigo())
					&& !DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(filtro.getSubcarteraCodigo())
					&& !DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(filtro.getSubcarteraCodigo())
					&& !DDSubcartera.CODIGO_JAGUAR.equals(filtro.getSubcarteraCodigo())) {
				
				page = getSeleccionTarifasTrabajoSinSubcartera(filtro, usuarioLogado);
			}			
		}
		
		return page;
	}
	
	private Page getSeleccionTarifasTrabajoConSubcartera(DtoGestionEconomicaTrabajo filtro, Usuario usuarioLogado) {
	    Integer tarifaPve = 0;
		HQLBuilder hb = new HQLBuilder(" from ConfiguracionTarifa cfgTar");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.tipoTrabajo.codigo", filtro.getTipoTrabajoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.subtipoTrabajo.codigo", filtro.getSubtipoTrabajoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.cartera.codigo", filtro.getCarteraCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.proveedor.id", filtro.getIdProveedor());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "cfgTar.tipoTarifa.codigo", filtro.getCodigoTarifaTrabajo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "cfgTar.tipoTarifa.descripcion", filtro.getDescripcionTarifaTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.subcartera.codigo", filtro.getSubcarteraCodigo());
		
		for (Perfil prov : usuarioLogado.getPerfiles()) {
			if(prov.getCodigo().equals(PERFIL_PROV)) {
				tarifaPve = 1;
				break;
			}
		}
		
		HQLBuilder.addFiltroIgualQue(hb, "cfgTar.tarifaPve", tarifaPve);
		return HibernateQueryUtils.page(this, hb, filtro);
	}
	
	private Page getSeleccionTarifasTrabajoSinSubcartera(DtoGestionEconomicaTrabajo filtro, Usuario usuarioLogado) {
		Integer tarifaPve = 0;
		HQLBuilder hb = new HQLBuilder(" from ConfiguracionTarifa cfgTar");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.tipoTrabajo.codigo", filtro.getTipoTrabajoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.subtipoTrabajo.codigo", filtro.getSubtipoTrabajoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.cartera.codigo", filtro.getCarteraCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.proveedor.id", filtro.getIdProveedor());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "cfgTar.tipoTarifa.codigo", filtro.getCodigoTarifaTrabajo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "cfgTar.tipoTarifa.descripcion", filtro.getDescripcionTarifaTrabajo());

		for (Perfil prov : usuarioLogado.getPerfiles()) {
			if(prov.getCodigo().equals(PERFIL_PROV)) {
				tarifaPve = 1;
				break;
			}
		}
		
		HQLBuilder.addFiltroIgualQue(hb, "cfgTar.tarifaPve", tarifaPve);
		return HibernateQueryUtils.page(this, hb, filtro);
	}
	
	@Override
	public Page getTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, Usuario usuarioLogado)
	{
		HQLBuilder hb = new HQLBuilder(" from TrabajoConfiguracionTarifa traCfgTar");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "traCfgTar.trabajo.id", filtro.getIdTrabajo());
		
		return HibernateQueryUtils.page(this, hb, filtro);
	}
	
	@Override
	public Page getHistTrabajo(Long filtro)
	{
		
		DtoHistorificadorCampos dto = new DtoHistorificadorCampos();
		
		dto.setIdTrabajo(filtro);
		HQLBuilder hb = new HQLBuilder(" from HistorificadorPestanas histPest");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "histPest.trabajo.id", dto.getIdTrabajo());
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page getPresupuestosTrabajo(DtoGestionEconomicaTrabajo filtro, Usuario usuarioLogado)
	{
		HQLBuilder hb = new HQLBuilder(" from PresupuestoTrabajo preTra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "preTra.trabajo.id", filtro.getIdTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "preTra.proveedorContacto.auditoria.borrado", false);
			
		return HibernateQueryUtils.page(this, hb, filtro);
	}

	@Override
	public Integer getMaxOrdenFotoById(Long id) {

    	HQLBuilder hb = new HQLBuilder("select max(orden) from TrabajoFoto foto where foto.trabajo.id = :id");
    	try {
    		Integer count = (Integer) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).setParameter("id", id).uniqueResult();
    		//Integer cont = ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
    		return count != null ? count : 0;
    	} catch (Exception e) {
    		return 0;
    	}

	}
	

	
	@Override
	public Boolean existsTrabajo(DtoTrabajoFilter dto) {
		Boolean existe = null;
		
		HQLBuilder hb = new HQLBuilder(" from Trabajo tbj");
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.idTrabajoWebcom", dto.getIdTrabajoWebcom());
   		
   		List<Trabajo> tbjList = HibernateQueryUtils.list(this, hb);
   		if(!Checks.esNulo(tbjList) && tbjList.isEmpty()){
			existe = false;
		}else{
			existe = true;
		}
   		
   		return existe;
	}  	
	
	
	@Override
	public Page getBusquedaTrabajosGrid(DtoTrabajoGridFilter dto, Long idUsuario) {
		HQLBuilder hb = new HQLBuilder(" from VGridBusquedaTrabajos vgrid");
		
		List<UsuarioCartera> usuarioCartera = genericDao.getList(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", idUsuario));
		if (usuarioCartera != null && !usuarioCartera.isEmpty()) {
			dto.setCarteraCodigo(usuarioCartera.get(0).getCartera().getCodigo());
		}

		if (Boolean.TRUE.equals(dto.getEsGestorExterno())) {
			List<Long> proveedorIds = proveedorDao.getIdsProveedorByIdUsuario(idUsuario);
			if (Checks.estaVacio(proveedorIds)) {
				hb.appendWhere("vgrid.id is null");
			} else {
				HQLBuilder.addFiltroWhereInSiNotNull(hb, "vgrid.idProveedor", proveedorIds);
			}
		}
		
		if (Boolean.TRUE.equals(dto.getEsControlConsulta())) {
			List<String> codigos = Arrays.asList(TrabajoApi.CODIGO_OBTENCION_DOCUMENTACION, TrabajoApi.CODIGO_ACTUACION_TECNICA);
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "vgrid.tipoTrabajoCodigo", codigos);
		}else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoTrabajoCodigo", dto.getTipoTrabajoCodigo());
		}		
		
		if (dto.getNumTrabajo() != null && StringUtils.isNumeric(dto.getNumTrabajo()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numTrabajo", Long.valueOf(dto.getNumTrabajo()));
		if (dto.getNumAgrupacion() != null && StringUtils.isNumeric(dto.getNumAgrupacion()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numAgrupacion", Long.valueOf(dto.getNumAgrupacion()));
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subtipoTrabajoCodigo", dto.getSubtipoTrabajoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.estadoTrabajoCodigo", dto.getEstadoTrabajoCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.solicitante", dto.getSolicitante(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.proveedor", dto.getProveedor(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.carteraCodigo", dto.getCarteraCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.areaPeticionariaCodigo", dto.getAreaPeticionaria());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.responsableTrabajo", dto.getResponsableTrabajo(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.provinciaCodigo", dto.getProvinciaCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.localidadDescripcion", dto.getLocalidadDescripcion(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.codPostal", dto.getCodPostal());
		if(dto.getGestorActivo() != null) {
			hb.appendWhere(" exists (select 1 from GestorActivo ga, IN (ga.activo.activoTrabajos) atj "
					+ " where ga.tipoGestor.codigo = 'GACT' "
					+ " and UPPER(ga.usuario.username) = '" + dto.getGestorActivo().toUpperCase() + "' "
					+ " and vgrid.id = atj.trabajo.id) ");
		}
		
		
		if(dto.getNumActivo() != null && StringUtils.isNumeric(dto.getNumActivo())) {
			StringBuilder sb = new StringBuilder(" exists (select 1 from ActivoTrabajo atj join atj.activo act"
					+ " where vgrid.id = atj.trabajo.id and act.numActivo =  " + Long.valueOf(dto.getNumActivo()) + " )");
			hb.appendWhere(sb.toString());
		}
		
		try {
			if (dto.getFechaPeticionDesde() != null && dto.getFechaPeticionHasta() != null) {
				Date fechaDesde = DateFormat.toDate(dto.getFechaPeticionDesde());
				Date fechaHasta = DateFormat.toDate(dto.getFechaPeticionHasta());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaSolicitud", fechaDesde, fechaHasta);
			} else if (dto.getFechaPeticionDesde() != null) {
				Date fechaDesde = DateFormat.toDate(dto.getFechaPeticionDesde());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaSolicitud", fechaDesde, null);
			} else if (dto.getFechaPeticionHasta() != null) {
				Date fechaHasta = DateFormat.toDate(dto.getFechaPeticionHasta());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaSolicitud", null, fechaHasta);			
			}
			
			if (dto.getFechaCambioEstadoDesde() != null && dto.getFechaCambioEstadoHasta() != null) {
				Date fechaCambioDesde = DateFormat.toDate(dto.getFechaCambioEstadoDesde());
				Date fechaCambioHasta = DateFormat.toDate(dto.getFechaCambioEstadoHasta());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaCambioEstado", fechaCambioDesde, fechaCambioHasta);
			} else if (dto.getFechaPeticionDesde() != null) {
				Date fechaCambioDesde = DateFormat.toDate(dto.getFechaCambioEstadoDesde());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaCambioEstado", fechaCambioDesde, null);
			} else if (dto.getFechaPeticionHasta() != null) {
				Date fechaCambioHasta = DateFormat.toDate(dto.getFechaCambioEstadoHasta());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaCambioEstado", null, fechaCambioHasta);			
			}
			
		} catch (ParseException e) {
			logger.error(e.getMessage());
		}
		
		if(Checks.esNulo(dto.getSort())) {
			dto.setSort("id");
		}
		return HibernateQueryUtils.page(this, hb, dto);
	}

//	@Override
//	public Page findAllFilteredIncluidoFactura(DtoTrabajoFilter dto, Long idUsuario) {
//		
//		HQLBuilder hb = new HQLBuilder(" from VBusquedaTrabajosGasto btg");
//		
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.numTrabajo", dto.getNumTrabajo());
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.conCierreEconomico", dto.getConCierreEconomico());
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.facturado", dto.getFacturado());
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.codigoSubtipo", dto.getCodigoSubtipo());
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.cubreSeguro", dto.getCubreSeguro());
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.cartera", dto.getCartera());
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.subcartera", dto.getSubcartera());
//
//		if(idUsuario != null) {
//			List<Long> proveedorId = proveedorDao.getIdsProveedorByIdUsuario(idUsuario);
//			if(!Checks.estaVacio(proveedorId)) {
//				HQLBuilder.addFiltroWhereInSiNotNull(hb, "btg.idProveedor", proveedorId);
//			}
//			else {
//				//Si no hay proveedores, no debe mostrar ningún trabajo en el listado
//				hb.appendWhere("btg.id is null");
//			}
//		}
//		
//		GastoProveedor gasto = null;
//		if (dto.getNumGasto() != null) {
//			gasto = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGasto()));
//			
//			if(dto.getIdProveedor() != null) {
//				hb.appendWhere("btg.importeTotal > " + BigDecimal.ZERO);
//				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.codigoEstado", DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
//				if(gasto != null && gasto.getPropietario() != null) {
//					HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.propietario", gasto.getPropietario().getId());
//				}
//			}
//		}
//		
//		Collection<String> listaTipo = new ArrayList<String>();
//   		if (dto.getCodigoTipo()!=null) {
//   			listaTipo.add(dto.getCodigoTipo());
//   		}
//   		if (dto.getCodigoTipo2()!=null) {
//   			listaTipo.add(dto.getCodigoTipo2());
//   		}
//   		
//   		if(!listaTipo.isEmpty()) {
//   			HQLBuilder.addFiltroWhereInSiNotNull(hb, "btg.codigoTipo", listaTipo);
//   		}
//		
//   		return HibernateQueryUtils.page(this, hb, dto);
//	}

	@Override
	public void flush() {
		this.getSessionFactory().getCurrentSession().flush();
	}
	

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage findBuscadorGasto(DtoTrabajoFilter dto) {
		
		Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGasto());
		GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtroGasto);
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaTrabajosGastos tbj");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numTrabajo", dto.getNumTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoTipoGasto", gasto.getTipoGasto().getCodigo());

   		if (dto.getCodigoTipo()!=null) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoTipo", dto.getCodigoTipo());
   		}
   		else if(dto.getCodigoTipo2()!=null) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoTipo", dto.getCodigoTipo2());
   		}
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.cubreSeguro", dto.getCubreSeguro());
   		
   		
   		if (dto.getCodigoSubtipo()!=null) {
   		  List<String> listaSubTipo = new ArrayList<String>();
   		  for (String subTipo : dto.getCodigoSubtipo().split(",")) {
   			  listaSubTipo.add("'" + subTipo + "'");
   		  }
   		  HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.codigoSubtipo",listaSubTipo);
   		} 		
		
		if(gasto.getProveedor().getDocIdentificativo().equals(NIE_HAYA)) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.propietario", gasto.getPropietario().getId());
		}
		else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.propietario", gasto.getPropietario().getId());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.idProveedor", gasto.getProveedor().getId());
		}
		
   		try {
   			

			if (dto.getFechaPeticionDesde() != null) {
				Date fechaDesde = DateFormat.toDate(dto.getFechaPeticionDesde());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "tbj.fechaSolicitud", fechaDesde, null);
			}
			
			if (dto.getFechaPeticionHasta() != null) {
				Date fechaHasta = DateFormat.toDate(dto.getFechaPeticionHasta());
		
				// Se le añade un día para que encuentre las fechas del día anterior hasta las 23:59
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaHasta); // Configuramos la fecha que se recibe
				calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0

				HQLBuilder.addFiltroBetweenSiNotNull(hb, "tbj.fechaSolicitud", null, calendar.getTime());
			}
			
   		} catch (ParseException e) {
   			logger.error(e);
		}
		
		hb.orderBy("descripcionSubtipo", HQLBuilder.ORDER_ASC);
		
		
		Page pageTrabajos = HibernateQueryUtils.page(this, hb, dto);
		List<VBusquedaTrabajosGastos> trabajoGastos = (List<VBusquedaTrabajosGastos>) pageTrabajos.getResults();
		for(VBusquedaTrabajosGastos trabajoGasto : trabajoGastos) {
			if(!Checks.esNulo(gasto.getDestinatarioGasto()) && gasto.getDestinatarioGasto().getCodigo().equals(DDDestinatarioGasto.CODIGO_HAYA)) {
				trabajoGasto.setImporteTotal(trabajoGasto.getImportePresupuesto());
			}
		}
		
		return new DtoPage(trabajoGastos, pageTrabajos.getTotalCount());
	}
	
	@Override
	public Page findAllFilteredHistoricoPeticion(DtoTrabajoFilter dto, Long idUsuario) {
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaTrabajosHistoricoPeticion tbj");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numActivo", dto.getNumActivo());

		if(idUsuario != null) {
			List<Long> proveedorId = proveedorDao.getIdsProveedorByIdUsuario(idUsuario);
			if(!Checks.estaVacio(proveedorId)) {
				HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.idProveedor", proveedorId);
			}
//			else {
//				//Si no hay proveedores, no debe mostrar ningún trabajo en el listado
//				hb.appendWhere("tbj.id is null");
//			}
		}
		
		Collection<String> listaTipo = new ArrayList<String>();
   		if (dto.getCodigoTipo()!=null) {
   			listaTipo.add(dto.getCodigoTipo());
   		}
   		if (dto.getCodigoTipo2()!=null) {
   			listaTipo.add(dto.getCodigoTipo2());
   		}
   		
   		if(!listaTipo.isEmpty()) {
   			HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.codigoTipo", listaTipo);
   		}
		
		
   		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page findAllFilteredIncluidoFactura(DtoTrabajoFilter dto, Long idUsuario) {
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaTrabajosGasto btg");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.numTrabajo", dto.getNumTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.conCierreEconomico", dto.getConCierreEconomico());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.facturado", dto.getFacturado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.codigoSubtipo", dto.getCodigoSubtipo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.cubreSeguro", dto.getCubreSeguro());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.cartera", dto.getCartera());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.subcartera", dto.getSubcartera());

		if(idUsuario != null) {
			List<Long> proveedorId = proveedorDao.getIdsProveedorByIdUsuario(idUsuario);
			if(!Checks.estaVacio(proveedorId)) {
				HQLBuilder.addFiltroWhereInSiNotNull(hb, "btg.idProveedor", proveedorId);
			}
			else {
				//Si no hay proveedores, no debe mostrar ningún trabajo en el listado
				hb.appendWhere("btg.id is null");
			}
		}
		
		GastoProveedor gasto = null;
		if (dto.getNumGasto() != null) {
			gasto = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGasto()));
			
			if(dto.getIdProveedor() != null) {
				hb.appendWhere("btg.importeTotal > " + BigDecimal.ZERO);
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.codigoEstado", DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
				if(gasto != null && gasto.getPropietario() != null) {
					HQLBuilder.addFiltroIgualQueSiNotNull(hb, "btg.propietario", gasto.getPropietario().getId());
				}
			}
		}
		
		Collection<String> listaTipo = new ArrayList<String>();
   		if (dto.getCodigoTipo()!=null) {
   			listaTipo.add(dto.getCodigoTipo());
   		}
   		if (dto.getCodigoTipo2()!=null) {
   			listaTipo.add(dto.getCodigoTipo2());
   		}
   		
   		if(!listaTipo.isEmpty()) {
   			HQLBuilder.addFiltroWhereInSiNotNull(hb, "btg.codigoTipo", listaTipo);
   		}
		
   		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	
	
	@Override
    public Page findAllNoVista(DtoTrabajoFilter dto) {
        List <String> in = new  ArrayList<String>();
        StringBuilder sb = new StringBuilder(" select tbj from Trabajo tbj ");
        // JOIN solo si entra cartera o numero de activo
        if (dto.getCartera() != null || dto.getSubcartera() != null || dto.getNumActivo() != null) {
            sb.append(" join tbj.activosTrabajo acttbj ");
            sb.append(" join acttbj.activo act ");
        }
        HQLBuilder hb = new HQLBuilder(sb.toString());
        
        if ((dto.getCodigoTipo()!=null)){
            in.add(dto.getCodigoTipo());
        }
        if (dto.getCodigoTipo2() != null){
            in.add(dto.getCodigoTipo2());
        }
        if (in.size() > 0) {
            HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.tipoTrabajo", in);
        }
        if (dto.getNumTrabajo() != null){
            HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numTrabajo", dto.getNumTrabajo());
        }
        
        if (dto.getNumActivo() != null){
            HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivo", dto.getNumActivo()); 
        }else {
            if (dto.getCartera() != null){
                HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.cartera.codigo", dto.getCartera());
            }
            if (dto.getSubcartera() != null){
                HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subcartera.codigo", dto.getSubcartera());
            }
        }
        
        return HibernateQueryUtils.page(this, hb, dto);
    }
	
	  @Override
	    public Page findAllFilteredByProveedorContactoNoVista(DtoTrabajoFilter dto, Long idUsuario) {
        List <Long>  proveedorId = proveedorDao.getIdsProveedorByIdUsuario(idUsuario);
        List <String> in = new  ArrayList<String>();
        StringBuilder sb = new StringBuilder(" select tbj from Trabajo tbj ");
        // JOIN solo si entra cartera o num activo
        if (dto.getCartera() != null || dto.getSubcartera() != null || dto.getNumActivo() != null) {
	            sb.append(" join tbj.activosTrabajo acttbj ");
	            sb.append(" join acttbj.activo act ");
        }	
        HQLBuilder hb = new HQLBuilder(sb.toString());
        
        if ((dto.getCodigoTipo()!=null)){
            in.add(dto.getCodigoTipo());
        }
        if (dto.getCodigoTipo2() != null){
            in.add(dto.getCodigoTipo2());
        }
        if (in.size() > 0) {
            HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.tipoTrabajo", in);
        }
        if (dto.getNumTrabajo() != null){
            HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numTrabajo", dto.getNumTrabajo());
        }
        
        if (dto.getNumActivo() != null){
            HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivo", dto.getNumActivo()); 
        }else {
            if (dto.getCartera() != null){
                HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.cartera.codigo", dto.getCartera());
            }
            if (dto.getSubcartera() != null){
                HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subcartera.codigo", dto.getSubcartera());
            }
        }
        if (proveedorId.size() >0) {
            // ID Proveedor
            HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.proveedorContacto.id", proveedorId);
        }
        
        return HibernateQueryUtils.page(this, hb, dto);
	   }
	  
	  
	  
	
	

}
