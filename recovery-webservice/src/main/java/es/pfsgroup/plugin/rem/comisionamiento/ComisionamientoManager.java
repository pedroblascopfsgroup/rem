package es.pfsgroup.plugin.rem.comisionamiento;

import java.io.IOException;


import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.rem.comisionamiento.dto.ConsultaComisionDto;
import es.pfsgroup.plugin.rem.comisionamiento.dto.RespuestaComisionDto;
import es.pfsgroup.plugin.rem.microservicios.ClienteMicroservicioGenerico;
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import net.sf.json.JSONObject;

@Service("comisionamientoManager")
public class ComisionamientoManager implements ComisionamientoApi {

	@Autowired
	private ClienteMicroservicioGenerico microservicio;

	ObjectMapper mapper = new ObjectMapper();
	
	@Override
	public RespuestaComisionDto createCommission(ConsultaComisionDto parametros)
			throws JsonGenerationException, JsonMappingException, IOException, HttpClientException, NumberFormatException, RestConfigurationException {
		
		//Al hacer los mapeos todo tiene que estar con los nombres de los objetos del microservicio?
		
		//Dto que hay que mandar
		//{ "refId" : "a7c7b427-4ae4-4766-9596-d88e0f12cd6b", "leadOrigin" : "01", "amount" : 1500000, "offerType": "01", "comercialType": "02" }
		
		String jsonString = mapper.writeValueAsString(parametros);
		JSONObject response = microservicio.send("POST", "commissions", jsonString);
		
		//Dto que nos va a devolver
		/*{
		  "result": [
		    {
		      "rule": {
		        "id": "RULE-05",
		        "leadOrigin": "01",
		        "assetType": "",
		        "assetSubtype": "",
		        "offerType": "01",
		        "commissionType": "Prescripción",
		        "comercialType": "02",
		        "stretchMin": 1000000,
		        "stretchMax": 2000000,
		        "commissionPercentage": 0.9,
		        "maxCommissionAmount": 18000,
		        "minCommissionAmount": 0
		      },
		      "amount": 13500
		    }
		  ],
		  "headers": {},
		  "id": "eabd391e-2be9-4b0b-8ab3-5f0cb1333377",
		  "body": {
		    "refId": "a7c7b427-4ae4-4766-9596-d88e0f12cd6b",
		    "amount": 1500000,
		    "leadOrigin": "01",
		    "offerType": "01",
		    "comercialType": "02"
		  },
		  "commissionId": "a7c7b427-4ae4-4766-9596-d88e0f12cd6b"
		}*/
		
		//readValue o readValues?
		return  mapper.readValue(response.toString(), RespuestaComisionDto.class);
	}
}
