package es.pfsgroup.plugin.rem.comisionamiento;

import java.io.IOException;
import java.math.BigDecimal;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.comisionamiento.dto.ConsultaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionResultDto;
import es.pfsgroup.plugin.rem.microservicios.ClienteMicroservicioGenerico;
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
		JSONObject response = microservicio.send("POST", "commissions", jsonString);
		
		RespuestaComisionDto respuestaMS = mapper.readValue(response.toString(), RespuestaComisionDto.class);
		
		String respuestaMSString = mapper.writeValueAsString(respuestaMS.getResult());
		respuestaDto = mapper.readValue(respuestaMSString, RespuestaComisionResultDto.class);
		
		return respuestaDto;
	}
}
