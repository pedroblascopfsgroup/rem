package es.pfsgroup.plugin.rem.comisionamiento;

import java.io.IOException;
import java.io.Serializable;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.comisionamiento.dto.ConsultaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionDto;
import es.pfsgroup.plugin.rem.microservicios.Cliente;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;

@Service("comisionamientoManager")
public class ComisionamientoManager implements ComisionamientoApi {

	@Autowired
	Cliente cliente;

	ObjectMapper mapper = new ObjectMapper();
	
	@Override
	public RespuestaComisionDto calcularHonorarios(ConsultaComisionDto parametros)
			throws JsonGenerationException, JsonMappingException, IOException, HttpClientException {
		String respuesta = cliente.send((Serializable) parametros, "POST", "http://test.com");
		
		return mapper.readValue(respuesta, RespuestaComisionDto.class);
	}

}
