package es.pfsgroup.plugin.rem.api.impl;

import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ReintegroApi;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ReintegroDto;

@Service("reintegroManager")
public class ReintegroManager extends BusinessOperationOverrider<ReintegroApi> implements ReintegroApi{

	
	protected static final Log logger = LogFactory.getLog(ReintegroManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Override
	public String managerName() {
		return "reintegroManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	
	
	

	@Override
	public HashMap<String, String> validateReintegroPostRequestData(ReintegroDto reintegroDto, Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = null;


		hashErrores = restApi.validateRequestObject(reintegroDto, TIPO_VALIDACION.INSERT);	

		if (!Checks.esNulo(reintegroDto.getOfertaHRE())) {
			Oferta ofertaHRE = ofertaApi.getOfertaByNumOfertaRem(reintegroDto.getOfertaHRE());
			if(Checks.esNulo(ofertaHRE)){
				hashErrores.put("ofertaHRE", RestApi.REST_MSG_UNKNOWN_KEY);			
			}else{
				if (!ofertaHRE.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_RECHAZADA)) {
					hashErrores.put("ofertaHRE", "La oferta no esta rechazada.");	
										
				}else{
					ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(ofertaHRE.getId());
					if (Checks.esNulo(expedienteComercial)) {
						hashErrores.put("ofertaHRE", "No existe expediente comercial para esta oferta");	
						
					}else if(Checks.esNulo(expedienteComercial.getEstado()) || 
							(!Checks.esNulo(expedienteComercial.getEstado()) && 
							!expedienteComercial.getEstado().getCodigo().equals(DDEstadosExpedienteComercial.ANULADO))){
						hashErrores.put("ofertaHRE", "El expediente comercial asociado a la oferta no esta Anulado.");
						
					}else{
						CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
						if(Checks.esNulo(condExp) || (!Checks.esNulo(condExp) && Checks.esNulo(condExp.getImporteReserva()))){
							hashErrores.put("ofertaHRE", "No se ha podido obtener el importe de la reserva del expediente comercial.");
						
						}else if(Checks.esNulo(expedienteComercial.getReserva())){
							hashErrores.put("ofertaHRE", "La oferta no tiene reserva, por tanto, no se puede hacer el reintegro de la reserva.");
							
						}else if(Checks.esNulo( expedienteComercial.getReserva().getEstadoReserva())){
							hashErrores.put("ofertaHRE", "Estado de la reserva desconocido.");
							
						}else if(expedienteComercial.getReserva().getEstadoReserva().getCodigo().equals(DDEstadosReserva.CODIGO_RESUELTA_REINTEGRADA)){
							hashErrores.put("ofertaHRE", "Ya se ha realizado el reintegro de la oferta.");
						
						}else if(!expedienteComercial.getReserva().getEstadoReserva().getCodigo().equals(DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION)){
							hashErrores.put("ofertaHRE", "La oferta no esta Pendiente de devolución.");
							
						}
					}
				}
			}
		}
			
		return hashErrores;
	}


}
