package es.pfsgroup.plugin.rem.comisionamiento;

import java.io.IOException;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

import es.pfsgroup.plugin.rem.comisionamiento.dto.ConsultaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionResultDto;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpsclient.HttpsClientException;

public interface ComisionamientoApi {

	public RespuestaComisionResultDto createCommission(ConsultaComisionDto parametros)
			throws JsonGenerationException, JsonMappingException, IOException, HttpClientException, NumberFormatException, RestConfigurationException, HttpsClientException;

	Double calculaHonorario(RespuestaComisionResultDto dto);

	Double calculaImporteCalculo(Double importeOferta, Double comision);

}
