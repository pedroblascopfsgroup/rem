package es.pfsgroup.recovery.integration;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

public class DataContainerPayload extends TypePayload {

	// Codigos identificativos operacionales.
	private Map<String, Long> idOrigen;
	private Map<String, String> codigo;
	private Map<String, String> guid;
	private Map<String, Date> fecha;
	private Map<String, Boolean> flag;
	private Map<String, String> extraInfo;
	private Map<String, Float> valFloat;
	private Map<String, BigDecimal> valBDec;
	private Map<String, Double> valDouble;
	private Map<String, Integer> valInt;
	private Map<String, Long> valLong;

	private Map<String, List<String>> relaciones;
	private Map<String, List<DataContainerPayload>> children;
	
	@JsonCreator
	public DataContainerPayload(@JsonProperty("tipo") String tipo,
			@JsonProperty("entidad") String entidad,
			@JsonProperty("codigo") Map<String, String> codigo,
			@JsonProperty("guid") Map<String, String> guid,
			@JsonProperty("extraInfo") Map<String, String> extraInfo,
			@JsonProperty("idOrigen") Map<String, Long> idOrigen,
			@JsonProperty("fecha") Map<String, Date> fecha,
			@JsonProperty("flag") Map<String, Boolean> flag,
			@JsonProperty("valFloat") Map<String, Float> valFloat,
			@JsonProperty("valBDec") Map<String, BigDecimal> valBDec,
			@JsonProperty("valDouble") Map<String, Double> valDouble,
			@JsonProperty("valInt") Map<String, Integer> valInt,
			@JsonProperty("valLong") Map<String, Long> valLong,
			@JsonProperty("relaciones") Map<String, List<String>> relaciones,
			@JsonProperty("children") Map<String, List<DataContainerPayload>> children
			) {
		super(tipo, entidad);
		this.guid = guid;
		this.codigo = codigo;
		this.idOrigen = idOrigen;
		this.fecha = fecha;
		this.flag = flag;
		this.valFloat = valFloat;
		this.valBDec = valBDec;
		this.valDouble = valDouble;
		this.valInt = valInt;
		this.extraInfo = extraInfo;
		this.valLong = valLong;
		this.relaciones = relaciones;
		this.children = children;
	}
	
	public DataContainerPayload(String tipo, String entidad) {
		this(tipo
				, entidad
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				);
	}

	@JsonIgnore
	public void addSourceId(String key, Long valor) {
		if (idOrigen==null) {
			this.idOrigen = new HashMap<String, Long>();
		}
		idOrigen.put(key, valor);
	}

	@JsonIgnore
	public void addCodigo(String key, String valor) {
		if (codigo==null) {
			this.codigo = new HashMap<String, String>();
		}
		this.codigo.put(key, valor);
	}
	
	@JsonIgnore
	public void addGuid(String key, String valor) {
		if (this.guid==null) {
			this.guid = new HashMap<String, String>();
		}
		this.guid.put(key, valor);
	}

	@JsonIgnore
	public void addRelacion(String listKey, String guid) {
		if (this.relaciones == null) {
			this.relaciones = new HashMap<String, List<String>>();
		}
		if (!this.relaciones.containsKey(listKey) ||
				this.relaciones.get(listKey) == null) {
			this.relaciones.put(listKey, new ArrayList<String>());
		}
		this.relaciones.get(listKey).add(guid);
	}

	@JsonIgnore
	public void addChildren(String listKey, DataContainerPayload valor) {
		if (this.children == null) {
			this.children = new HashMap<String, List<DataContainerPayload>>();
		}
		if (!this.children.containsKey(listKey) ||
				this.children.get(listKey) == null) {
			this.children.put(listKey, new ArrayList<DataContainerPayload>());
		}
		this.children.get(listKey).add(valor);
	}
	
	@JsonIgnore
	public void addFecha(String key, Date valor) {
		if (this.fecha == null) {
			this.fecha = new HashMap<String, Date>();			
		}
		this.fecha.put(key, valor);
	}

	@JsonIgnore
	public void addFlag(String key, Boolean valor) {
		if (this.flag == null) {
			this.flag = new HashMap<String, Boolean>();			
		}
		this.flag.put(key, valor);
	}
	
