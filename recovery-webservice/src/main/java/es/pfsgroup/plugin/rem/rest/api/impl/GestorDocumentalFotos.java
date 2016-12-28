package es.pfsgroup.plugin.rem.rest.api.impl;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.dto.AuthtokenRequest;
import es.pfsgroup.plugin.rem.rest.dto.AuthtokenResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileId;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileSearch;
import es.pfsgroup.plugin.rem.rest.dto.FileUpload;
import es.pfsgroup.plugin.rem.rest.dto.OperationResultResponse;
import es.pfsgroup.plugin.rem.rest.dto.ResponseGestorDocumentalFotos;
import es.pfsgroup.plugin.rem.restclient.exception.AccesDeniedException;
import es.pfsgroup.plugin.rem.restclient.exception.FileErrorException;
import es.pfsgroup.plugin.rem.restclient.exception.InvalidJsonException;
import es.pfsgroup.plugin.rem.restclient.exception.MissingRequiredFieldsException;
import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.exception.UnknownIdException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
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
	private static String FILE_SEARCH_ENDPOINT = "get/";

	@Autowired
	private ClienteWebComGestorDocumental cliente;

	@Autowired
	private ServletContext servletContext;

	ObjectMapper mapper = new ObjectMapper();

	@Resource
	private Properties appProperties;

	@Override
	public boolean isActive() {
		return true;
	}

	private String send(String endpoint, String jsonString)
			throws RestClientException, HttpClientException, IOException {
		AuthtokenResponse authToken = this.getAuthtoken();
		System.out.println("enviando: " + jsonString);
		JSONObject resultado = cliente.send(authToken.getData().getAuthtoken(), endpoint, jsonString);
		if (resultado.containsKey("error") && resultado.getString("error") != null) {
			if (resultado.getString("error").equals(ResponseGestorDocumentalFotos.ACCESS_DENIED)) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				authToken = this.getAuthtoken();
				resultado = cliente.send(authToken.getData().getAuthtoken(), endpoint, jsonString);
				if (resultado.containsKey("error") && resultado.getString("error") != null) {
					throwException(resultado.getString("error"));
				}
			} else {
				throwException(resultado.getString("error"));
			}
		}
		System.out.println("reci: " + resultado.toString());
		return resultado.toString();
	}

	private void throwException(String error) throws RestClientException {
		if (error.equals(ResponseGestorDocumentalFotos.ACCESS_DENIED)) {
			throw new AccesDeniedException();
		} else if (error.equals(ResponseGestorDocumentalFotos.FILE_ERROR)) {
			throw new FileErrorException();
		} else if (error.equals(ResponseGestorDocumentalFotos.INVALID_JSON)) {
			throw new InvalidJsonException();
		} else if (error.equals(ResponseGestorDocumentalFotos.MISSING_REQUIRED_FIELDS)) {
			throw new MissingRequiredFieldsException();
		} else if (error.equals(ResponseGestorDocumentalFotos.UNKNOWN_ID)) {
			throw new UnknownIdException();
		}
	}

	private AuthtokenResponse getAuthtoken() throws IOException, RestClientException, HttpClientException {
		AuthtokenRequest request = new AuthtokenRequest();
		request.setApp_id(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.APP_ID_GESTOR_DOCUMENTAL, "3"));
		request.setApp_secret(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.APP_SECRET_GESTOR_DOCUMENTAL,
				"z[99I(sZluG){yfCdd]xO_eb-(A9Wxof{C{sZ_Tr2h/MLT$D=VH9T)bRCl1IY7ANd&W{qPeIPf[y(NuqbgtvpS4r3PI[}z)?J-[36fw=&M]60"));
		String jsonResponse = null;
		AuthtokenResponse response = null;
		if (servletContext.getAttribute(ID_AUTH_TOKEN) != null) {
			response = (AuthtokenResponse) servletContext.getAttribute(ID_AUTH_TOKEN);
			if (response.getData().getExpires().compareTo(new Date()) < 0) {
				// lo obtenemos
				jsonResponse = cliente.send(null, GET_AUTHTOKEN_ENDPOINT, mapper.writeValueAsString(request))
						.toString();
				response = mapper.readValue(jsonResponse, AuthtokenResponse.class);
				if (response.getError() != null && !response.getError().isEmpty()) {
					servletContext.setAttribute(ID_AUTH_TOKEN, null);
					throwException(response.getError());
				}

			}
		} else {
			// lo obtenemos
			jsonResponse = cliente.send(null, GET_AUTHTOKEN_ENDPOINT, mapper.writeValueAsString(request)).toString();
			response = mapper.readValue(jsonResponse, AuthtokenResponse.class);
			if (response.getError() != null && !response.getError().isEmpty()) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				throwException(response.getError());
			}
			servletContext.setAttribute(ID_AUTH_TOKEN, response);

		}
		return response;
	}

	@Override
	public FileResponse uploadSubdivision(File fileToUpload, String name, BigDecimal idSubdivision, Long idAgrupacion,
			String descripcion) throws IOException, RestClientException, HttpClientException {
		FileUpload file = new FileUpload();
		file.setFile_base64(FileUtilsREM.base64Encode(fileToUpload));
		file.setBasename(name);
		HashMap<String, String> metadata = new HashMap<String, String>();
		metadata.put("propiedad", "subdivision");
		metadata.put("id_subdivision_haya", String.valueOf(idSubdivision));
		metadata.put("id_agrupacion_haya", String.valueOf(idAgrupacion));

		if (descripcion != null) {
			metadata.put("descripcion", descripcion);
		}

		metadata.put("fecha_subida", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

		file.setMetadata(metadata);
		return this.upload(file);
	}

	@Override
	public FileResponse upload(FileUpload file, java.io.File fileToUpload)
			throws IOException, RestClientException, HttpClientException {
		file.setFile_base64(FileUtilsREM.base64Encode(fileToUpload));
		return this.upload(file);
	}

	@Override
	public FileResponse upload(File fileToUpload, String name, PROPIEDAD propiedad, Long idRegistro, TIPO tipo,
			String descripcion, PRINCIPAL principal, SITUACION situacion, Integer orden)
			throws IOException, RestClientException, HttpClientException {
		FileUpload file = new FileUpload();
		file.setFile_base64(FileUtilsREM.base64Encode(fileToUpload));
		file.setBasename(name);
		HashMap<String, String> metadata = new HashMap<String, String>();
		if (propiedad.equals(PROPIEDAD.ACTIVO)) {
			metadata.put("propiedad", "activo");
			metadata.put("id_activo_haya", String.valueOf(idRegistro));
		} else if (propiedad.equals(PROPIEDAD.AGRUPACION)) {
			metadata.put("propiedad", "agrupacion");
			metadata.put("id_agrupacion_haya", String.valueOf(idRegistro));
		} else if (propiedad.equals(PROPIEDAD.SUBDIVISION)) {
			metadata.put("propiedad", "subdivision");
			metadata.put("id_subdivision_haya", String.valueOf(idRegistro));
		}
		if (tipo != null) {
			if (tipo.equals(TIPO.WEB)) {
				metadata.put("tipo", "01");
			} else if (tipo.equals(TIPO.TECNICA)) {
				metadata.put("tipo", "02");
			} else if (tipo.equals(TIPO.TESTIGO)) {
				metadata.put("tipo", "03");
			}
		}
		if (descripcion != null) {
			metadata.put("descripcion", descripcion);
		}
		if (principal != null) {
			if (principal.equals(PRINCIPAL.SI)) {
				metadata.put("principal", "1");
			} else if (principal.equals(PRINCIPAL.NO)) {
				metadata.put("principal", "0");
			}
		}
		if (orden != null) {
			metadata.put("orden", String.valueOf(orden));
		}
		if (situacion != null) {
			if (situacion.equals(SITUACION.INTERIOR)) {
				metadata.put("interior_exterior", "1");
			} else {
				metadata.put("interior_exterior", "0");
			}
		}
		metadata.put("fecha_subida", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

		file.setMetadata(metadata);
		return this.upload(file);
	}

	@Override
	public FileResponse upload(FileUpload file) throws IOException, RestClientException, HttpClientException {
		String jsonResponse = null;
		jsonResponse = this.send(UPLOAD_ENDPOINT, mapper.writeValueAsString(file));
		return mapper.readValue(jsonResponse, FileResponse.class);
	}

	@Override
	public FileResponse update(Long idFile, String name, TIPO tipo, String descripcion, PRINCIPAL principal,
			SITUACION situacion, Integer orden) throws IOException, RestClientException, HttpClientException {
		FileResponse fileReponse = null;
		if (idFile != null) {
			FileListResponse aModificar = this.get(idFile);

			if (aModificar.getData().size() > 0) {
				FileUpload fichero = new FileUpload();
				fichero.setId(idFile);
				if (name != null && !name.isEmpty()) {
					fichero.setBasename(name);
				}
				HashMap<String, String> metadata = aModificar.getData().get(0).getMetadata();
				if (descripcion != null) {
					metadata.put("descripcion", descripcion);
				}
				if (principal != null) {
					if (principal.equals(PRINCIPAL.SI)) {
						metadata.put("principal", "1");
					} else if (principal.equals(PRINCIPAL.NO)) {
						metadata.put("principal", "0");
					}
				}
				if (situacion != null) {
					if (situacion.equals(SITUACION.INTERIOR)) {
						metadata.put("interiorexterior", "1");
					} else {
						metadata.put("interiorexterior", "0");
					}
				}
				if (orden != null) {
					metadata.put("orden", String.valueOf(orden));
				}
				fichero.setMetadata(metadata);
				fileReponse = this.upload(fichero);
			}
		}
		return fileReponse;
	}

	@Override
	public FileResponse upload(Long idFile, Integer orden)
			throws IOException, RestClientException, HttpClientException {
		return this.update(idFile, null, null, null, null, null, orden);
	}

	@Override
	public OperationResultResponse delete(Long fileId) throws IOException, RestClientException, HttpClientException {
		String jsonResponse = null;
		FileId fileToDelete = new FileId();
		fileToDelete.setId(fileId);
		jsonResponse = this.send(DELETE_ENDPOINT, mapper.writeValueAsString(fileToDelete));
		return mapper.readValue(jsonResponse, OperationResultResponse.class);
	}

	@Override
	public FileListResponse get(FileSearch fileSearch) throws IOException, RestClientException, HttpClientException {
		String jsonResponse = null;
		jsonResponse = this.send(FILE_SEARCH_ENDPOINT, mapper.writeValueAsString(fileSearch));
		return mapper.readValue(jsonResponse, FileListResponse.class);
	}

	@Override
	public FileListResponse get(PROPIEDAD propiedad, Long idRegistro)
			throws IOException, RestClientException, HttpClientException {
		FileSearch fileSearch = new FileSearch();
		HashMap<String, String> metadata = new HashMap<String, String>();

		if (propiedad.equals(PROPIEDAD.ACTIVO)) {
			metadata.put("propiedad", "activo");
			metadata.put("id_activo_haya", String.valueOf(idRegistro));
		} else if (propiedad.equals(PROPIEDAD.AGRUPACION)) {
			metadata.put("propiedad", "agrupacion");
			metadata.put("id_agrupacion_haya", String.valueOf(idRegistro));
		} else if (propiedad.equals(PROPIEDAD.SUBDIVISION)) {
			metadata.put("propiedad", "subdivision");
			metadata.put("id_subdivision_haya", String.valueOf(idRegistro));
		}

		fileSearch.setMetadata(metadata);
		return this.get(fileSearch);
	}

	@Override
	public FileListResponse get(Long fileId) throws IOException, RestClientException, HttpClientException {
		FileSearch search = new FileSearch();
		search.setId(fileId);
		return this.get(search);
	}

}
