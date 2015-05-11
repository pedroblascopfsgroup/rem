package es.pfsgroup.plugin.recovery.masivo.model.altas;

import java.io.Serializable;
import java.util.Date;
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
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAltaLotesColumns;

@Entity
@Table(name = "LIN_LOTES_NUEVOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVAltaLote implements Serializable{

	private static final long serialVersionUID = -7680521269521718523L;

	private static final String NO = "N";

	public static MSVAltaLote create(Map<String, Object> map) {
		
		MSVAltaLote altaLote = new MSVAltaLote();
		
		altaLote.setNumeroCaso((String)map.get(MSVAltaLotesColumns.N_CASO));
		altaLote.setNumeroLote((String)map.get(MSVAltaLotesColumns.N_LOTE));
		altaLote.setReferencia((String)map.get(MSVAltaLotesColumns.N_REFERENCIA));
		altaLote.setDespacho(getLong((String)map.get(MSVAltaLotesColumns.DESPACHO)));
		altaLote.setLetrado((String)map.get(MSVAltaLotesColumns.LETRADO));
		altaLote.setGrupo((String)map.get(MSVAltaLotesColumns.GRUPO_DE_GESTORES));
		altaLote.setTipoProcedimiento(getLong((String)map.get(MSVAltaLotesColumns.TIPO_DE_PROCEDIMIENTO)));
		altaLote.setConProcurador((String)map.get(MSVAltaLotesColumns.CON_PROCURADOR));
		altaLote.setProcurador((String)map.get(MSVAltaLotesColumns.PROCURADOR));		
		altaLote.setConContrato((String)map.get(MSVAltaLotesColumns.CON_CONTRATO));
		altaLote.setConTestimonio((String)map.get(MSVAltaLotesColumns.CON_TESTIMONIO));
		altaLote.setProcesoMasivo((MSVProcesoMasivo) map.get(MSVAltaLotesColumns.ID_PROCESO_MASIVO));
		
		altaLote.setCreado(NO);
		altaLote.setFechaAlta(new Date());
		
		return altaLote;
	}
	
	private static Long getLong(String valor){
		try{
			return Long.valueOf(valor);
		}catch (Exception ex){
			return null;
		}
		
	}	

	@Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVAltaLoteGenerator")
    @SequenceGenerator(name = "MSVAltaLoteGenerator", sequenceName = "S_LIN_LOTES_NUEVOS")	
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "N_CASO")
	private String numeroCaso;
	
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
	
	@Column(name = "CON_PROCURADOR")
	private String conProcurador;
	
	@Column(name = "PROCURADOR")
	private String procurador;	

	@Column(name = "CON_CONTRATO")
	private String conContrato;
	
	@Column(name = "CON_TESTIMONIO")
	private String conTestimonio;
	
	@ManyToOne
    @JoinColumn(name = "PRM_ID")
    private MSVProcesoMasivo procesoMasivo;
	
//	@Column(name = "LOTE")
//	private String lote;

	@Version
    private Integer version;
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNumeroCaso() {
		return numeroCaso;
	}

	public void setNumeroCaso(String numeroCaso) {
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

	public String getConProcurador() {
		return conProcurador;
	}

	public void setConProcurador(String conProcurador) {
		this.conProcurador = conProcurador;
	}

	public String getConContrato() {
		return conContrato;
	}

	public void setConContrato(String conContrato) {
		this.conContrato = conContrato;
	}
	
    public String getConTestimonio() {
		return conTestimonio;
	}

	public void setConTestimonio(String conTestimonio) {
		this.conTestimonio = conTestimonio;
	}

//	public String getLote() {
//		return lote;
//	}
//
//	public void setLote(String lote) {
//		this.lote = lote;
//	}

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
	
	
	public String getProcurador() {
		return procurador;
	}

	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}

}
