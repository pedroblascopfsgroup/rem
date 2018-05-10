package es.pfsgroup.plugin.rem.trabajo.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionEconomicaTrabajo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;

@Repository("TrabajoDao")
public class TrabajoDaoImpl extends AbstractEntityDao<Trabajo, Long> implements TrabajoDao{
	
	@Autowired
	ProveedoresDao proveedorDao;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Override
	public Page findAll(DtoTrabajoFilter dto) {
		GastoProveedor gasto = null;
		if (!Checks.esNulo(dto.getNumGasto())) {
			gasto = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGasto()));
		}
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaTrabajos tbj");
			
		this.rellenarFiltrosBusquedaTrabajos(dto, hb, gasto);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "tbj.proveedor", dto.getProveedor(), true);
		if(!Checks.esNulo(dto.getIdProveedor()) && Checks.esNulo(gasto.getPropietario())){
			return new PageHibernate();
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

		List<String> nombresProveedor = proveedorDao.getNombreProveedorByIdUsuario(idUsuario);
		if(!Checks.estaVacio(nombresProveedor)) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.proveedor", nombresProveedor);
		}
		else {
			//Si no hay proveedores, no debe mostrar ningún trabajo en el listado
			hb.appendWhere("tbj.id is null");
		}
		
   		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	//Prepara lso filtros de la consulta 
	@SuppressWarnings("static-access")
	private void rellenarFiltrosBusquedaTrabajos(DtoTrabajoFilter dto, HQLBuilder hb, GastoProveedor gasto) {
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numTrabajo", dto.getNumTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.idTrabajoWebcom", dto.getIdTrabajoWebcom());
   		Collection<String> listaTipo = new ArrayList<String>();
   		if (dto!=null && dto.getCodigoTipo()!=null) {
   			listaTipo.add(dto.getCodigoTipo());
   		}
   		if (dto!=null && dto.getCodigoTipo2()!=null) {
   			listaTipo.add(dto.getCodigoTipo2());
   		}
   		HQLBuilder.addFiltroWhereInSiNotNull(hb, "tbj.codigoTipo", listaTipo);   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoSubtipo", dto.getCodigoSubtipo());
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
   		if(!Checks.esNulo(dto.getIdProveedor())) {
   			hb.appendWhere("tbj.importeTotal > " +BigDecimal.ZERO);
   	   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoEstado", DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
   	   		if(!Checks.esNulo(gasto.getPropietario())) {
   	   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.propietario", gasto.getPropietario().getId());
   	   		}
   		}

   		if(Checks.esNulo(dto.getNumActivo()) && Checks.esNulo(dto.getIdActivo())) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.rango", 1);
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
			e.printStackTrace();
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
		
   		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Page getListActivosTrabajoPresupuesto(DtoActivosTrabajoFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivosTrabajoPresupuesto acttbj");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.idTrabajo", dto.getIdTrabajo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.idActivo", dto.getIdActivo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.estadoContable", dto.getEstadoContable());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.codigoEstado", dto.getEstadoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acttbj.ejercicio", dto.getEjercicioPresupuestario());
		
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
		HQLBuilder hb = new HQLBuilder(" from ConfiguracionTarifa cfgTar");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.tipoTrabajo.codigo", filtro.getTipoTrabajoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.subtipoTrabajo.codigo", filtro.getSubtipoTrabajoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.cartera.codigo", filtro.getCarteraCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cfgTar.proveedor.id", filtro.getIdProveedor());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "cfgTar.tipoTarifa.codigo", filtro.getCodigoTarifaTrabajo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "cfgTar.tipoTarifa.descripcion", filtro.getDescripcionTarifaTrabajo());

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
	public Page getPresupuestosTrabajo(DtoGestionEconomicaTrabajo filtro, Usuario usuarioLogado)
	{
		List<String> nombresProveedor = proveedorDao.getNombreProveedorByIdUsuario(usuarioLogado.getId());
		HQLBuilder hb = new HQLBuilder(" from PresupuestoTrabajo preTra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "preTra.trabajo.id", filtro.getIdTrabajo());
		if(!Checks.estaVacio(nombresProveedor)) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "preTra.proveedor.nombre", nombresProveedor);
		}
		
		return HibernateQueryUtils.page(this, hb, filtro);
	}

	@Override
	public Integer getMaxOrdenFotoById(Long id) {

    	HQLBuilder hb = new HQLBuilder("select max(orden) from TrabajoFoto foto where foto.trabajo.id = " + id);
    	try {
    		//Integer cont = ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
    		return ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
    	} catch (Exception e) {
    		return 0;
    	}

	}
	

	
	@Override
	public Boolean existsTrabajo(DtoTrabajoFilter dto) {
		Boolean existe = null;
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaTrabajos tbj");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.id", dto.getIdTrabajo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numTrabajo", dto.getNumTrabajo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.idTrabajoWebcom", dto.getIdTrabajoWebcom());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoTipo", dto.getCodigoTipo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoSubtipo", dto.getCodigoSubtipo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoEstado", dto.getCodigoEstado());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "tbj.descripcionPoblacion", dto.getDescripcionPoblacion(), true);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codigoProvincia", dto.getCodigoProvincia());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.codPostal", dto.getCodPostal());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "tbj.solicitante", dto.getSolicitante(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "tbj.proveedor", dto.getProveedor(), true);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numActivoRem", dto.getNumActivoRem());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numAgrupacionRem", dto.getNumAgrupacionRem());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.idActivo", dto.getIdActivo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.cartera", dto.getCartera());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.gestorActivo", dto.getGestorActivo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numActivo", dto.getNumActivo());
   		
   		if(Checks.esNulo(dto.getNumActivo()) && Checks.esNulo(dto.getIdActivo())) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.rango", 1);
   		}

   		List<Trabajo> tbjList = HibernateQueryUtils.list(this, hb);
   		if(!Checks.esNulo(tbjList) && tbjList.isEmpty()){
			existe = false;
		}else{
			existe = true;
		}
   		
   		return existe;
	}  	

}
