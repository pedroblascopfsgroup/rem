package es.pfsgroup.plugin.rem.rest.api.impl;

import java.io.IOException;
import java.util.Date;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.dto.AuthtokenRequest;
import es.pfsgroup.plugin.rem.rest.dto.AuthtokenResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileId;
import es.pfsgroup.plugin.rem.rest.dto.FileList;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileSearch;
import es.pfsgroup.plugin.rem.rest.dto.FileUpload;
import es.pfsgroup.plugin.rem.rest.dto.OperationResult;
import es.pfsgroup.plugin.rem.rest.dto.ResponseGestorDocumentalFotos;
import es.pfsgroup.plugin.rem.restclient.exception.AuthTokenExpiredException;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebComGestorDocumental;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;
import net.sf.json.JSONObject;

@Service("gestorDocumentalFotos")
public class GestorDocumentalFotos implements GestorDocumentalFotosApi {

	private static String ID_AUTH_TOKEN = "idAuthToken";
	private static String GET_AUTHTOKEN_ENDPOINT = "getAuthtoken/";
	private static String UPLOAD_ENDPOINT = "upload/";
	private static String DELETE_ENDPOINT = "delete/";
	private static String FILE_SEARCH_ENDPOINT = "delete/";
	
	@Autowired
	private ClienteWebComGestorDocumental cliente;

	@Autowired
	private ServletContext servletContext;

	ObjectMapper mapper = new ObjectMapper();

	@Resource
	private Properties appProperties;

	@Override
	public boolean isActive() {
		// TODO Auto-generated method stub
		return false;
	}

	private String send(String endpoint, String jsonString) throws Exception {
		return this.send(endpoint, jsonString, null);
	}

	private String send(String endpoint, String jsonString, String authtoken) throws Exception {
		System.out.println("enviando: "+jsonString);
		JSONObject resultado = cliente.send(authtoken, endpoint, jsonString);
		if (resultado.containsKey("error")) {
			if (resultado.getString("error") != null
					&& resultado.getString("error").equals(ResponseGestorDocumentalFotos.ACCESS_DENIED)) {
				throw new AuthTokenExpiredException();
			}
		}
		System.out.println("reci: "+resultado.toString());
		return resultado.toString();
	}

	private AuthtokenResponse getAuthtoken()
			throws JsonGenerationException, JsonMappingException, IOException, Exception {
		AuthtokenRequest request = new AuthtokenRequest();
		request.setApp_id(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.APP_ID_GESTOR_DOCUMENTAL, "3"));
		request.setApp_secret(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.APP_SECRET_GESTOR_DOCUMENTAL,
				"z[99I(sZluG){yfCdd]xO_eb-(A9Wxof{C{sZ_Tr2h/MLT$D=VH9T)bRCl1IY7ANd&W{qPeIPf[y(NuqbgtvpS4r3PI[}z)?J-[36fw=&M]60"));
		String jsonResponse = null;
		AuthtokenResponse response = null;
		try {
			if (servletContext.getAttribute(ID_AUTH_TOKEN) != null) {
				response = (AuthtokenResponse) servletContext.getAttribute(ID_AUTH_TOKEN);
				if (response.getData().getExpires().compareTo(new Date()) < 0) {
					// lo obtenemos
					jsonResponse = this.send(GET_AUTHTOKEN_ENDPOINT, mapper.writeValueAsString(request));
					response = mapper.readValue(jsonResponse, AuthtokenResponse.class);
					servletContext.setAttribute(ID_AUTH_TOKEN, response);
				}
			} else {
				// lo obtenemos
				jsonResponse = this.send(GET_AUTHTOKEN_ENDPOINT, mapper.writeValueAsString(request));
				response = mapper.readValue(jsonResponse, AuthtokenResponse.class);
				servletContext.setAttribute(ID_AUTH_TOKEN, response);
			}
		} catch (AuthTokenExpiredException exToken) {
			throw new Exception("El app_id no esta dado d alta o el app_secret es incorrecto");
		}
		return response;
	}

	@Override
	public FileResponse upload(FileUpload file, java.io.File fileToUpload)
			throws JsonGenerationException, JsonMappingException, IOException, Exception {
		file.setFile_base64(FileUtilsREM.base64Encode(fileToUpload));
		return this.upload(file);
	}

	@Override
	public FileResponse upload(FileUpload file) throws JsonGenerationException, JsonMappingException, IOException, Exception {
		AuthtokenResponse authToken = this.getAuthtoken();
		String jsonResponse = null;
		try {
			jsonResponse = this.send(UPLOAD_ENDPOINT, mapper.writeValueAsString(file), authToken.getData().getAuthtoken());
		} catch (AuthTokenExpiredException exp) {
			authToken = this.getAuthtoken();
			jsonResponse = this.send(UPLOAD_ENDPOINT, mapper.writeValueAsString(file), authToken.getData().getAuthtoken());
		}
		return mapper.readValue(jsonResponse, FileResponse.class);
	}

	@Override
	public OperationResult delete(Integer fileId)
			throws JsonGenerationException, JsonMappingException, IOException, Exception {
		AuthtokenResponse authToken = this.getAuthtoken();
		String jsonResponse = null;
		FileId fileToDelete = new FileId();
		fileToDelete.setId(fileId);
		try {
			jsonResponse = this.send(DELETE_ENDPOINT, mapper.writeValueAsString(fileToDelete),
					authToken.getData().getAuthtoken());
		} catch (AuthTokenExpiredException exp) {
			authToken = this.getAuthtoken();
			jsonResponse = this.send(DELETE_ENDPOINT, mapper.writeValueAsString(fileToDelete),
					authToken.getData().getAuthtoken());
		}
		return mapper.readValue(jsonResponse, OperationResult.class);
	}

	@Override
	public FileListResponse get(FileSearch fileSearch)
			throws JsonGenerationException, JsonMappingException, IOException, Exception {
		AuthtokenResponse authToken = this.getAuthtoken();
		String jsonResponse = null;
		try {
			jsonResponse = this.send(FILE_SEARCH_ENDPOINT, mapper.writeValueAsString(fileSearch),
					authToken.getData().getAuthtoken());
		} catch (AuthTokenExpiredException exp) {
			authToken = this.getAuthtoken();
			jsonResponse = this.send(FILE_SEARCH_ENDPOINT, mapper.writeValueAsString(fileSearch),
					authToken.getData().getAuthtoken());
		}
		return mapper.readValue(jsonResponse, FileListResponse.class);
	}

}
