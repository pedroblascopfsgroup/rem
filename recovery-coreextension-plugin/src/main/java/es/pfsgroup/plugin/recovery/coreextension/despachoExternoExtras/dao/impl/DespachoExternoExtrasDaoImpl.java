package es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dao.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dao.DespachoExternoExtrasDao;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dto.DespachoExternoExtrasDto;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoExternoExtras;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoExtrasAmbito;

@Repository("DespachoExternoExtrasDao")
public class DespachoExternoExtrasDaoImpl extends AbstractEntityDao<DespachoExternoExtras, Long> implements DespachoExternoExtrasDao {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private CoreProjectContext context;
	
	public DespachoExternoExtrasDto getDtoDespachoExtras(Long idDespacho) {
		DespachoExternoExtrasDto despachoExtrasDto = new DespachoExternoExtrasDto();
		DespachoExternoExtras despachoExtras = genericDao.get(DespachoExternoExtras.class, genericDao.createFilter(FilterType.EQUALS, "id", idDespacho));
		
		if(Checks.esNulo(despachoExtras)) {
			return despachoExtrasDto;
		}
		
		despachoExtrasDto.setAsesoria(despachoExtras.isAsesoria() ? "Si" : "No");
		despachoExtrasDto.setCentroRecuperacion(despachoExtras.getCentroRecuperacion());
		despachoExtrasDto.setClasifDespachoConcursos(despachoExtras.isClasifConcursos() ? "Si" : "No");
		despachoExtrasDto.setClasifDespachoPerfil(context.getMapaClasificacionDespachoPerfil().get(despachoExtras.getClasifPerfil().toString()));
		despachoExtrasDto.setCodEstAse(context.getMapaCodEstAse().get(despachoExtras.getCodEstAse()));
		despachoExtrasDto.setContratoVigor(context.getMapaContratoVigor().get(despachoExtras.getContratoVigor().toString()));
		despachoExtrasDto.setCorreoElectronico(despachoExtras.getCorreoElectronico());
		despachoExtrasDto.setCuentaEntregas(despachoExtras.getCuentaEntregas());
		despachoExtrasDto.setCuentaLiquidacion(despachoExtras.getCuentaLiquidacion());
		despachoExtrasDto.setCuentaProvisiones(despachoExtras.getCuentaProvisiones());
		despachoExtrasDto.setDigconEntregas(despachoExtras.getDigconEntregas());
		despachoExtrasDto.setDigconLiquidacion(despachoExtras.getDigconLiquidacion());
		despachoExtrasDto.setDigconProvisiones(despachoExtras.getDigconProvisiones());
		despachoExtrasDto.setDocumentoCif(despachoExtras.getDocumentoCif());
		despachoExtrasDto.setEntidadContacto(despachoExtras.getEntidadContacto());
		despachoExtrasDto.setEntidadEntregas(despachoExtras.getEntidadEntregas());
		despachoExtrasDto.setEntidadLiquidacion(despachoExtras.getEntidadLiquidacion());
		despachoExtrasDto.setEntidadProvisiones(despachoExtras.getEntidadProvisiones());
		despachoExtrasDto.setFax(despachoExtras.getFax());
		despachoExtrasDto.setFechaAlta(!Checks.esNulo(despachoExtras.getFechaAlta()) ? formateoFecha(despachoExtras.getFechaAlta()) : null);
		despachoExtrasDto.setFechaServicioIntegral(!Checks.esNulo(despachoExtras.getFechaServicioIntegral()) ? formateoFecha(despachoExtras.getFechaServicioIntegral()) : null);
		despachoExtrasDto.setIrpfAplicado(!Checks.esNulo(despachoExtras.getIrpf()) ? despachoExtras.getIrpf().toString() : null);
		despachoExtrasDto.setIvaDescripcion(context.getMapaDescripcionIVA().get(despachoExtras.getDescripcionIVA()));
		despachoExtrasDto.setOficinaContacto(despachoExtras.getOficinaContacto());
		despachoExtrasDto.setOficinaEntregas(despachoExtras.getOficinaEntregas());
		despachoExtrasDto.setOficinaLiquidacion(despachoExtras.getOficinaContacto());
		despachoExtrasDto.setOficinaProvisiones(despachoExtras.getOficinaProvisiones());
		despachoExtrasDto.setRelacionBankia(context.getMapaRelacionBankia().get(despachoExtras.getRelacionBankia().toString()));
		despachoExtrasDto.setServicioIntegral(despachoExtras.isServicioIntegral() ? "Si" : "No");
		despachoExtrasDto.setTipoDoc(despachoExtras.getTipoDocumento());
		
		return despachoExtrasDto;
	}
	
	private String formateoFecha(Date fecha) {

		SimpleDateFormat formateador = new SimpleDateFormat("dd/MM/yyyy");
		
		return formateador.format(fecha);
	}
	
	public List<DDProvincia> getProvinciasDespachoExtras(Long idDespacho) {
		Order order = new Order(OrderType.ASC, "provincia.descripcion");
		List<DespachoExtrasAmbito> listaAmbito = genericDao.getListOrdered(DespachoExtrasAmbito.class,order, genericDao.createFilter(FilterType.EQUALS, "despacho.id", idDespacho));
		List<DDProvincia> listaProvincias = new ArrayList<DDProvincia>();
		
		for(DespachoExtrasAmbito ambito: listaAmbito) {
			if(!Checks.esNulo(ambito.getProvincia())) {
				listaProvincias.add(ambito.getProvincia());
			}
		}
		
		return listaProvincias;
	}

}
