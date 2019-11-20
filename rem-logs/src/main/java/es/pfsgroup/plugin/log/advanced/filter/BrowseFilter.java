package es.pfsgroup.plugin.log.advanced.filter;

import java.io.IOException;
import java.util.Map;

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

import es.pfsgroup.plugin.log.advanced.api.LogAdvancedBrowseApi;
/**
 * Filtro para la gestión de las navegaciones
 * 
 * @author carlosgil
 *
 */
public class BrowseFilter implements Filter {
	
	@Autowired
	private LogAdvancedBrowseApi logBrowserApi;
	

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		logger.debug("Filtro navegación web iniciada");
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
	}

	@Override
	public void destroy() {
		logger.debug("Filtro navegación web");
	}

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
		try {
			if (request instanceof HttpServletRequest) {
				String requestUri = ((HttpServletRequest) request).getRequestURL().toString();
				Map<String,Object> parameters= ((HttpServletRequest)request).getParameterMap();
				logBrowserApi.registerLog(requestUri, parameters);
			}
			chain.doFilter(request, response);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}