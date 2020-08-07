package es.pfsgroup.plugin.rem.albaran;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.albaran.dao.AlbaranDao;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.api.AlbaranApi;
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

@Service("albaranManager")
public class AlbaranManager extends BusinessOperationOverrider<AlbaranApi> implements AlbaranApi {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private AlbaranDao albaranDao;

	@Override
	public String managerName() {
		return "albaranManager";
	}

	public DtoPage findAll(DtoAlbaranFiltro dto) {
		DtoPage page = albaranDao.getAlbaranes(dto);
		return page;
	}

	public List<DtoDetalleAlbaran> findAllDetalle(Long numAlbaran) {
		List<DtoDetalleAlbaran> dtos = new ArrayList<DtoDetalleAlbaran>();
		Double total = 0.0;
		Albaran alb = genericDao.get(Albaran.class,
				genericDao.createFilter(FilterType.EQUALS, "numAlbaran", numAlbaran));
		List<Prefactura> prefacturas = genericDao.getList(Prefactura.class,
				genericDao.createFilter(FilterType.EQUALS, "albaran.id", alb.getId()));
		if (!prefacturas.isEmpty()) {
			for (Prefactura prefactura : prefacturas) {
				DtoDetalleAlbaran dto = new DtoDetalleAlbaran();
				List<GastoProveedor> gastos = genericDao.getList(GastoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "prefactura.id", prefactura.getId()));
				if(gastos != null && !gastos.isEmpty()) {
					if(prefactura.getEstadoPrefactura().CODIGO_VALIDA.equals(prefactura.getEstadoPrefactura().getCodigo())) {
						for(GastoProveedor g : gastos) {
							total += g.getGastoDetalleEconomico().getImporteTotal();
						}
					}
					for (GastoProveedor gasto : gastos) {
						dto = new DtoDetalleAlbaran();
						dto = rellenaDtoDetalleAlbaran(gasto, prefactura);
						dto.setImporteTotalClienteDetalle(total);
						dto.setImporteTotalDetalle(total);
						dtos.add(dto);
					}
				}else {
					dto = rellenaDtoDetalleAlbaran(null, prefactura);
					dto.setImporteTotalClienteDetalle(total);
					dto.setImporteTotalDetalle(total);
					dtos.add(dto);
				}
			}
		}
		return dtos;
	}

	public List<DtoDetallePrefactura> findPrefectura(Long numPrefactura) {
		List<DtoDetallePrefactura> dtos = new ArrayList<DtoDetallePrefactura>();
		Prefactura pre = genericDao.get(Prefactura.class,
				genericDao.createFilter(FilterType.EQUALS, "numPrefactura", numPrefactura));
		List<Trabajo> trabajos = genericDao.getList(Trabajo.class,
				genericDao.createFilter(FilterType.EQUALS, "prefactura.id", pre.getId()));
		if (!trabajos.isEmpty()) {
			for (Trabajo trabajo : trabajos) {
				DtoDetallePrefactura dto = new DtoDetallePrefactura();
				if (trabajo.getNumTrabajo() != null) {
					dto.setNumTrabajo(trabajo.getNumTrabajo());
				}
				if (trabajo.getDescripcion() != null && !trabajo.getDescripcion().isEmpty()) {
					dto.setDescripcion(trabajo.getDescripcion());
				}
				if (trabajo.getFechaSolicitud() != null) {
					dto.setFechaAlta(trabajo.getFechaSolicitud());
				}
				if (trabajo.getTipoTrabajo() != null && trabajo.getTipoTrabajo().getDescripcion() != null
						&& !trabajo.getTipoTrabajo().getDescripcion().isEmpty()) {
					dto.setTipologiaTrabajo(trabajo.getTipoTrabajo().getDescripcion());
				}
				if (trabajo.getSubtipoTrabajo() != null && trabajo.getSubtipoTrabajo().getDescripcion() != null
						&& !trabajo.getSubtipoTrabajo().getDescripcion().isEmpty()) {
					dto.setSubtipologiaTrabajo(trabajo.getSubtipoTrabajo().getDescripcion());
				}
				if (trabajo.getEstado() != null && trabajo.getEstado().getDescripcion() != null
						&& !trabajo.getEstado().getDescripcion().isEmpty()) {
					dto.setEstadoTrabajo(trabajo.getEstado().getDescripcion());
				}
				if(pre.getEstadoPrefactura().CODIGO_VALIDA.equals(pre.getEstadoPrefactura().getCodigo())) {
					dto.setCheckIncluirTrabajo(true);
				}else {
					dto.setCheckIncluirTrabajo(false);
				}
				dtos.add(dto);
			}
		}

		return dtos;
	}
	
	private DtoDetalleAlbaran rellenaDtoDetalleAlbaran(GastoProveedor gasto,Prefactura prefactura) {
		DtoDetalleAlbaran dto = new DtoDetalleAlbaran();
		if(gasto != null) {
			if (prefactura.getNumPrefactura() != null) {
				dto.setNumPrefactura(prefactura.getNumPrefactura());
			}
			if (prefactura.getPropietario() != null && prefactura.getPropietario().getFullName() != null
					&& !prefactura.getPropietario().getFullName().isEmpty()) {
				dto.setPropietario(prefactura.getPropietario().getFullName());
			}
			if (prefactura.getEstadoPrefactura() != null
					&& prefactura.getEstadoPrefactura().getDescripcion() != null
					&& !prefactura.getEstadoPrefactura().getDescripcion().isEmpty()) {
				dto.setEstadoAlbaran(prefactura.getEstadoPrefactura().getDescripcion());
			}
			if (prefactura.getFechaPrefactura() != null) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(prefactura.getFechaPrefactura());
				int anyo = calendar.get(calendar.YEAR);
				dto.setAnyo(String.valueOf(anyo));
			}
			if(gasto.getNumGastoHaya() != null) {
				dto.setNumGasto(gasto.getNumGastoHaya());
			}
			if(gasto.getEstadoGasto() != null && gasto.getEstadoGasto().getDescripcion() != null 
					&& gasto.getEstadoGasto().getDescripcion().isEmpty()) {
				dto.setEstadoGasto(gasto.getEstadoGasto().getDescripcion());
			}
		}else {
			if (prefactura.getNumPrefactura() != null) {
				dto.setNumPrefactura(prefactura.getNumPrefactura());
			}
			if (prefactura.getPropietario() != null && prefactura.getPropietario().getFullName() != null
					&& !prefactura.getPropietario().getFullName().isEmpty()) {
				dto.setPropietario(prefactura.getPropietario().getFullName());
			}
			if (prefactura.getEstadoPrefactura() != null
					&& prefactura.getEstadoPrefactura().getDescripcion() != null
					&& !prefactura.getEstadoPrefactura().getDescripcion().isEmpty()) {
				dto.setEstadoAlbaran(prefactura.getEstadoPrefactura().getDescripcion());
			}
			if (prefactura.getFechaPrefactura() != null) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(prefactura.getFechaPrefactura());
				int anyo = calendar.get(calendar.YEAR);
				dto.setAnyo(String.valueOf(anyo));
			}
		}
		
		return dto;
	}

	@Transactional
	public Boolean validarAlbaran(Long id) {
		Albaran alb = genericDao.get(Albaran.class,
				genericDao.createFilter(FilterType.EQUALS, "numAlbaran", id));
		if(alb.getEstadoAlbaran() != null && alb.getEstadoAlbaran().getCodigo() != null ) {
			DDEstadoAlbaran estadoAlb = genericDao.get(DDEstadoAlbaran.class,
					genericDao.createFilter(FilterType.EQUALS, "descripcion", DDEstadoAlbaran.DESCRIPCION_VALIDADO));
			alb.setEstadoAlbaran(estadoAlb);
			genericDao.update(Albaran.class, alb);
		}else {
			return false;
		}
		return true;
	}
	
	@Transactional
	public Boolean validarPrefactura(Long id) {
		Prefactura prefactura = genericDao.get(Prefactura.class,
				genericDao.createFilter(FilterType.EQUALS, "numPrefactura", id));
		if(prefactura.getEstadoPrefactura() != null && prefactura.getEstadoPrefactura().getCodigo() != null ) {
			DDEstEstadoPrefactura estadoPrefactura = genericDao.get(DDEstEstadoPrefactura.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstEstadoPrefactura.CODIGO_VALIDA));
			prefactura.setEstadoPrefactura(estadoPrefactura);
			genericDao.update(Prefactura.class, prefactura);
		}else {
			return false;
		}
		return true;
	}
	
	@Transactional
	public Boolean validarTrabajo(Long id) {
		Prefactura prefactura = genericDao.get(Prefactura.class,
				genericDao.createFilter(FilterType.EQUALS, "numPrefactura", id));
		if(prefactura.getEstadoPrefactura() != null && prefactura.getEstadoPrefactura().getCodigo() != null ) {
			DDEstEstadoPrefactura estadoPrefactura = genericDao.get(DDEstEstadoPrefactura.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstEstadoPrefactura.CODIGO_VALIDA));
			prefactura.setEstadoPrefactura(estadoPrefactura);
			genericDao.update(Prefactura.class, prefactura);
		}else {
			return false;
		}
		return true;
	}
	
	public List<DDEstadoAlbaran> getComboEstadoAlbaran(){
		List<DDEstadoAlbaran> lista =  albaranDao.getComboEstadoAlbaran();
		return lista;
	}
	
	public List<DDEstEstadoPrefactura> getComboEstadoPrefactura(){
		List<DDEstEstadoPrefactura> lista =  albaranDao.getComboEstadoPrefactura();
		return lista;
	}
	
	public List<DDEstadoTrabajo> getComboEstadoTrabajo(){
		List<DDEstadoTrabajo> lista = albaranDao.getComboEstadoTrabajo();
		return lista;
	}

}
