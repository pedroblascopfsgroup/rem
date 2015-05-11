package es.pfsgroup.concursal.credito.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.springframework.core.annotation.Order;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "DD_STD_CREDITO", schema = "${master.schema}")
public class DDEstadoCredito implements Serializable, Auditable{
	
	public static final String CODIGO_NO_INSINUADO = "11";
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8607368809090075865L;

	@Id
	@Column(name = "STD_CRE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TipoCreditoGenerator")
	@SequenceGenerator(name = "TipoCreditoGenerator", sequenceName = "S_DD_STD_CREDITO")
	private Long id;
	
	@Column(name = "STD_CRE_CODIGO")
    private String codigo;

    @Column(name = "STD_CRE_DESCRIP")
    private String descripcion;

    @Column(name = "STD_CRE_DESCRIP_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
	
	
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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	

}
