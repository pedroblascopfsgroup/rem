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
import es.pfsgroup.plugin.rem.rest.api.RestManager;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import net.sf.json.JSONObject;

public class RestSecurityFilter implements Filter {

	@Autowired
	private EntidadDao entidadDao;

	@Autowired
	private RestManager restManager;

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

			// obtenemos los datos de la peticion
			JSONObject datajson = getDataJson(request);

			// obtenemos el workingcode. Si el cliente no lo pasa asumimos valor
			// por
			// defecto
			String workingCode = "2038";// <------parametrizarlo en
										// devon.properties

			if (datajson.containsKey("workingcode") && !datajson.getString("workingcode").isEmpty()) {
				workingCode = datajson.getString("workingcode");
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
			String id = datajson.getString("id");
			peticion.setToken(id);
			String ipClient = ((HttpServletRequest) request).getRemoteAddr();

			Broker broker = restManager.getBrokerByIp(ipClient);

			if (broker != null) {
				peticion.setBroker(broker);

				if (!restManager.validateSignature(broker, signature, getDataString(request))) {
					logger.error("REST: La firma no es correcta");
					peticion.setResult("ERROR");
					peticion.setErrorDesc("INVALID_SIGNATURE");
					throwUnauthorized(response);

				} else {
					if (!restManager.validateId(broker, id)) {
						logger.error("REST: El id de la petición ya se ha ejecutado previamente");
						peticion.setResult("ERROR");
						peticion.setErrorDesc("REPETEAD_REQUEST");
						throwInvalidId(response);
					} else {
						chain.doFilter(request, response);
						peticion.setResult("OK");

					}
				}
			} else {
				logger.error("REST: El operador cuya IP publica es ".concat(ipClient).concat("no está dado de alta"));
				peticion.setResult("ERROR");
				peticion.setErrorDesc("BROKER_NOT_EXIST");
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
			restManager.guardarPeticionRest(peticion);
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

		String error = "{\"data\":null,\"error\":\"INVALID_SIGNATURE\"}";

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

		String error = "{\"data\":null,\"error\":\"REPETEAD_REQUEST\"}";

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

		String error = "{\"data\":null,\"error\":\"BROKER_NOT_EXIST\"}";

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

	private void throwErrorWorkingCodeInvalido(ServletResponse res) throws IOException {

		HttpServletResponse response = (HttpServletResponse) res;

		String error = "{\"data\":null,\"error\":\"INVALID_WORKINGCODE: \"}";

		response.reset();
		response.setHeader("Content-Type", "application/json;charset=UTF-8");
		response.getWriter().write(error);
	}

	/**
	 * Obtiene la peticion como string
	 * 
	 * @param req
	 * @return
	 */
	private String getDataString(ServletRequest req) {

		HttpServletRequest request = (HttpServletRequest) req;
		String data = null;
		String method = request.getMethod();
		if (method != null) {
			if (method.equals("GET") || method.equals("FICTICIO")) {
				String[] tokens = request.getPathInfo().split("/");
				if (tokens != null && tokens.length > 0) {
					 //data = tokens[tokens.length - 1];
					data = request.getParameter("data");
				}

			} else if (method.equals("POST") || method.equals("GET") || method.equals("DELETE")) {
				data = request.getParameter("data");
			}
		}
		return data;
	}

	/**
	 * Obtiene la peticion como json
	 * 
	 * @param req
	 * @return
	 */
	private JSONObject getDataJson(ServletRequest req) {

		JSONObject json = null;
		String data = getDataString(req);
		if (data != null) {
			json = JSONObject.fromObject(data);
		}
		return json;
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
