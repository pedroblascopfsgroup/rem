package es.pfsgroup.plugin.rem.api.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.AnulacionesApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.AnulacionDto;
import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpDto;

@Service("anulacionesManager")
public class AnulacionesManager extends BusinessOperationOverrider<AnulacionesApi> implements AnulacionesApi {

	protected static final Log logger = LogFactory.getLog(AnulacionesManager.class);

	@Autowired
	private RestApi restApi;
	@Autowired
	private OfertaApi ofertaApi;
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Override
	public String managerName() {
		return "anulacionManager";
	}

	@Override
	public HashMap<String, String> validateAnulacionCobroReservaPostRequestData(AnulacionDto anulacionDto,
			Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = restApi.validateRequestObject(anulacionDto, TIPO_VALIDACION.INSERT);
		if (!Checks.esNulo(anulacionDto.getOfertaHRE())) {
			Oferta ofertaHRE = ofertaApi.getOfertaByNumOfertaRem(anulacionDto.getOfertaHRE());
			if (Checks.esNulo(ofertaHRE)) {
				hashErrores.put("ofertaHRE", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				ExpedienteComercial expedienteComercial = expedienteComercialApi
						.expedienteComercialPorOferta(ofertaHRE.getId());
				if (Checks.esNulo(expedienteComercial)) {
					hashErrores.put("ofertaHRE", "No existe expediente comercial para esta oferta");

				}else{
					if(expedienteComercial.getReserva()!=null && expedienteComercial.getReserva().getFechaFirma() !=null){
						if(!isSameDay(new Date(), expedienteComercial.getReserva().getFechaFirma())){
							hashErrores.put("ofertaHRE", "Solo se puede anular la reserva el mismo dia que se realizo");
						}else{
							
						}
					}else{
						hashErrores.put("ofertaHRE", "El expediente comercial no tiene reserva para anular");
					}					
				}
			}
		}
		return hashErrores;
	}

	@Override
	public HashMap<String, String> validateAnulacionCobroVentaPostRequestData(AnulacionDto anulacionDto,
			Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = restApi.validateRequestObject(anulacionDto, TIPO_VALIDACION.INSERT);
		if (!Checks.esNulo(anulacionDto.getOfertaHRE())) {
			Oferta ofertaHRE = ofertaApi.getOfertaByNumOfertaRem(anulacionDto.getOfertaHRE());
			if (Checks.esNulo(ofertaHRE)) {
				hashErrores.put("ofertaHRE", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				ExpedienteComercial expedienteComercial = expedienteComercialApi
						.expedienteComercialPorOferta(ofertaHRE.getId());
				if (Checks.esNulo(expedienteComercial)) {
					hashErrores.put("ofertaHRE", "No existe expediente comercial para esta oferta");

				}
			}
		}
		return hashErrores;
	}

	@Override
	public HashMap<String, String> validateAnulacionDevolucionReservaPostRequestData(AnulacionDto anulacionDto,
			Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = restApi.validateRequestObject(anulacionDto, TIPO_VALIDACION.INSERT);
		if (!Checks.esNulo(anulacionDto.getOfertaHRE())) {
			Oferta ofertaHRE = ofertaApi.getOfertaByNumOfertaRem(anulacionDto.getOfertaHRE());
			if (Checks.esNulo(ofertaHRE)) {
				hashErrores.put("ofertaHRE", RestApi.REST_MSG_UNKNOWN_KEY);
			} else {
				ExpedienteComercial expedienteComercial = expedienteComercialApi
						.expedienteComercialPorOferta(ofertaHRE.getId());
				if (Checks.esNulo(expedienteComercial)) {
					hashErrores.put("ofertaHRE", "No existe expediente comercial para esta oferta");

				}
			}
		}
		return hashErrores;
	}

	@Override
	public void anularCobroReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void anularCobroVenta(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void anularDevolucionReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		// TODO Auto-generated method stub

	}

	private boolean isSameDay(Date date1, Date date2) {
		Calendar cal1 = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		cal1.setTime(date1);
		cal2.setTime(date2);
		return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR)
				&& cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR);
	}

}