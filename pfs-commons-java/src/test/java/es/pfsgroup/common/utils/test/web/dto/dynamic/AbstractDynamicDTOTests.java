package es.pfsgroup.common.utils.test.web.dto.dynamic;

import java.security.Principal;
import java.util.Locale;
import java.util.Map;

import org.springframework.web.context.request.WebRequest;

public abstract class AbstractDynamicDTOTests {

	public AbstractDynamicDTOTests() {
		super();
	}

	protected WebRequest createRequest(final Map<String, String> parameters) {
		return new WebRequest() {
	
			private Map<String, String> map = parameters;
	
			@Override
			public void setAttribute(String name, Object value, int scope) {
				
			}
	
			@Override
			public void removeAttribute(String name, int scope) {
				this.map.remove(name);
	
			}
	
			@Override
			public void registerDestructionCallback(String name,
					Runnable callback, int scope) {
	
			}
	
			@Override
			public Object getSessionMutex() {
				return null;
			}
	
			@Override
			public String getSessionId() {
				return null;
			}
	
			@Override
			public String[] getAttributeNames(int scope) {
				return this.map.keySet().toArray(new String[] {});
			}
	
			@Override
			public Object getAttribute(String name, int scope) {
				return this.map.get(name);
			}
	
			@Override
			public boolean isUserInRole(String role) {
				return false;
			}
	
			@Override
			public boolean isSecure() {
				return false;
			}
	
			@Override
			public Principal getUserPrincipal() {
				return null;
			}
	
			@Override
			public String getRemoteUser() {
				return null;
			}
	
			@Override
			public String[] getParameterValues(String paramName) {
				return this.map.values().toArray(new String[] {});
			}
	
			@Override
			public Map getParameterMap() {
				return this.map;
			}
	
			@Override
			public String getParameter(String paramName) {
				return this.map.get(paramName);
			}
	
			@Override
			public Locale getLocale() {
				return null;
			}
	
			@Override
			public String getDescription(boolean includeClientInfo) {
				return null;
			}
	
			@Override
			public String getContextPath() {
				return null;
			}
	
			@Override
			public boolean checkNotModified(long lastModifiedTimestamp) {
				return false;
			}
		};
	}

}