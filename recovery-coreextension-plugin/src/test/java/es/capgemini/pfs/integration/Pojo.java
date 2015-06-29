package es.capgemini.pfs.integration;

import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

public class Pojo {

	@JsonIgnore
	private final Map<String,String> mapa;
	
	public Pojo() {
		mapa = new HashMap<String, String>();
	}

	public Pojo(
			@JsonProperty("cn") String cn
			, @JsonProperty("data") String obj) {
		this();
		mapa.put("type", "TipoMSG");
		mapa.put("class", cn);
		mapa.put("body", obj);
	}

	@JsonProperty("cn")
	public String getClase() {
		return mapa.get("class");
	}
	
	@JsonProperty("data")
	public String getDatos() {
		return mapa.get("body");
	}
	
}
