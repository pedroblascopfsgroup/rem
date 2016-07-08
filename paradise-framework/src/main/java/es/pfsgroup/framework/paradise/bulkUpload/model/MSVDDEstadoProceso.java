package es.pfsgroup.framework.paradise.bulkUpload.model;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "DD_EPF_ESTADO_PROCES_FICH", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDDEstadoProceso implements Serializable, Auditable {
	
	public static final String CODIGO_CARGANDO 				= "CRG";
	public static final String CODIGO_PTE_VALIDAR 			= "PTV";
	public static final String CODIGO_VALIDADO 				= "VAL";
	public static final String CODIGO_PTE_PROCESAR 			= "PTP";
	public static final String CODIGO_EN_PROCESO 				= "EPR";
	public static final String CODIGO_PROCESADO 				= "PRC";
	public static final String CODIGO_ERROR 					= "ERR";
	public static final String CODIGO_PROCESADO_CON_ERRORES 	= "PRE";
	
	public static final String CODIGO_INCOMPLETO 				= "INC";
	
	public static final String CODIGO_RECHAZADO				= "RCH";
	
	public static final String CODIGO_PAUSADO				= "PAU";
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 6712489638271264576L;
	
	@Id
    @Column(name = "DD_EPF_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDDEstadoProcesoGenerator")
    @SequenceGenerator(name = "MSVDDEstadoProcesoGenerator", sequenceName = "S_DD_EPF_ESTADO_PROCES_FICH")
    private Long id;

    @Column(name = "DD_EPF_CODIGO")
    private String codigo;

    @Column(name = "DD_EPF_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_EPF_DESCRIPCION_LARGA")
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
