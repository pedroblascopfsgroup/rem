package es.pfsgroup.plugin.rem.comisionamiento;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.comisionamiento.dto.ConsultaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionResultDto;
import es.pfsgroup.plugin.rem.microservicios.ClienteMicroservicioGenerico;
import es.pfsgroup.plugin.rem.model.DtoPrescriptoresComision;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenComprador;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpsclient.HttpsClientException;
import net.sf.json.JSONObject;

@Service("comisionamientoManager")
public class ComisionamientoManager implements ComisionamientoApi {

	@Autowired
	private ClienteMicroservicioGenerico microservicio;

	ObjectMapper mapper = new ObjectMapper();
	
	@SuppressWarnings("unused")
	@Override
	public RespuestaComisionResultDto createCommission(ConsultaComisionDto parametros)
			throws JsonGenerationException, JsonMappingException, IOException, HttpClientException, NumberFormatException, RestConfigurationException, HttpsClientException {
		
		BigDecimal respuesta = null;
		RespuestaComisionResultDto respuestaDto = null;
		
		String jsonString = mapper.writeValueAsString(parametros);
		JSONObject response = microservicio.send("POST", "commissions/calculate", jsonString);
		
		RespuestaComisionDto respuestaMS = mapper.readValue(response.toString(), RespuestaComisionDto.class);
		
		String respuestaMSString = mapper.writeValueAsString(respuestaMS.getResult());
		respuestaDto = mapper.readValue(respuestaMSString, RespuestaComisionResultDto.class);
		
		return respuestaDto;
	}
	
	@Override
	public Double calculaHonorario(RespuestaComisionResultDto dto) {
		
		if(dto.getCommissionAmount() < dto.getMinCommissionAmount()) {
			return dto.getMinCommissionAmount();
		} else if(dto.getCommissionAmount() >= dto.getMinCommissionAmount()
				&& dto.getCommissionAmount() <= dto.getMaxCommissionAmount()) {
			return dto.getCommissionAmount();
		}else if(dto.getCommissionAmount() > dto.getMaxCommissionAmount()) {
			return dto.getMaxCommissionAmount();
		}
		
		return 0d;
	}
	
	@Override
	public Double calculaImporteCalculo(Double importeOferta, Double comision) {
		return (100d*comision)/importeOferta;
	}
	
