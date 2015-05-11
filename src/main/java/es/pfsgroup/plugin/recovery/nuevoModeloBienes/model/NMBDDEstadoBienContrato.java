package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBDDEstadoBienContratoInfo;

@Entity
@Table(name = "DD_EBC_ESTADO_BIEN_CNT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBDDEstadoBienContrato implements  Serializable, Auditable, NMBDDEstadoBienContratoInfo{

	public static final String COD_ESTADO_BIEN_SOLICITADO 	= "1";
	public static final String COD_ESTADO_BIEN_ACTIVO 		= "2";
	public static final String COD_ESTADO_BIEN_INACTIVO 	= "3";
	
	private static final long serialVersionUID = -4497097910086775262L;

	@Id
    @Column(name = "DD_EBC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBEstadoBienContratoGenerator")
    @SequenceGenerator(name = "NMBEstadoBienContratoGenerator", sequenceName = "S_DD_EBC_ESTADO_BIEN_CNT")
    private Long id;

    @Column(name = "DD_EBC_CODIGO")
    private String codigo;   
    
    @Column(name = "DD_EBC_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "DD_EBC_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
