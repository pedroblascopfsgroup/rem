package es.pfsgroup.plugin.gestorDocumental.model;

import org.glassfish.jersey.media.multipart.MultiPart;

public class ServerRequest {

	private String restClientUrl;
	private String method;
	private String path;
	private Class<?> responseClass;
	private MultiPart multipart;

	public String getRestClientUrl() {
		return restClientUrl;
	}
	public void setRestClientUrl(String restClientUrl) {
		this.restClientUrl = restClientUrl;
	}
	public String getMethod() {
		return method;
	}
	public void setMethod(String method) {
		this.method = method;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public Class<?> getResponseClass() {
		return responseClass;
	}
	public void setResponseClass(Class<?> responseClass) {
		this.responseClass = responseClass;
	}
	public MultiPart getMultipart() {
		return multipart;
	}
	public void setMultipart(MultiPart multipart) {
		this.multipart = multipart;
	}

}
