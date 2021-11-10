package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.HashMap;

public class File implements Serializable {

	private static final long serialVersionUID = 7350449895156845439L;
	private Long id;
	private String url;
	private String url_watermark;
	private String url_optimized;
	private String url_thumbnail;
	private String resource_type;
	private HashMap<String, String> metadata;
	private String basename;
	private String modified_by_app;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getUrl() {
		return url;
	}

	public String getUrl_watermark() {
		return url_watermark;
	}

	public void setUrl_watermark(String url_watermark) {
		this.url_watermark = url_watermark;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getUrl_optimized() {
		return url_optimized;
	}

	public void setUrl_optimized(String url_optimized) {
		this.url_optimized = url_optimized;
	}

	public String getUrl_thumbnail() {
		return url_thumbnail;
	}

	public void setUrl_thumbnail(String url_thumbnail) {
		this.url_thumbnail = url_thumbnail;
	}

	public String getResource_type() {
		return resource_type;
	}

	public void setResource_type(String resource_type) {
		this.resource_type = resource_type;
	}

	public HashMap<String, String> getMetadata() {
		return metadata;
	}

	public void setMetadata(HashMap<String, String> metadata) {
		this.metadata = metadata;
	}

	public String getBasename() {
		return basename;
	}

	public void setBasename(String basename) {
		this.basename = basename;
	}

	public String getModified_by_app() {
		return modified_by_app;
	}

	public void setModified_by_app(String modified_by_app) {
		this.modified_by_app = modified_by_app;
	}
	
	
}
