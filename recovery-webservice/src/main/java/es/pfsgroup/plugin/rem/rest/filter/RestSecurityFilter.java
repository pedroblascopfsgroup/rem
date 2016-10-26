package es.pfsgroup.plugin.rem.rest.filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.ALGORITMO_FIRMA;
import es.pfsgroup.plugin.rem.rest.dto.RequestDto;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import net.sf.json.JSONObject;

/**
 * Filtro para la gestión de las peticiones a la rest-api
 * 
 * @author rllinares
 *
 */
public class RestSecurityFilter implements Filter {

	@Autowired
	private EntidadDao entidadDao;

	@Autowired
	private RestApi restApi;

	private String WORKINGCODE = "2038";

	private Entidad entidad = null;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		logger.debug("rest api iniciada");
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
	}

	@Override
	public void destroy() {
		logger.debug("rest api parada");
	}

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {

		PeticionRest peticion = restApi.crearPeticionObj(request);
		RestRequestWrapper restRequest = null;
		JSONObject jsonFields = null;

		try {

			restRequest = new RestRequestWrapper((HttpServletRequest) request);
			// obtenemos los datos de la peticion
			RequestDto datajson = (RequestDto) restRequest.getRequestData(RequestDto.class);
			logger.debug("Ejecutando request id:".concat(datajson.getId()));
			logger.debug("Datos de la peticion id:".concat(restRequest.getBody()));

			jsonFields = restRequest.getJsonObject();
			doSessionConfig(response, WORKINGCODE);

			// logamos el operador partiendo del parametro signature
			String signature = ((HttpServletRequest) request).getHeader("signature");
			String id = datajson.getId();
			peticion.setToken(id);
			String ipClient = restApi.getClientIpAddr(request);

			ALGORITMO_FIRMA algoritmoFirma = restApi.obtenerAlgoritmoFirma(request);

			Broker broker = restApi.getBrokerByIp(ipClient);
			if (broker == null) {
				broker = restApi.getBrokerDefault("");
				broker.setIp(ipClient);
			} else {
				peticion.setBroker(broker);
			}

			if (broker != null) {

				if (!restApi.validateSignature(broker, signature, restRequest.getBody(), algoritmoFirma)) {
					logger.error("REST: La firma no es correcta");
					peticion.setResult(RestApi.CODE_ERROR);
					peticion.setErrorDesc(RestApi.REST_MSG_INVALID_SIGNATURE);
					restApi.throwRestException(response, RestApi.REST_MSG_INVALID_SIGNATURE, jsonFields);

				} else {
					if (!restApi.validateId(broker, id)) {
						logger.error("REST: El id de la petición ya se ha ejecutado previamente");
						peticion.setResult(RestApi.CODE_ERROR);
						peticion.setErrorDesc(RestApi.REST_MSG_REPETEAD_REQUEST);
						restApi.throwRestException(response, RestApi.REST_MSG_REPETEAD_REQUEST, jsonFields);

					} else if (!restRequest.getBody().contains("data")) {
						logger.error("REST: Petición no contiene información en el campo data.");
						peticion.setResult(RestApi.CODE_ERROR);
						peticion.setErrorDesc(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
						restApi.throwRestException(response, RestApi.REST_MSG_MISSING_REQUIRED_FIELDS, jsonFields);

					} else {
						chain.doFilter(restRequest, response);
						peticion.setResult(RestApi.CODE_OK);
					}
				}
			}
			// securityContext.getAuthentication().setAuthenticated(false);
		} catch (Exception e) {
			peticion.setResult("ERROR");
			logger.error(e.getMessage());
			restApi.throwRestException(response, RestApi.REST_MSG_UNEXPECTED_ERROR, jsonFields);

		} catch (Throwable t) {
			peticion.setResult("ERROR");
			logger.error(t.getMessage());
			restApi.throwRestException(response, RestApi.REST_MSG_UNEXPECTED_ERROR, jsonFields);
		} finally {
			SecurityContextHolder.clearContext();
			restApi.guardarPeticionRest(peticion);
		}
	}

	/**
	 * Realiza la configuracion de la sesión
	 * 
	 * @param response
	 * @param workingCode
	 * @throws Exception
	 */
	private void doSessionConfig(ServletResponse response, String workingCode) throws Exception {
		// Obtenemos la entidad partiendo del working code y establecemos el
		// contextholder
		// necesario para acceder al esquema de la entidad
		try {
			entidad = entidadDao.findByWorkingCode(workingCode);
		} catch (Exception e) {
			logger.error("Error obteniendo la entidad: ");
		}

		entidad = entidadDao.findByWorkingCode(workingCode);

		if (entidad != null) {
			DbIdContextHolder.setDbId(entidad.getId());
		} else {
			throw new Exception(RestApi.REST_MSG_INVALID_WORKINGCODE);
		}

		// Realizamos login en la plataforma
		restApi.doLogin(restApi.loadUserRest(entidad));

	}

}