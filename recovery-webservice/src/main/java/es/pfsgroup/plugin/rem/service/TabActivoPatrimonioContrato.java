package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.aspectj.apache.bcel.generic.IF_ACMPEQ;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.annotation.JsonTypeInfo.Id;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioContratoDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

@Component
public class TabActivoPatrimonioContrato implements TabActivoService {

	@Autowired
	private ActivoPatrimonioContratoDao activoPatrimonioDao;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_PATRIMONIO_CONTRATO};
	}

	public DtoActivoPatrimonioContrato getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		DtoActivoPatrimonioContrato activoPatrimonioContratoDto = new DtoActivoPatrimonioContrato();		
		List<ActivoPatrimonioContrato> listActivoPatrimonioContrato = activoPatrimonioDao.getActivoPatrimonioContratoByActivo(activo.getId());
		ActivoPatrimonio activoP = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
		List<Oferta> listadoOfertas = ofertaApi.getListaOfertasByActivo(activo); //Listado de ofertas del activo
		
		if(!Checks.estaVacio(listActivoPatrimonioContrato)) {
			ActivoPatrimonioContrato activoPatrimonioContrato = listActivoPatrimonioContrato.get(0);
			if(!Checks.esNulo(activoPatrimonioContrato.getEstadoContrato())) {
				BeanUtils.copyProperties(activoPatrimonioContratoDto, activoPatrimonioContrato);
				if(!Checks.esNulo(activoPatrimonioContrato.getActivo())) {
					activoPatrimonioContratoDto.setIdActivo(activoPatrimonioContrato.getActivo().getId());
				}
			}	
			activoPatrimonioContratoDto.setMultiplesResultados(listActivoPatrimonioContrato.size() > 1);
			activoPatrimonioContratoDto.setTieneRegistro(listActivoPatrimonioContrato.size() >= 1); //Tiene más de un registro
			if (activoP.getSuborigenContrato() != null) {
				activoPatrimonioContratoDto.setSuborigenContrato(activoP.getSuborigenContrato().getCodigo());
				activoPatrimonioContratoDto.setSuborigenContratoDescripcion(activoP.getSuborigenContrato().getDescripcion());
			}
			if (activoP.getFechaObligadoCumplimiento() != null) {
				activoPatrimonioContratoDto.setFechaObligadoCumplimiento(activoP.getFechaObligadoCumplimiento());
			}
			if (activoP.getFianzaObligatoria() != null) {
				activoPatrimonioContratoDto.setFianzaObligatoria(activoP.getFianzaObligatoria());
			}
			if (activoP.getFechaAvalBancario() != null) {
				activoPatrimonioContratoDto.setFechaAvalBancario(activoP.getFechaAvalBancario());
			}
			if (activoP.getImporteAvalBancario() != null) {
				activoPatrimonioContratoDto.setImporteAvalBancario(activoP.getImporteAvalBancario());
			}
			if (activoP.getImporteDepositoBancario() != null) {
				activoPatrimonioContratoDto.setImporteDepositoBancario(activoP.getImporteDepositoBancario());
			}
		}
		
		if(!Checks.estaVacio(listadoOfertas)) {
			String idContrato = activoPatrimonioContratoDto.getIdContrato(); 
			
			if(!Checks.esNulo(idContrato)) {
				activoPatrimonioContratoDto.setEsDivarian((DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())
						|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo())));
				activoPatrimonioContratoDto.setIdContratoAntiguo(activoPatrimonioContratoDto.getIdContratoAntiguo()); 
				
				
				ExpedienteComercial aux = null;
				for (Oferta oferta : listadoOfertas) {	//Lista de ofertas del activo con un expediente relacionado
					ExpedienteComercial expComercial = expedienteComercialApi.findOneByOferta(oferta);
					if(!Checks.esNulo(expComercial)) {
						String numContratoAlquiler = expComercial.getNumContratoAlquiler(); 
						if(!Checks.esNulo(numContratoAlquiler)) {
							if(numContratoAlquiler.equals(idContrato)) { //Expedientes con el mismo contrato que el activo
								if(Checks.esNulo(aux)) {
									aux = expComercial;
								} else {
									if(aux != null && !Checks.esNulo(aux.getFechaVenta()) && aux.getFechaVenta().before(expComercial.getFechaVenta())) { //Nos quedamos con el más reciente
										aux = expComercial;
									}
								}
							}
						}
					}
				}
				if(aux != null) {
					activoPatrimonioContratoDto.setOfertaREM(aux.getOferta().getNumOferta());
					activoPatrimonioContratoDto.setIdExpediente(aux.getId());
				}
			}
		}
		
		if (activo != null) {
			activoPatrimonioContratoDto.setIsCarteraCajamar(DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo()));
			activoPatrimonioContratoDto.setIsCarteraCajamar(DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo()));
		}
		
		return activoPatrimonioContratoDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {
		// TODO Auto-generated method stub
		return null;
	}
}
