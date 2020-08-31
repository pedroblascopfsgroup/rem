package es.pfsgroup.plugin.rem.albaran.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.albaran.dao.AlbaranDao;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.Albaran;
import es.pfsgroup.plugin.rem.model.DtoAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Prefactura;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;

@Repository("AlbaranDao")
public class AlbaranDaoImpl extends AbstractEntityDao<Albaran, Long> implements AlbaranDao {

	@Autowired
	private GenericABMDao genericDao;
	
	public Page getAlbaranes(DtoAlbaranFiltro dtoAlbaranes) {
		
		HQLBuilder hb = new HQLBuilder("Select id, numAlbaran" + 
				" , fechaAlbaran" + 
				" , estadoAlbaran" + 
				" , numPrefacturas" + 
				" , numTrabajos" + 
				" , importeTotal" + 
				" , importeTotalCliente from VbusquedaAlbaranes vba");
		
		this.rellenaFiltros(hb, dtoAlbaranes);
		
//		return this.getListadoAlbaranesCompleto(dtoAlbaranes, hb);
		return HibernateQueryUtils.page(this, hb, dtoAlbaranes);
		
	}
	
	@SuppressWarnings("unchecked")
	private DtoPage getListadoAlbaranesCompleto(DtoAlbaranFiltro dtoAlbaran, HQLBuilder hb) {

		Page pageAlbaran = HibernateQueryUtils.page(this, hb, dtoAlbaran);
		List<Albaran> duplicados = (List<Albaran>) pageAlbaran.getResults();
		Set<Albaran> NoDuplicados = new HashSet<Albaran>(duplicados);
		List<Albaran> albaranes =  new ArrayList<Albaran>(NoDuplicados);
		List<DtoAlbaran> listaAlbaranes = new ArrayList<DtoAlbaran>();
		for(int i = 0; albaranes.size()> i; i++) {
			DtoAlbaran albaran = new DtoAlbaran();
			Double total = 0.0;
			Double totalPresu = 0.0;
			albaran.setNumAlbaran(albaranes.get(i).getNumAlbaran());
			albaran.setFechaAlbaran(albaranes.get(i).getFechaAlbaran());
			if(albaranes.get(i).getEstadoAlbaran() != null) {
				albaran.setEstadoAlbaran(albaranes.get(i).getEstadoAlbaran().getDescripcion());
			}
			List<Prefactura> prefacturas = genericDao.getList(Prefactura.class,
					genericDao.createFilter(FilterType.EQUALS, "albaran.id", albaranes.get(i).getId()));
			if (prefacturas != null && !prefacturas.isEmpty()) {
				albaran.setNumPrefacturas((long) prefacturas.size());
				int numGastos = 0;
				for (Prefactura prefactura : prefacturas) {
					List<Trabajo> trabajos = genericDao.getList(Trabajo.class,
							genericDao.createFilter(FilterType.EQUALS, "prefactura.id", prefactura.getId()));
					if (trabajos != null && !trabajos.isEmpty()) {
						numGastos += trabajos.size();
						for (Trabajo trabajo : trabajos) {
							if(trabajo.getImporteTotal() != null) {
								total += trabajo.getImporteTotal();
							}
							if(trabajo.getImportePresupuesto() != null) {
								totalPresu += trabajo.getImportePresupuesto();
							}
						}
						albaran.setImporteTotal(totalPresu);
						albaran.setImporteTotalCliente(total);
					} else {
						albaran.setImporteTotal(0.0);
						albaran.setImporteTotalCliente(0.0);
					}
				}
				albaran.setNumTrabajos((long) numGastos);
			}
			listaAlbaranes.add(albaran);
		}
		
		return new DtoPage(listaAlbaranes, listaAlbaranes.size());
	}
	
	
	private void rellenaFiltros(HQLBuilder hb, DtoAlbaranFiltro dto) {
		if(dto!= null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.numAlbaran", dto.getNumAlbaran());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.codigoEstadoAlbaran", dto.getEstadoAlbaran());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.numPrefactura", dto.getNumPrefactura());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.codigoEstadoPrefactura", dto.getEstadoPrefactura());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.codigoTipologiaTrabajo", dto.getTipologiaTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.numTrabajo", dto.getNumTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.codigoEstadoTrabajo", dto.getEstadoTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.solicitante", dto.getSolicitante());
			HQLBuilder.addFiltroLikeSiNotNull(hb, "vba.proveedor", dto.getProveedor());
			try {
				if(dto.getFechaAlbaran() != null) {
					Date fechaAlb = DateFormat.toDate(dto.getFechaAlbaran());
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaAlb); // Configuramos la fecha que se recibe
					calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0
					
					Calendar sumado = Calendar.getInstance();
					sumado.setTime(fechaAlb); // Configuramos la fecha que se recibe
					sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "vba.fechaAlbaran", sumado.getTime(), calendar.getTime());
				}
				if(dto.getFechaPrefactura() != null){
					Date fechaPfa = DateFormat.toDate(dto.getFechaPrefactura());
					
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaPfa); // Configuramos la fecha que se recibe
					calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0
					
					Calendar sumado = Calendar.getInstance();
					sumado.setTime(fechaPfa); // Configuramos la fecha que se recibe
					sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "vba.fechaPrefactura", sumado.getTime(), calendar.getTime());
				}
				if(dto.getAnyoTrabajo() != null) {
					SimpleDateFormat formatter = new SimpleDateFormat("01-01-YYYY");
//					Date fechaTrabajo = DateFormat.toDate(dto.getAnyoTrabajo());
					Date fechaTrabajo = formatter.parse(dto.getAnyoTrabajo());
					
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaTrabajo); // Configuramos la fecha que se recibe
					calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0
					
					Calendar sumado = Calendar.getInstance();
					sumado.setTime(fechaTrabajo); // Configuramos la fecha que se recibe
					sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "vba.fechaSolicitud", sumado.getTime(), calendar.getTime());
				}
				
				HQLBuilder.appendGroupBy(hb,
										"ALB_ID",
										"ALB_NUM_ALBARAN",
										"ALB_FECHA_ALBARAN",
										"DD_ESA_DESCRIPCION",
										"NUMPREFACTURA",
										"NUMTRABAJO",
										"SUM_PRESUPUESTO",
										"SUM_TOTAL");
			}catch (ParseException e) {
				logger.error(e);
			}
			
			
		}
	}
	
	public List<DDEstadoAlbaran> getComboEstadoAlbaran() {
		List<DDEstadoAlbaran> lista = new ArrayList<DDEstadoAlbaran>();
		HQLBuilder hb = new HQLBuilder("from DDEstadoAlbaran estAlb ");
		lista = getHibernateTemplate().getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		return lista;
	}
	
	public List<DDEstEstadoPrefactura> getComboEstadoPrefactura(){
		List<DDEstEstadoPrefactura> lista = new ArrayList<DDEstEstadoPrefactura>();
		HQLBuilder hb = new HQLBuilder("from DDEstEstadoPrefactura estPfa ");
		lista = getHibernateTemplate().getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		return lista;
	}
	
	public List<DDEstadoTrabajo> getComboEstadoTrabajo(){
		List<DDEstadoTrabajo> lista = new ArrayList<DDEstadoTrabajo>();
		HQLBuilder hb = new HQLBuilder("from DDEstadoTrabajo estTbj ");
		lista = getHibernateTemplate().getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		return lista;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoProveedor> getProveedores() {
		HQLBuilder hb = new HQLBuilder(" from ActivoProveedor pve");
		hb.appendWhere(" pve.auditoria.borrado = 0 and pve.nombre is not null and pve.fechaBaja is null ");
//		HQLBuilder hb = new HQLBuilder(
//				"select distinct pve.id, pve.codigoProveedorRem, pve.tipoProveedorDescripcion, pve.subtipoProveedorDescripcion, pve.nifProveedor, pve.nombreProveedor, pve.nombreComercialProveedor, pve.estadoProveedorDescripcion, pve.observaciones from VBusquedaProveedor pve");
//		hb.appendWhere("pve.estadoProveedorCodigo = 04 and pve.tipoProveedorCodigo = 03");
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.estadoProveedorCodigo", filtro.getEstadoProveedorCodigo());
//		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pve.tipoProveedorCodigo", filtro.getTipoProveedorCodigo());
//		hb.orderBy("pve.nombreProveedor", "asc");
		
		List<ActivoProveedor> mediadores = (List<ActivoProveedor>) getHibernateTemplate().find(hb.toString());
		
		return mediadores;
	}
	
	public Page getPrefacturas(DtoDetalleAlbaran dto) {
		HQLBuilder hb = new HQLBuilder(" from VbusquedaPrefacturas vbp");
		Albaran alb = genericDao.get(Albaran.class,
				genericDao.createFilter(FilterType.EQUALS, "numAlbaran", dto.getNumAlbaran()));
		if(alb == null) {
			return new PageHibernate(); 
		}
		HQLBuilder.addFiltroIgualQue(hb, "vbp.albaranId", alb.getId());
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	public Page getTrabajos(DtoDetallePrefactura dto) {
		HQLBuilder hb = new HQLBuilder(" from VbusquedaTrabajosPrefactura vtp");
		Prefactura pre = genericDao.get(Prefactura.class,
				genericDao.createFilter(FilterType.EQUALS, "numPrefactura", dto.getNumPrefactura()));
		if(pre == null) {
			return new PageHibernate();
		}
		HQLBuilder.addFiltroIgualQue(hb, "vtp.prefacturaID", pre.getId());
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

}
