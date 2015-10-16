package es.pfsgroup.recovery.ext.turnadodespachos;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "ETC_ESQUEMA_TURNADO_CONFIG", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class EsquemaTurnadoConfig implements Serializable, Auditable {

	public static final String TIPO_CONCURSAL_IMPORTE = "CI";
	public static final String TIPO_CONCURSAL_CALIDAD = "CC";
	public static final String TIPO_LITIGIOS_IMPORTE = "LI";
	public static final String TIPO_LITIGIOS_CALIDAD = "LC";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ETC_ID")
 	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EsquemaTurnadoConfigGenerator")
    @SequenceGenerator(name = "EsquemaTurnadoConfigGenerator", sequenceName = "S_ETC_ESQUEMA_TURNADO_CONFIG")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ETU_ID")
	private EsquemaTurnado esquema;

	@Column(name = "ETU_TIPO")
	private String tipo;

	@Column(name = "ETU_CLAVE")
	private String clave;

	@Column(name = "ETU_IMPORTE_DESDE")
	private Double importeDesde;

	@Column(name = "ETU_IMPORTE_HASTA")
	private Double importeHasta;

	@Column(name = "ETU_PORCENTAJE")
	private Double porcentaje;
	
    @Embedded
    private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public EsquemaTurnado getEsquema() {
		return esquema;
	}

	public void setEsquema(EsquemaTurnado esquema) {
		this.esquema = esquema;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getClave() {
		return clave;
	}

	public void setClave(String clave) {
		this.clave = clave;
	}

	public Double getImporteDesde() {
		return importeDesde;
	}

	public void setImporteDesde(Double importeDesde) {
		this.importeDesde = importeDesde;
	}

	public Double getImporteHasta() {
		return importeHasta;
	}

	public void setImporteHasta(Double importeHasta) {
		this.importeHasta = importeHasta;
	}

	public Double getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Double porcentaje) {
		this.porcentaje = porcentaje;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
