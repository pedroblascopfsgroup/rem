package es.pfsgroup.plugin.rem.rest.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.RequestDto;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

public class RestSecurityFilter implements Filter {

	@Autowired
	private EntidadDao entidadDao;

	@Autowired
	private RestApi restApi;

	@Override
	public void destroy() {

	}

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		PeticionRest peticion = crearPeticionObj(request);
		boolean hibernateEnable = false;

		try {
			// imprescindible para poder inyectar componentes
			SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);

			RestRequestWrapper restRequest = new RestRequestWrapper((HttpServletRequest) request);

			// obtenemos los datos de la peticion
			RequestDto datajson = (RequestDto)restRequest.getRequestData(RequestDto.class);

			// obtenemos el workingcode. Si el cliente no lo pasa asumimos valor
			// por
			// defecto
			String workingCode = "2038";// <------parametrizarlo en
										// devon.properties

			if (datajson.getWorkingcode() != null && !datajson.getWorkingcode().isEmpty()) {
				workingCode = datajson.getWorkingcode();
			}

			// Obtenemos la entidad partiendo del working code y establecemos el
			// contextholder
			// necesario para acceder al esquema de la entidad
			Entidad entidad = null;

			try {
				entidad = entidadDao.findByWorkingCode(workingCode);
			} catch (Exception e) {
				logger.error("Error obteniendo la entidad: ");
			}

			if (entidad != null) {
				DbIdContextHolder.setDbId(entidad.getId());
				hibernateEnable = true;
			} else {
				logger.error("El workingcode no pertenece a ninguna entidad");
				throwErrorWorkingCodeInvalido(response);
				return;
			}

			// logamos el operador partiendo del parametro signature
			String signature = ((HttpServletRequest) request).getHeader("signature");
			String id = datajson.getId();
			peticion.setToken(id);
			String ipClient = ((HttpServletRequest) request).getRemoteAddr();

			Broker broker = restApi.getBrokerByIp(ipClient);

			if (broker != null) {
				peticion.setBroker(broker);

				if (!restApi.validateSignature(broker, signature, restRequest.getBody())) {
					logger.error("REST: La firma no es correcta");
					peticion.setResult(RestApi.CODE_ERROR);
					peticion.setErrorDesc(RestApi.REST_MSG_INVALID_SIGNATURE);
					throwUnauthorized(response);

				} else {
					if (!restApi.validateId(broker, id)) {
						logger.error("REST: El id de la petición ya se ha ejecutado previamente");
						peticion.setResult(RestApi.CODE_ERROR);
						peticion.setErrorDesc(RestApi.REST_MSG_REPETEAD_REQUEST);
						throwInvalidId(response);
						
					} else if(!restRequest.getBody().contains("data")) {
						logger.error("REST: Petición no contiene información en el campo data.");
						peticion.setResult(RestApi.CODE_ERROR);
						peticion.setErrorDesc(RestApi.REST_MSG_REQUEST_WITHOUT_DATA);
						throwInvalidRequest(response);
						
					} else {
						chain.doFilter(restRequest, response);
						
						peticion.setResult(RestApi.CODE_OK);
						
/*						//Actualizar estado petición
						peticion = restApi.getLastPeticionByToken(jsonData.getId());
						if(!Checks.esNulo(peticion)){
							peticion.setResult(RestApi.CODE_OK);
							restApi.guardarPeticionRest(peticion);
						}*/

					}
				}
			} else {
				logger.error("REST: El operador cuya IP publica es ".concat(ipClient).concat("no está dado de alta"));
				peticion.setResult(RestApi.CODE_ERROR);
				peticion.setErrorDesc(RestApi.REST_MSG_BROKER_NOT_EXIST);
				throwBrokerNotExist(response);
			}
		} catch (Exception e) {
			peticion.setResult("ERROR");
			logger.error(e.getMessage());
			if (e.getMessage() != null && e.getMessage().length() > 200) {

				peticion.setErrorDesc(e.getMessage().substring(0, 199));
			} else {
				peticion.setErrorDesc(e.getMessage());
			}

			throwErrorGeneral(response, e);

		}
		if (hibernateEnable) {
			restApi.guardarPeticionRest(peticion);
		}
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {

	}

	/**
	 * Error firma invalida
	 * 
	 * @param res
	 * @throws IOException
	 */
	private void throwUnauthorized(ServletResponse res) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String error = "{\"data\":null,\"error\":\"" + RestApi.REST_MSG_INVALID_SIGNATURE + "\"}";

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}

	/**
	 * Error token invalido, repetido
	 * 
	 * @param res
	 * @throws IOException
	 */
	private void throwInvalidId(ServletResponse res) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String error = "{\"data\":null,\"error\":\"" + RestApi.REST_MSG_REPETEAD_REQUEST + "\"}";

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}
	
	/**
	 * Error data invalida
	 * 
	 * @param res
	 * @throws IOException
	 */
	private void throwInvalidRequest(ServletResponse res) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String error = "{\"data\":null,\"error\":\"" + RestApi.REST_MSG_REQUEST_WITHOUT_DATA + "\"}";

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}

	/**
	 * Error el operador no permitido
	 * 
	 * @param res
	 * @throws IOException
	 */
	private void throwBrokerNotExist(ServletResponse res) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String error = "{\"data\":null,\"error\":\"" + RestApi.REST_MSG_BROKER_NOT_EXIST + "\"}";

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}
	
	
	/**
	 * Error de workingcode
	 * 
	 * @param res
	 * @throws IOException
	 */
	private void throwErrorWorkingCodeInvalido(ServletResponse res) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String error = "{\"data\":null,\"error\":\"" + RestApi.REST_MSG_INVALID_WORKINGCODE + "\"}";

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}

	/**
	 * Error general
	 * 
	 * @param res
	 * @param e
	 * @throws IOException
	 */
	private void throwErrorGeneral(ServletResponse res, Exception e) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String descError = "";

		if (e.getMessage() != null && !e.getMessage().isEmpty()) {
			descError = e.getMessage().toUpperCase();
		}

		String error = "{\"data\":null,\"error\":\"".concat(descError).concat("\"}");

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}


	
	/**
	 * Crea un objeto de tipo peticion rest
	 * 
	 * @param req
	 * @return
	 */
	private PeticionRest crearPeticionObj(ServletRequest req) {
		HttpServletRequest request = (HttpServletRequest) req;
		PeticionRest peticion = new PeticionRest();
		peticion.setMetodo(request.getMethod());
		peticion.setQuery(request.getPathInfo());
		peticion.setData(request.getParameter("data"));
		peticion.setIp(request.getRemoteAddr());

		return peticion;

	}

}
