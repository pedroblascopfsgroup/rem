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
import es.pfsgroup.plugin.rem.model.Albaran;
import es.pfsgroup.plugin.rem.model.DtoAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Prefactura;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Repository("AlbaranDao")
public class AlbaranDaoImpl extends AbstractEntityDao<Albaran, Long> implements AlbaranDao {

	@Autowired
	private GenericABMDao genericDao;
	
	public DtoPage getAlbaranes(DtoAlbaranFiltro dtoAlbaranes) {
		String from = "select albaran from Albaran albaran , Trabajo tbj, Prefactura pfa";
		
		HQLBuilder hb = new HQLBuilder(from);
		hb.appendWhere("albaran.id = pfa.albaran.id");
		hb.appendWhere("pfa.id = tbj.prefactura.id");
		
		this.rellenaFiltros(hb, dtoAlbaranes);
		
		return this.getListadoAlbaranesCompleto(dtoAlbaranes, hb);
		
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
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "albaran.numAlbaran", dto.getNumAlbaran());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "albaran.estadoAlbaran.codigo", dto.getEstadoAlbaran());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pfa.numPrefactura", dto.getNumPrefactura());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pfa.estadoPrefactura.codigo", dto.getEstadoPrefactura());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.tipoTrabajo.codigo", dto.getTipologiaTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.numTrabajo", dto.getNumTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.estado.codigo", dto.getEstadoTrabajo());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pfa.propietario.docIdentificativo", dto.getSolicitante());
			HQLBuilder.addFiltroLikeSiNotNull(hb, "tbj.mediador.nombre", dto.getProveedor());
			try {
				if(dto.getFechaAlbaran() != null) {
					Date fechaAlb = DateFormat.toDate(dto.getFechaAlbaran());
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaAlb); // Configuramos la fecha que se recibe
					calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0
					
					Calendar sumado = Calendar.getInstance();
					sumado.setTime(fechaAlb); // Configuramos la fecha que se recibe
					sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "albaran.fechaAlbaran", sumado.getTime(), calendar.getTime());
				}
				if(dto.getFechaPrefactura() != null){
					Date fechaPfa = DateFormat.toDate(dto.getFechaPrefactura());
					
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaPfa); // Configuramos la fecha que se recibe
					calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0
					
					Calendar sumado = Calendar.getInstance();
					sumado.setTime(fechaPfa); // Configuramos la fecha que se recibe
					sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "pfa.fechaPrefactura", sumado.getTime(), calendar.getTime());
				}
				if(dto.getAnyoTrabajo() != null) {
					Date fechaTrabajo = DateFormat.toDate(dto.getAnyoTrabajo());
					
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(fechaTrabajo); // Configuramos la fecha que se recibe
					calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0
					
					Calendar sumado = Calendar.getInstance();
					sumado.setTime(fechaTrabajo); // Configuramos la fecha que se recibe
					sumado.add(Calendar.MILLISECOND, -1);  // numero de días a añadir, o restar en caso de días<0
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "tbj.fechaSolicitud", sumado.getTime(), calendar.getTime());
				}
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

}
