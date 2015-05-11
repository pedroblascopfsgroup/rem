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
 * Diccionario de tipos de cobros para el modelo de recobro
 * @author diana
 *
 */
@Entity
@Table(name = "RCF_DD_TCB_TIPO_COBRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroDDTipoCobro implements Auditable, Dictionary{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7712267087529763704L;

	@Id
    @Column(name = "RCF_DD_TCB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroDDTipoCobroGenerator")
	@SequenceGenerator(name = "RecobroDDTipoCobroGenerator", sequenceName = "S_RCF_DD_TCB_TIPO_COBRO")
    private Long id;

    @Column(name = "RCF_DD_TCB_CODIGO")
    private String codigo;

    @Column(name = "RCF_DD_TCB_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "RCF_DD_TCB_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Column(name = "RCF_DD_TCB_FACTURABLE")
    private Boolean facturable;
    
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

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
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

	public Boolean getFacturable() {
		return facturable;
	}

	public void setFacturable(Boolean facturable) {
		this.facturable = facturable;
	}
    
    

}
