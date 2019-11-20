package es.pfsgroup.plugin.rem.comisionamiento;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.comisionamiento.dto.ConsultaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionResultDto;
import es.pfsgroup.plugin.rem.microservicios.ClienteMicroservicioGenerico;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
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
	public RespuestaComisionResultDto createCommission(ConsultaComisionDto parametros, String accion)
			throws JsonGenerationException, JsonMappingException, IOException, HttpClientException, NumberFormatException, RestConfigurationException, HttpsClientException {
		
		BigDecimal respuesta = null;
		RespuestaComisionResultDto respuestaDto = null;
		
		String jsonString = mapper.writeValueAsString(parametros);
		JSONObject response = microservicio.send("POST", "commissions", jsonString);
		
		RespuestaComisionDto respuestaMS = mapper.readValue(response.toString(), RespuestaComisionDto.class);
		
		String respuestaMSString = mapper.writeValueAsString(respuestaMS.getResult());
		//El result que hay en la respuesta hay que tratarlo como una lista.
		List<RespuestaComisionResultDto> listaResult = mapper.readValue(respuestaMSString, new TypeReference<List<RespuestaComisionResultDto>>(){});
		for (RespuestaComisionResultDto result : listaResult) {
			if(!Checks.esNulo(result.getAmount()) && !Checks.esNulo(result.getRule()) && !Checks.esNulo(result.getRule().getCommissionType())) {
				
				if(accion.equals(DDAccionGastos.CODIGO_PRESCRIPCION) && result.getRule().getCommissionType().equals("PRESCRIPCION")){
					respuesta = new BigDecimal(result.getRule().getCommissionPercentage());
					respuestaDto = result;
					break;
				}
				
				if (accion.equals(DDAccionGastos.CODIGO_COLABORACION) && result.getRule().getCommissionType().equals("CUSTODIA")){
					respuesta = new BigDecimal(result.getRule().getCommissionPercentage());
					respuestaDto = result;
					break;
				}
				
				
			}
		}
		
		return respuestaDto;
	}
}
