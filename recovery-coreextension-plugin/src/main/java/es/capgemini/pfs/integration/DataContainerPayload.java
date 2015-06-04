package es.capgemini.pfs.integration;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

public class DataContainerPayload extends TypePayload {

	// Codigos identificativos operacionales.
	private final Map<String, Long> idOrigen;
	private final Map<String, String> codigo;
	private final Map<String, String> guid;
	private final Map<String, Date> fecha;
	private final Map<String, Boolean> flag;
	private final Map<String, String> extraInfo;
	private final Map<String, BigDecimal> valBDec;
	private final Map<String, Double> valDouble;
	private final Map<String, Integer> valInt;
	private final Map<String, Long> valLong;

	@JsonCreator
	public DataContainerPayload(String tipo,
			Map<String, String> codigo,
			Map<String, String> guid,
			Map<String, Long> idOrigen,
			Map<String, Date> fecha,
			Map<String, Boolean> flag,
			Map<String, BigDecimal> valBDec,
			Map<String, Double> valDouble,
			Map<String, Integer> valInt,
			Map<String, Long> valLong
			) {
		super(tipo);
		this.guid = guid;
		this.codigo = codigo;
		this.idOrigen = idOrigen;
		this.fecha = fecha;
		this.flag = flag;
		this.valBDec = valBDec;
		this.valDouble = valDouble;
		this.valInt = valInt;
		this.extraInfo = new HashMap<String, String>();
		this.valLong = valLong;
	}
	
	public DataContainerPayload(String tipo) {
		this(tipo
				, new HashMap<String, String>()
				, new HashMap<String, String>()
				, new HashMap<String, Long>()
				, new HashMap<String, Date>()
				, new HashMap<String, Boolean>()
				, new HashMap<String, BigDecimal>()
				, new HashMap<String, Double>()
				, new HashMap<String, Integer>()
				, new HashMap<String, Long>()
				);
	}

	@JsonIgnore
	public void addSourceId(String key, Long valor) {
		idOrigen.put(key, valor);
	}

	@JsonIgnore
	public void addCodigo(String key, String codigo) {
		this.codigo.put(key, codigo);
	}
	
	@JsonIgnore
	public void addGuid(String key, String guid) {
		this.guid.put(key, guid);
	}

	@JsonIgnore
	public void addFecha(String key, Date fecha) {
		this.fecha.put(key, fecha);
	}

	@JsonIgnore
	public void addFlag(String key, Boolean flag) {
		this.flag.put(key, flag);
	}
	
	@JsonIgnore
	public void addExtraInfo(String key, String valor) {
		extraInfo.put(key, valor);
	}

	@JsonIgnore
	public void addNumber(String key, BigDecimal valor) {
		valBDec.put(key, valor);
	}

	@JsonIgnore
	public void addNumber(String key, Double valor) {
		valDouble.put(key, valor);
	}

	@JsonIgnore
	public void addNumber(String key, Integer valor) {
		valInt.put(key, valor);
	}

	@JsonIgnore
	public void addNumber(String key, Long valor) {
		valLong.put(key, valor);
	}
	
	@JsonProperty
	public Map<String, Long> getIdOrigen() {
		return idOrigen;
	}

	@JsonProperty
	public Map<String, String> getCodigo() {
		return codigo;
	}
	
	@JsonProperty
	public Map<String, String> getGuid() {
		return guid;
	}

	@JsonProperty
	public Map<String, String> getExtraInfo() {
		return extraInfo;
	}

	@JsonProperty
	public Map<String, Date> getFecha() {
		return fecha;
	}

	@JsonProperty
	public Map<String, Boolean> getFlag() {
		return flag;
	}

	@JsonProperty
	public Map<String, BigDecimal> getValBDec() {
		return valBDec;
	}

	@JsonProperty
	public Map<String, Integer> getValInt() {
		return valInt;
	}

	@JsonProperty
	public Map<String, Double> getValDouble() {
		return valDouble;
	}

	@JsonProperty
	public Map<String, Long> getValLong() {
		return valLong;
	}
	
}
