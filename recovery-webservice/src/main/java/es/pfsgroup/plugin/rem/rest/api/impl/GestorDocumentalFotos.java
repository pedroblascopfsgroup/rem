package es.pfsgroup.plugin.rem.rest.api.impl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletContext;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PLANO;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SUELOS;
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
import es.pfsgroup.plugin.rem.restclient.exception.RestConfigurationException;
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

	@Autowired
	private ActivoApi activoManager;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionManager;

	ObjectMapper mapper = new ObjectMapper();

	@Resource
	private Properties appProperties;

	@Override
	public boolean isActive() {
		boolean resultado = false;
		String urlBase = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.BASE_URL_GESTOR_DOCUMENTAL, null);
		if (urlBase != null && !urlBase.isEmpty()) {
			resultado = true;
		}
		return resultado;
	}

	private String send(String endpoint, String jsonString)
			throws RestClientException, HttpClientException, IOException {
		AuthtokenResponse authToken = this.getAuthtoken();
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
		String appId = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.APP_ID_GESTOR_DOCUMENTAL, null);
		String secret = WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.APP_SECRET_GESTOR_DOCUMENTAL, null);

		if (appId == null || appId.isEmpty() || secret == null || secret.isEmpty()) {
			throw new RestConfigurationException("configure al app_id y el app_secret");
		}
		request.setApp_id(appId);
		request.setApp_secret(secret);
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
	public FileResponse uploadSubdivision(File fileToUpload, String name, Long idSubdivision, ActivoAgrupacion agrupacion,
			String descripcion,TIPO tipo,PRINCIPAL principal,SITUACION situacion, Integer orden ) throws IOException, RestClientException, HttpClientException {
		FileUpload file = new FileUpload();
		file.setFile_base64(FileUtilsREM.base64Encode(fileToUpload));
		file.setBasename(name);
		HashMap<String, String> metadata = new HashMap<String, String>();
		metadata.put("propiedad", "subdivision");
		metadata.put("id_subdivision", String.valueOf(idSubdivision));
		metadata.put("id_agrupacion_haya", String.valueOf(agrupacion.getNumAgrupRem()));
		if (agrupacion != null && agrupacion.getActivoPrincipal() != null
				&& agrupacion.getActivoPrincipal().getCartera() != null) {
			metadata.put("cartera", agrupacion.getActivoPrincipal().getCartera().getCodigo());
		}

		if (descripcion != null) {
			metadata.put("descripcion", descripcion);
		}
		if (tipo != null) {
			if (tipo.equals(TIPO.WEB)) {
				metadata.put("tipo_foto", "01");
			} else if (tipo.equals(TIPO.TECNICA)) {
				metadata.put("tipo_foto", "02");
			} else if (tipo.equals(TIPO.TESTIGO)) {
				metadata.put("tipo_foto", "03");
			}
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
				metadata.put("interior_exterior", "1");
			} else {
				metadata.put("interior_exterior", "0");
			}
		}

		metadata.put("fecha_subida", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		
		if (orden != null) {
			metadata.put("orden", String.valueOf(orden));
		}
		
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
			String descripcion, PRINCIPAL principal, SITUACION situacion, Integer orden, SUELOS suelos, PLANO plano)
			throws IOException, RestClientException, HttpClientException {
		FileUpload file = new FileUpload();
		file.setFile_base64(FileUtilsREM.base64Encode(fileToUpload));
		file.setBasename(name);
		HashMap<String, String> metadata = new HashMap<String, String>();
		if (propiedad.equals(PROPIEDAD.ACTIVO)) {
			Activo activo = activoManager.getByNumActivo(idRegistro);
			metadata.put("propiedad", "activo");
			metadata.put("id_activo_haya", String.valueOf(activo.getNumActivo()));
			if (activo != null && activo.getCartera() != null) {
				metadata.put("cartera", activo.getCartera().getCodigo());
			}
		} else if (propiedad.equals(PROPIEDAD.AGRUPACION)) {
			ActivoAgrupacion agrupacion = activoAgrupacionManager.get(idRegistro);
			metadata.put("propiedad", "agrupacion");
			metadata.put("id_agrupacion_haya", String.valueOf(agrupacion.getNumAgrupRem()));
			if (agrupacion != null && agrupacion.getActivoPrincipal() != null
					&& agrupacion.getActivoPrincipal().getCartera() != null) {
				metadata.put("cartera", agrupacion.getActivoPrincipal().getCartera().getCodigo());
			}
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
		if (suelos != null) {
			if (suelos.equals(SUELOS.SI)) {
				metadata.put("suelos", "1");
			} else if (suelos.equals(SUELOS.NO)) {
				metadata.put("suelos", "0");
			}
		}
		if (plano != null) {
			if (plano.equals(PLANO.SI)) {
				metadata.put("plano", "1");
			} else if (plano.equals(PLANO.NO)) {
				metadata.put("plano", "0");
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
			SITUACION situacion, Integer orden, SUELOS suelos, PLANO plano) throws IOException, RestClientException, HttpClientException {
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
						metadata.put("interior_exterior", "1");
					} else {
						metadata.put("interior_exterior", "0");
					}
				}
				if (suelos != null) {
					if (suelos.equals(SUELOS.SI)) {
						metadata.put("suelos", "1");
					} else if (principal.equals(SUELOS.NO)) {
						metadata.put("suelos", "0");
					}
				}
				if (plano != null) {
					if (plano.equals(PLANO.SI)) {
						metadata.put("plano", "1");
					} else if (plano.equals(PLANO.NO)) {
						metadata.put("plano", "0");
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
		return this.update(idFile, null, null, null, null, null, orden, null, null);
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
		return this.get(propiedad, String.valueOf(idRegistro));
	}

	@Override
	public FileListResponse get(PROPIEDAD propiedad, String idRegistro)
			throws IOException, RestClientException, HttpClientException {
		FileSearch fileSearch = new FileSearch();
		HashMap<String, String> metadata = new HashMap<String, String>();

		if (propiedad.equals(PROPIEDAD.ACTIVO)) {
			metadata.put("propiedad", "activo");
			metadata.put("id_activo_haya", idRegistro);
		} else if (propiedad.equals(PROPIEDAD.AGRUPACION)) {
			metadata.put("propiedad", "agrupacion");
			metadata.put("id_agrupacion_haya", idRegistro);
		} else if (propiedad.equals(PROPIEDAD.SUBDIVISION)) {
			metadata.put("propiedad", "subdivision");
			metadata.put("id_subdivision", idRegistro);
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
