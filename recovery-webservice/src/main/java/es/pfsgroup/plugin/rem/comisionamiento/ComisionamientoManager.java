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
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoPrescriptoresComision;
import es.pfsgroup.plugin.rem.model.Oferta;
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
		
		DtoPrescriptoresComision dto = new DtoPrescriptoresComision();
		
		Long prescriptorVisita = oferta.getProveedorPrescriptorRemOrigenLead().getId();
		Long realizadorVisita = oferta.getProveedorRealizadorRemOrigenLead().getId();
		
		if(prescriptorVisita == null
				|| realizadorVisita == null
				|| oferta.getFechaOrigenLead() == null
				|| oferta.getFechaAlta() == null) {
			return null;
		}
		
		Long prescriptorOferta = oferta.getPrescriptor().getId();
		String codLeadOrigin = null;
		Long diferenciaFechaVisitaYAlta = Math.abs((oferta.getFechaOrigenLead().getTime()-oferta.getFechaAlta().getTime())/86400000);
		
		if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getOrigenComprador())) {
			codLeadOrigin = oferta.getOrigenComprador().getCodigo();
		} else if (!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getVisita()) && !Checks.esNulo(oferta.getVisita().getOrigenComprador())) {
			codLeadOrigin = oferta.getVisita().getOrigenComprador().getCodigo();
		} else {
			codLeadOrigin = DDOrigenComprador.CODIGO_ORC_HRE;
		}
		
		if(prescriptorOferta.equals(prescriptorVisita) && prescriptorOferta.equals(realizadorVisita)) {
			dto.setPrescriptorCodRem(prescriptorOferta);
			dto.setTipoAccion(DDAccionGastos.CODIGO_PRE_Y_COL);
			
			if(DDOrigenComprador.CODIGO_ORC_API_AJENO.equals(codLeadOrigin)) {
				
				if(diferenciaFechaVisitaYAlta > 90L) {
					dto.setOrigenLead(DDOrigenComprador.CODIGO_ORC_API_PROPIO);
					
					listAcciones.add(dto);
				}else {
					dto.setOrigenLead(codLeadOrigin);
					
					listAcciones.add(dto);
					
					dto = new DtoPrescriptoresComision();
					
					dto.setPrescriptorCodRem(prescriptorVisita);
					dto.setTipoAccion(DDAccionGastos.CODIGO_API_ORI_LEA_PRP);
					dto.setOrigenLead(codLeadOrigin);
					listAcciones.add(dto);
				}
			}
		} else if(prescriptorOferta.equals(prescriptorVisita) && !prescriptorOferta.equals(realizadorVisita)
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
				
				dto = new DtoPrescriptoresComision();
				
				dto.setPrescriptorCodRem(prescriptorOferta);
				dto.setTipoAccion(DDAccionGastos.CODIGO_PRE_Y_COL);
				dto.setOrigenLead(codLeadOrigin);
				
				listAcciones.add(dto);
				
				if(diferenciaFechaVisitaYAlta <= 90L) {
					
					dto = new DtoPrescriptoresComision();
					
					dto.setPrescriptorCodRem(prescriptorVisita);
					dto.setTipoAccion(DDAccionGastos.CODIGO_API_ORI_LEA_PP);
					dto.setOrigenLead(codLeadOrigin);
					
					listAcciones.add(dto);
				}
			}
		}
		
		
		
		return listAcciones;
	}
}