	@JsonIgnore
	public void addExtraInfo(String key, String valor) {
		if (this.extraInfo == null) {
			this.extraInfo = new HashMap<String, String>();			
		}
		extraInfo.put(key, valor);
	}

	@JsonIgnore
	public void addNumber(String key, Float valor) {
		if (this.valFloat == null) {
			this.valFloat = new HashMap<String, Float>();			
		}
		valFloat.put(key, valor);
	}
	
	@JsonIgnore
	public void addNumber(String key, BigDecimal valor) {
		if (this.valBDec == null) {
			this.valBDec = new HashMap<String, BigDecimal>();			
		}
		valBDec.put(key, valor);
	}

	@JsonIgnore
	public void addNumber(String key, Double valor) {
		if (this.valDouble == null) {
			this.valDouble = new HashMap<String, Double>();			
		}
		valDouble.put(key, valor);
	}

	@JsonIgnore
	public void addNumber(String key, Integer valor) {
		if (this.valInt == null) {
			this.valInt = new HashMap<String, Integer>();			
		}
		valInt.put(key, valor);
	}

	@JsonIgnore
	public void addNumber(String key, Long valor) {
		if (this.valLong == null) {
			this.valLong = new HashMap<String, Long>();			
		}
		valLong.put(key, valor);
	}
	
	@JsonProperty
	public Map<String, Long> getIdOrigen() {
		return idOrigen;
	}

	@JsonIgnore
	public Long getIdOrigen(String key) {
		return (this.idOrigen!=null && this.idOrigen.containsKey(key)) ? this.idOrigen.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, String> getCodigo() {
		return codigo;
	}

	@JsonIgnore
	public String getCodigo(String key) {
		return (this.codigo!=null && this.codigo.containsKey(key)) ? this.codigo.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, String> getGuid() {
		return guid;
	}

	@JsonIgnore
	public String getGuid(String key) {
		return (this.guid!=null && this.guid.containsKey(key)) ? this.guid.get(key) : null;
	}

	@JsonProperty
	public Map<String, String> getExtraInfo() {
		return extraInfo;
	}

	@JsonIgnore
	public String getExtraInfo(String key) {
		return (this.extraInfo!=null && this.extraInfo.containsKey(key)) ? this.extraInfo.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, Date> getFecha() {
		return fecha;
	}

	@JsonIgnore
	public Date getFecha(String key) {
		return (this.fecha!=null && this.fecha.containsKey(key)) ? this.fecha.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, Boolean> getFlag() {
		return flag;
	}

	@JsonIgnore
	public Boolean getFlag(String key) {
		return (this.flag!=null && this.flag.containsKey(key)) ? this.flag.get(key) : null;
	}

	@JsonProperty
	public Map<String, Float> getValFloat() {
		return valFloat;
	}

	@JsonIgnore
	public Float getValFloat(String key) {
		return (this.valFloat!=null && this.valFloat.containsKey(key)) ? this.valFloat.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, BigDecimal> getValBDec() {
		return valBDec;
	}

	@JsonIgnore
	public BigDecimal getValBDec(String key) {
		return (this.valBDec!=null && this.valBDec.containsKey(key)) ? this.valBDec.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, Integer> getValInt() {
		return valInt;
	}

	@JsonIgnore
	public Integer getValInt(String key) {
		return (this.valInt!=null && this.valInt.containsKey(key)) ? this.valInt.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, Double> getValDouble() {
		return valDouble;
	}

	@JsonIgnore
	public Double getValDouble(String key) {
		return (this.valDouble!=null && this.valDouble.containsKey(key)) ? this.valDouble.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, Long> getValLong() {
		return valLong;
	}

	@JsonIgnore
	public Long getValLong(String key) {
		return (this.valLong!=null && this.valLong.containsKey(key)) ? this.valLong.get(key) : null;
	}
	
	@JsonProperty
	public Map<String, List<String>> getRelaciones() {
		return relaciones;
	}

	@JsonIgnore
	public List<String> getRelaciones(String key) {
		return (this.relaciones!=null && this.relaciones.containsKey(key)) ? this.relaciones.get(key) : null;
	}

	@JsonProperty
	public Map<String, List<DataContainerPayload>> getChildren() {
		return children;
	}

	@JsonIgnore
	public List<DataContainerPayload> getChildren(String key) {
		return (this.children!=null && this.children.containsKey(key)) ? this.children.get(key) : null;
	}
	
}
