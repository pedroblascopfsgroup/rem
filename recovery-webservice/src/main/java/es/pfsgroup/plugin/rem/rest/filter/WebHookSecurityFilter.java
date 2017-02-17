package es.pfsgroup.plugin.rem.rest.filter;

import java.io.IOException;

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
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

public class WebHookSecurityFilter implements Filter {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	private String WORKINGCODE = "2038";

	@Override
	public void destroy() {
		logger.debug("webhook listener detenido");
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		RestRequestWrapper restRequest = null;
		PeticionRest peticion = null;
		try {
			restApi.doSessionConfig(WORKINGCODE);
			String authHeader = ((HttpServletRequest) request).getHeader("AUTHORIZATION");
			restRequest = new RestRequestWrapper((HttpServletRequest) request);
			peticion = restApi.crearPeticionObj(restRequest);
			if (restApi.validateWebhookSignature(request, authHeader)) {
				restRequest.setPeticionRest(peticion);
				chain.doFilter(restRequest, response);
			} else {
				logger.error("Petición webhook no autorizada");
				peticion.setResult(RestApi.REST_MSG_INVALID_SIGNATURE);				
			}

		} catch (Exception e) {
			peticion.setResult(RestApi.CODE_ERROR);
			peticion.setErrorDesc(e.getMessage());
			logger.error(e.getMessage());
		} finally {
			restApi.guardarPeticionRest(peticion);
		}

	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		logger.debug("webhook listener iniciado");
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);

	}

}
