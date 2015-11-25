package es.pfs.security;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.BadCredentialsException;

public class RecoverySecurityFilter implements Filter {

	private static final String X_FORWARDED_FOR_2 = "HTTP_X_FORWARDED_FOR";

	private static final String X_FORWARDED_FOR_1 = "X-Forwarded-For";

	private static final String INICIO_BANKIA = "inicioBankia";

	private static final String NOMBRE_COOKIE = "JSESSIONID";

	private static final String SEPARADOR = "-";

	private final Log logger = LogFactory.getLog(getClass());

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	
	private static Map<String, String> mapaCookies = new ConcurrentHashMap<String, String>();
	
	public void init(FilterConfig config) throws ServletException {}

	public void destroy() {}

	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		String path = request.getRequestURI();
		if (!path.contains(INICIO_BANKIA)) { 
			String remoteIP = obtenerIPCliente(request);
			if (!comprobarSessionFixation(remoteIP, request.getCookies())) {
				logger.error("Intento de session fixation desde la IP " + remoteIP);
				throw new BadCredentialsException("Intento de session fixation desde la IP " + remoteIP, null);
			}
		} else {
			//logger.error("Session fixation no controlada: " + path);
			((HttpServletRequest) req).getSession().invalidate();
		}
		chain.doFilter(new RecoverySecurityHttpRequestWrapper(request), res);
		
	}

	private String obtenerIPCliente(HttpServletRequest request) {
		
		//logger.error("obtenerIPCliente: " + request.getHeader(X_FORWARDED_FOR_1) + "-"+ request.getHeader(X_FORWARDED_FOR_2) + "-"+ request.getRemoteAddr() );
		String ipAddress = request.getHeader(X_FORWARDED_FOR_1);
		if (ipAddress == null) {
			ipAddress = request.getHeader(X_FORWARDED_FOR_2);
		}
		if (ipAddress == null) {
			ipAddress = request.getRemoteAddr();
		}
		return ipAddress;
		
	}

	private boolean comprobarSessionFixation(String remoteIP, Cookie[] cookies) {

		boolean ok = true; 
		if (cookies!=null && cookies.length>0) {
			for (int i = 0; i < cookies.length; i++) {
				ok = registerAndCheckCookie(remoteIP, cookies[i].getName(), cookies[i].getValue());
				if (!ok) {
					break;
				}
			}
		} else {
			logger.error("No hay cookies.");
		}
		return ok;
	}

	private boolean registerAndCheckCookie(String remoteIP, String nameCookie, String idCookie) {
		
		String info = "******" + nameCookie + "***:" + idCookie + SEPARADOR + remoteIP;
		if (mapaCookies.containsKey(idCookie)) {
			String ip = mapaCookies.get(idCookie).split(SEPARADOR)[1];
			if (ip.equals(remoteIP)) {
				//logger.error(mapaCookies.size() + info + ":1");
				return true;
			} else {
				//logger.error(mapaCookies.size() + info + ":2");
				return false;
			}
		} else {
			String fechaActual = sdf.format(new Date());
			mapaCookies.put(idCookie, fechaActual + SEPARADOR + remoteIP);
			//logger.error(mapaCookies.size() + info + ":3");
			cleanOldEntries(fechaActual);
			//logger.error(mapaCookies.size() + info + ":4");
			return true;
		}
	}

	private void cleanOldEntries(String fechaActual) {
		
		for (Entry<String, String> entrada : mapaCookies.entrySet()) {
			if (!entrada.getValue().split(SEPARADOR)[0].equals(fechaActual)) {
				mapaCookies.remove(entrada);
			}
		}
		
	}

}
