package es.pfsgroup.plugin.rem.albaran.dao.impl;

import java.text.ParseException;
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
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.albaran.dao.AlbaranDao;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Albaran;
import es.pfsgroup.plugin.rem.model.DtoAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.Prefactura;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VbusquedaProveedoresCombo;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Repository("AlbaranDao")
public class AlbaranDaoImpl extends AbstractEntityDao<Albaran, Long> implements AlbaranDao {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	public Page getAlbaranes(DtoAlbaranFiltro dtoAlbaranes) {
		
		HQLBuilder hb = new HQLBuilder("Select vba.id, vba.numAlbaran" + 
				" , vba.fechaAlbaran" + 
				" , vba.estadoAlbaran" + 
				" , vba.numPrefacturas" + 
				" , vba.numTrabajos" + 
				" , vba.importeTotal" + 
				" , vba.importeTotalCliente" +
				" , vba.validarAlbaran from VbusquedaAlbaranes vba");
		
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
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.ddIreCodigo", dto.getAreaPeticionaria());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.numAlbaran", dto.getNumAlbaran());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.codigoEstadoAlbaran", dto.getEstadoAlbaran());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.numPrefactura", dto.getNumPrefactura());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.codigoEstadoPrefactura", dto.getEstadoPrefactura());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.codigoTipologiaTrabajo", dto.getTipologiaTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.numTrabajo", dto.getNumTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.solicitante", dto.getSolicitante());
			HQLBuilder.addFiltroLikeSiNotNull(hb, "vba.proveedor", dto.getProveedor());
			if(!Checks.esNulo(dto.getEstadoTrabajo())) {
				DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoTrabajo()));
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.estadoTrabajo", estado.getDescripcion());
			}
			try {
				if(dto.getFechaAlbaran() != null) {
					Date fechaAlb = DateFormat.toDate(dto.getFechaAlbaran());
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaAlb); // Configuramos la fecha que se recibe
					Calendar sumado = Calendar.getInstance();
					sumado.setTime(fechaAlb); // Configuramos la fecha que se recibe
					sumado.add(Calendar.DAY_OF_YEAR, 1); 
					sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "vba.fechaAlbaran", calendar.getTime(), sumado.getTime());
				}
				if(dto.getFechaPrefactura() != null){
					Date fechaPfa = DateFormat.toDate(dto.getFechaPrefactura());
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaPfa); // Configuramos la fecha que se recibe
					Calendar sumado = Calendar.getInstance();
					sumado.setTime(fechaPfa); // Configuramos la fecha que se recibe
					sumado.add(Calendar.DAY_OF_YEAR, 1);  
					sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "vba.fechaPrefactura",  calendar.getTime(), sumado.getTime());
				}
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vba.anyoTrabajo", dto.getAnyoTrabajo());
				
				
				
				HQLBuilder.appendGroupBy(hb,
										"ALB_ID",
										"ALB_NUM_ALBARAN",
										"ALB_FECHA_ALBARAN",
										"DD_ESA_DESCRIPCION",
										"NUMPREFACTURA",
										"NUMTRABAJO",
										"SUM_PRESUPUESTO",
										"SUM_TOTAL",
										"VALIDARALBARAN");
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
		List<DDEstadoTrabajo> list = new ArrayList<DDEstadoTrabajo>();
		boolean identificadorFlag = true;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "flagActivo", identificadorFlag);
		try {
			list = genericDao.getList(DDEstadoTrabajo.class, filtro);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VbusquedaProveedoresCombo> getProveedores() {
		HQLBuilder hb = new HQLBuilder(" from VbusquedaProveedoresCombo pve");
		
		List<VbusquedaProveedoresCombo> mediadores = new ArrayList<VbusquedaProveedoresCombo>();
		mediadores  = getHibernateTemplate().getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		
		return mediadores;
	}
	
	public Page getPrefacturas(DtoDetalleAlbaran dto) {
		List<Long> numPrefacturaList = null;
		
		if(!Checks.esNulo(dto.getEstadoTrabajo()) || !Checks.esNulo(dto.getAnyoTrabajo()) || !Checks.esNulo(dto.getNumTrabajo())) {
			HQLBuilder hq = new HQLBuilder("select distinct vtp.prefacturaID from VbusquedaTrabajosPrefactura vtp");
			HQLBuilder.addFiltroIgualQueSiNotNull(hq, "vtp.anyoTrabajo", dto.getAnyoTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hq, "vtp.numTrabajo", dto.getNumTrabajo());
			if(!Checks.esNulo(dto.getEstadoTrabajo())) {
				DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoTrabajo()));
				HQLBuilder.addFiltroIgualQueSiNotNull(hq, "vtp.estadoTrabajo", estado.getDescripcion());
			}
			Query query = this.getSessionFactory().getCurrentSession().createQuery(hq.toString());
			HQLBuilder.parametrizaQuery(query, hq);
			numPrefacturaList = query.list();
		}
		HQLBuilder hb = new HQLBuilder("from VbusquedaPrefacturas vbp");
		Albaran alb = genericDao.get(Albaran.class,
				genericDao.createFilter(FilterType.EQUALS, "numAlbaran", dto.getNumAlbaran()));
		if(alb == null) {
			return new PageHibernate(); 
		}
		HQLBuilder.addFiltroIgualQue(hb, "vbp.albaranId", alb.getId());
		
		if(!Checks.esNulo(dto.getEstadoAlbaran())) {
			DDEstEstadoPrefactura estado = genericDao.get(DDEstEstadoPrefactura.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoAlbaran()));
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vbp.estadoAlbaran", estado.getDescripcion());
		}
		if(dto.getFechaPrefactura() != null && !dto.getFechaPrefactura().equals("")){
			try {
			
				Date fechaPfa = DateFormat.toDate(dto.getFechaPrefactura());
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaPfa); 
				Calendar sumado = Calendar.getInstance();
				sumado.setTime(fechaPfa); 
				sumado.add(Calendar.DAY_OF_YEAR, 1);
				sumado.add(Calendar.MILLISECOND, -1);
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "vbp.fechaPrefactura", calendar.getTime(), sumado.getTime());
			
			}catch (ParseException e) {
				logger.error(e);
			}
		}
			
		if(!Checks.esNulo(numPrefacturaList) && !numPrefacturaList.isEmpty()) {
				HQLBuilder.addFiltroWhereInSiNotNull(hb,"vbp.numPrefactura",numPrefacturaList);
		}
		else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vbp.numPrefactura", dto.getNumPrefactura());
		}
		
		if(dto.getCodAreaPeticionaria() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vbp.codAreaPeticionaria", dto.getCodAreaPeticionaria());
		}
		
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
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vtp.anyoTrabajo", dto.getAnyoTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vtp.numTrabajo", dto.getNumTrabajo());
		if(!Checks.esNulo(dto.getEstadoTrabajo())) {
			DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoTrabajo()));
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vtp.estadoTrabajo", estado.getDescripcion());
		}
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page getTrabajosPrefacturas(DtoAlbaranFiltro dto) throws ParseException {
		HQLBuilder hb = new HQLBuilder(" from VExportTrabajosAlbaranes veta");
		Albaran alb = genericDao.get(Albaran.class,
				genericDao.createFilter(FilterType.EQUALS, "numAlbaran", dto.getNumAlbaran()));
		if(alb == null) {
			return new PageHibernate(); 
		}
		
		HQLBuilder.addFiltroIgualQue(hb, "veta.numAlbaran", alb.getNumAlbaran());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.estadoAlbaranCodigo", dto.getEstadoAlbaran());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.numPrefactura", dto.getNumPrefactura());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.estadoPrefacturaCodigo", dto.getEstadoPrefactura());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.numTrabajo", dto.getNumTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.anyoTrabajo", dto.getAnyoTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.estadoTrabajoCodigo", dto.getEstadoTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.tipoTrabajoCodigo", dto.getTipologiaTrabajo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.IdProveedor", dto.getProveedor());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "veta.docPropietario", dto.getSolicitante());
		
		if(dto.getFechaAlbaran() != null) {
			Date fechaAlb = DateFormat.toDate(dto.getFechaAlbaran());
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(fechaAlb); // Configuramos la fecha que se recibe
			Calendar sumado = Calendar.getInstance();
			sumado.setTime(fechaAlb); // Configuramos la fecha que se recibe
			sumado.add(Calendar.DAY_OF_YEAR, 1); 
			sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "veta.fechaAlbaran", calendar.getTime(), sumado.getTime());
		}
		if(dto.getFechaPrefactura() != null){
			Date fechaPfa = DateFormat.toDate(dto.getFechaPrefactura());
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(fechaPfa); // Configuramos la fecha que se recibe
			Calendar sumado = Calendar.getInstance();
			sumado.setTime(fechaPfa); // Configuramos la fecha que se recibe
			sumado.add(Calendar.DAY_OF_YEAR, 1);  
			sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "veta.fechaPrefactura",  calendar.getTime(), sumado.getTime());
		}
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

}
