package es.pfs.security;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.web.util.HtmlUtils;

public class RecoverySecurityHttpRequestWrapper extends
		HttpServletRequestWrapper {

	private Map<String, String[]> escapedParametersValuesMap = new HashMap<String, String[]>();

	public RecoverySecurityHttpRequestWrapper(HttpServletRequest request) {
		super(request);
	}

	@Override
	public String getParameter(String name) {
		String[] escapedParameterValues = escapedParametersValuesMap.get(name);
		String escapedParameterValue = null;
		if (escapedParameterValues != null) {
			escapedParameterValue = escapedParameterValues[0];
		} else {
			String parameterValue = super.getParameter(name);
			// HTML transformation characters
			escapedParameterValue = HtmlUtils.htmlEscape(parameterValue);
			// SQL injection characters
			escapedParameterValue = StringEscapeUtils.escapeSql(escapedParameterValue);
			escapedParametersValuesMap.put(name, new String[] { escapedParameterValue });
		}

		return escapedParameterValue;
	}

	@Override
	public String[] getParameterValues(String name) {
		String[] escapedParameterValues = escapedParametersValuesMap.get(name);
		if (escapedParameterValues == null) {
			if (super.getParameterValues(name) != null) {
				String[] parametersValues = super.getParameterValues(name);
				escapedParameterValues = new String[parametersValues.length];
				for (int i = 0; i < parametersValues.length; i++) {
					String parameterValue = parametersValues[i];
					String escapedParameterValue = parameterValue;
					// HTML transformation characters
					escapedParameterValue = HtmlUtils.htmlEscape(parameterValue);
					// SQL injection characters
					escapedParameterValue = StringEscapeUtils.escapeSql(escapedParameterValue);
					escapedParameterValues[i] = escapedParameterValue;
				}
				escapedParametersValuesMap.put(name, escapedParameterValues);
			}
		}

		return escapedParameterValues;
	}

	@Override
	public String getQueryString() {
		
		String queryString = super.getQueryString();
		if (queryString != null) {
			queryString = StringEscapeUtils.escapeHtml(queryString);
			if (queryString.indexOf('%')>0) {
				queryString = queryString.replaceAll("%", "");
			}
		}
		return queryString;
	}
	
}
