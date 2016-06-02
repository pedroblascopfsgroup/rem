package es.pfsgroup.plugin.recovery.masivo.model.altas;

import java.io.Serializable;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAltaContratosColumns;

@Entity
@Table(name = "LIN_ASUNTOS_NUEVOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVAltaAsunto implements Serializable{

	private static final long serialVersionUID = 832018663773995970L;

	private static final String NO = "N";
	
	private static DecimalFormat format;

	public static synchronized MSVAltaAsunto create(Map<String, Object> map) {
		
		DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("es"));
		//symbols.setDecimalSeparator(',');
		format = new DecimalFormat("0.#", symbols);
		//format.setDecimalFormatSymbols(symbols);
		
		MSVAltaAsunto altaAsunto = new MSVAltaAsunto();
		
		altaAsunto.setNumeroCaso(getLong((String)map.get(MSVAltaContratosColumns.N_CASO)));
		altaAsunto.setNumeroLote((String)map.get(MSVAltaContratosColumns.N_LOTE));
		altaAsunto.setReferencia((String)map.get(MSVAltaContratosColumns.N_REFERENCIA));
		altaAsunto.setDespacho(getLong((String)map.get(MSVAltaContratosColumns.DESPACHO)));
		altaAsunto.setLetrado((String)map.get(MSVAltaContratosColumns.LETRADO));
		altaAsunto.setGrupo((String)map.get(MSVAltaContratosColumns.GRUPO_DE_GESTORES));
		altaAsunto.setTipoProcedimiento(getLong((String)map.get(MSVAltaContratosColumns.TIPO_DE_PROCEDIMIENTO)));
		altaAsunto.setProcurador((String)map.get(MSVAltaContratosColumns.PROCURADOR));
		altaAsunto.setPlaza(getLong((String)map.get(MSVAltaContratosColumns.PLAZA)));
		altaAsunto.setJuzgado(getLong((String)map.get(MSVAltaContratosColumns.JUZGADO)));
		altaAsunto.setProcesoMasivo((MSVProcesoMasivo) map.get(MSVAltaContratosColumns.ID_PROCESO_MASIVO));
		
		Float valor = null;
		try {
			valor = format.parse((String)map.get(MSVAltaContratosColumns.PRINCIPAL)).floatValue();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		altaAsunto.setPrincipal(valor);
		
		altaAsunto.setCreado(NO);
		altaAsunto.setFechaAlta(new Date());
		
		return altaAsunto;
	}
	
	private static Long getLong(String valor){
		try{
			return Long.valueOf(valor);
		}catch (Exception ex){
			return null;
		}
		
	}
	
	@Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVAltaAsuntoGenerator")
    @SequenceGenerator(name = "MSVAltaAsuntoGenerator", sequenceName = "S_LIN_ASUNTOS_NUEVOS")	
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "N_CASO")
	private Long numeroCaso;
	
	@Column(name = "N_LOTE")
	private String numeroLote;

	@Column(name = "CREADO")
	private String creado;
	
	@Column(name = "FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "N_REFERENCIA")
	private String referencia;

	@Column(name = "DESPACHO")
	private Long despacho;
	
	@Column(name = "LETRADO")
	private String letrado;
	
	@Column(name = "GRUPO")
	private String grupo;
	
	@Column(name = "TIPO_PROC")
	private Long tipoProcedimiento;
	
	@Column(name = "PROCURADOR")
	private String procurador;
	
	@Column(name = "PLAZA")
	private Long plaza;
	
	@Column(name = "JUZGADO")
	private Long juzgado;
	
	@Column(name = "PRINCIPAL")
	private Float principal;
	
	@ManyToOne
    @JoinColumn(name = "PRM_ID")
    private MSVProcesoMasivo procesoMasivo;

	@Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNumeroCaso() {
		return numeroCaso;
	}

	public void setNumeroCaso(Long numeroCaso) {
		this.numeroCaso = numeroCaso;
	}

	public String getNumeroLote() {
		return numeroLote;
	}

	public void setNumeroLote(String numeroLote) {
		this.numeroLote = numeroLote;
	}
	
	public String getCreado() {
		return creado;
	}

	public void setCreado(String creado) {
		this.creado = creado;
	}

	public Date getFechaAlta() {
		return fechaAlta == null ? null : (Date) fechaAlta.clone();
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public String getReferencia() {
		return referencia;
	}

	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}

	public Long getDespacho() {
		return despacho;
	}

	public void setDespacho(Long despacho) {
		this.despacho = despacho;
	}

	public String getLetrado() {
		return letrado;
	}

	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	public Long getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(Long tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public String getProcurador() {
		return procurador;
	}

	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}

	public Long getPlaza() {
		return plaza;
	}

	public void setPlaza(Long plaza) {
		this.plaza = plaza;
	}

	public Long getJuzgado() {
		return juzgado;
	}

	public void setJuzgado(Long juzgado) {
		this.juzgado = juzgado;
	}

	public Float getPrincipal() {
		return principal;
	}

	public void setPrincipal(Float principal) {
		this.principal = principal;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	
	
    public MSVProcesoMasivo getProcesoMasivo() {
		return procesoMasivo;
	}

	public void setProcesoMasivo(MSVProcesoMasivo procesoMasivo) {
		this.procesoMasivo = procesoMasivo;
	}


}
