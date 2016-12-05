package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import org.codehaus.jackson.map.annotate.JsonDeserialize;

import es.pfsgroup.plugin.rem.rest.dto.deserializers.CustomJsonDateDeserializer;



public class Authtoken implements Serializable {
	private static final long serialVersionUID = -5714191995720840403L;
	private String authtoken;
	@JsonDeserialize(using = CustomJsonDateDeserializer.class)
	private Date expires;

	public String getAuthtoken() {
		return authtoken;
	}

	public void setAuthtoken(String authtoken) {
		this.authtoken = authtoken;
	}

	public Date getExpires() {
		return expires;
	}

	public void setExpires(Date expires) {
		this.expires = expires;
	}
}