	@Override
	public List<DtoPrescriptoresComision> getTiposDeComisionAccionGasto(Oferta oferta){
		List<DtoPrescriptoresComision> listAcciones = new ArrayList<DtoPrescriptoresComision>();
		
		Visita visita = oferta.getVisita();
		
		DtoPrescriptoresComision dtoOriginal = new DtoPrescriptoresComision();
				
		Long prescriptorVisita = (visita == null || visita.getPrescriptor() == null) ? null : visita.getPrescriptor().getId();
		Long realizadorVisita = (visita == null || visita.getProveedorVisita() == null) ? null : visita.getProveedorVisita().getId();
		Long prescriptorOferta = oferta.getPrescriptor().getId();
		
		dtoOriginal.setProviderType((visita == null || visita.getProveedorPrescriptorOportunidad() == null) ? null
				: visita.getProveedorPrescriptorOportunidad().getCodigoProveedorRem().toString());
		dtoOriginal.setVisitPrescriber((visita == null || visita.getPrescriptor() == null) ? null 
				: visita.getPrescriptor().getCodigoProveedorRem().toString());
		dtoOriginal.setVisitMaker((visita == null || visita.getProveedorVisita() == null) ? null
				: visita.getProveedorVisita().getCodigoProveedorRem().toString()); 
		dtoOriginal.setOfferPrescriber(oferta.getPrescriptor().getCodigoProveedorRem().toString());
		
		String codLeadOrigin = null;
		
		if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getOrigenComprador())) {
			codLeadOrigin = oferta.getOrigenComprador().getCodigo();
		} else if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getVisita()) && !Checks.esNulo(oferta.getVisita().getOrigenComprador())) {
			codLeadOrigin = oferta.getVisita().getOrigenComprador().getCodigo();
		} else {
			codLeadOrigin = DDOrigenComprador.CODIGO_ORC_HRE;
		}
		
		DtoPrescriptoresComision dto = dtoOriginal;
		
		if(prescriptorOferta != null && (prescriptorVisita == null || realizadorVisita == null)) {
			dto.setPrescriptorCodRem(prescriptorOferta);
			dto.setTipoAccion(DDAccionGastos.CODIGO_PRESCRIPCION);
			dto.setOrigenLead(codLeadOrigin);
			
			listAcciones.add(dto);
			
			return listAcciones;
		}
		
		Long diferenciaFechaVisitaYAlta = null;
		
		if(visita.getFechaVisita() != null
				&& oferta.getFechaAlta() != null) {
			diferenciaFechaVisitaYAlta = Math.abs((visita.getFechaVisita().getTime()-oferta.getFechaAlta().getTime())/86400000);
		}
		
		if(prescriptorOferta.equals(prescriptorVisita) && prescriptorOferta.equals(realizadorVisita)) {
			dto.setPrescriptorCodRem(prescriptorOferta);
			dto.setTipoAccion(DDAccionGastos.CODIGO_PRE_Y_COL);
			
			if(DDOrigenComprador.CODIGO_ORC_API_AJENO.equals(codLeadOrigin) && diferenciaFechaVisitaYAlta != null) {
				
				if(diferenciaFechaVisitaYAlta > 90L) {
					dto.setOrigenLead(DDOrigenComprador.CODIGO_ORC_API_PROPIO);
					
					listAcciones.add(dto);
				}else {
					dto.setOrigenLead(codLeadOrigin);
					
					listAcciones.add(dto);
					
					dto = dtoOriginal;
					
					dto.setPrescriptorCodRem(prescriptorVisita);
					dto.setTipoAccion(DDAccionGastos.CODIGO_API_ORI_LEA);
					dto.setOrigenLead(codLeadOrigin);
					listAcciones.add(dto);
				}
			}else {
				dto.setOrigenLead(codLeadOrigin);
				
				listAcciones.add(dto);
			}
		} else if(!prescriptorOferta.equals(prescriptorVisita) && prescriptorOferta.equals(realizadorVisita)
				&& DDOrigenComprador.CODIGO_ORC_HRE.equals(codLeadOrigin)) {
			dto.setPrescriptorCodRem(prescriptorOferta);
			dto.setTipoAccion(DDAccionGastos.CODIGO_COLABORACION);
			dto.setOrigenLead(codLeadOrigin);
			
			listAcciones.add(dto);
			
		} else if(prescriptorOferta.equals(prescriptorVisita) && !prescriptorOferta.equals(realizadorVisita)) {
			dto.setPrescriptorCodRem(realizadorVisita);
			dto.setTipoAccion(DDAccionGastos.CODIGO_COLABORACION);
			dto.setOrigenLead(codLeadOrigin);
			
			listAcciones.add(dto);
			
			if(DDOrigenComprador.CODIGO_ORC_API_AJENO.equals(codLeadOrigin)) {
				
				dto = dtoOriginal;
				
				dto.setPrescriptorCodRem(prescriptorOferta);
				dto.setTipoAccion(DDAccionGastos.CODIGO_PRE_Y_COL);
				dto.setOrigenLead(codLeadOrigin);
				
				listAcciones.add(dto);
				
				if(diferenciaFechaVisitaYAlta != null && diferenciaFechaVisitaYAlta <= 90L) {
					
					dto = dtoOriginal;
					
					dto.setPrescriptorCodRem(prescriptorVisita);
					dto.setTipoAccion(DDAccionGastos.CODIGO_API_ORI_LEA);
					dto.setOrigenLead(codLeadOrigin);
					
					listAcciones.add(dto);
				} else {
					List<DtoPrescriptoresComision> listaSup = new ArrayList<DtoPrescriptoresComision>();
					
					for(DtoPrescriptoresComision dtoLista: listAcciones) {
						dtoLista.setOrigenLead(DDOrigenComprador.CODIGO_ORC_API_PROPIO);
						
						listaSup.add(dtoLista);
					}
					
					listAcciones = listaSup;
				}
			}
		}
		
		
		
		return listAcciones;
	}
}
