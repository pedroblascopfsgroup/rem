package es.pfsgroup.recovery.recobroCommon.facturacion.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Diccionario de tipos de conceptos de cobro para el modelo de facturacion
 * @author diana
 *
 */
@Entity
@Table(name = "RCF_DD_COC_CONCEPTO_COBRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecobroDDConceptoCobro implements Auditable, Dictionary{
	
	private static final long serialVersionUID = -2956679310260625615L;

	@Id
    @Column(name = "RCF_DD_COC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroDDTipoTarifaGenerator")
	@SequenceGenerator(name = "RecobroDDTipoTarifaGenerator", sequenceName = "S_RCF_DD_COC_CONCEPTO_COBRO")
    private Long id;

    @Column(name = "RCF_DD_COC_CODIGO")
    private String codigo;

    @Column(name = "RCF_DD_COC_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "RCF_DD_COC_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Column(name = "RCF_DD_COC_CPA_CONCEP_IMPORT")
    private String campoConceptoImporte;
    
    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}

	public String getCampoConceptoImporte() {
		return campoConceptoImporte;
	}

	public void setCampoConceptoImporte(String campoConceptoImporte) {
		this.campoConceptoImporte = campoConceptoImporte;
	}
	
}
