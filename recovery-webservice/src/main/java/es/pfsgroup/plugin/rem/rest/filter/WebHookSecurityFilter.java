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
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

public class WebHookSecurityFilter implements Filter {

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public void destroy() {
		logger.debug("webhook listener detenido");
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		RestRequestWrapper restRequest = null;
		try {
			restRequest = new RestRequestWrapper((HttpServletRequest) request);
			chain.doFilter(restRequest, response);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		

	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		logger.debug("webhook listener iniciado");
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);

	}

}
