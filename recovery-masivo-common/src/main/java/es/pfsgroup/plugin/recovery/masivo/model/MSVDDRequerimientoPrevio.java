package es.pfsgroup.plugin.recovery.masivo.model;

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
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_RPR_REQUERIMIENTO_PREVIO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDDRequerimientoPrevio implements Auditable, Dictionary{
	
	public static final String CODIGO_APORTACION_CONTRATO = "ACNT";
	public static final String CODIGO_APORTACION_PODER_CON_PROC = "APCP";
	public static final String CODIGO_APORTACION_PODER_SIN_PROC = "APSP";
	public static final String CODIGO_FIRMA_DEMANDA = "FDM";
	public static final String CODIGO_RATIFICACION_DEMANDA= "RDM";
	public static final String CODIGO_APORTACION_COPIA_DEMANDA = "ACDM";
	public static final String CODIGO_SUBSANACION_COPIA_DEMANDA = "SCDM";
	public static final String CODIGO_SUBSANACION_DATOS_DEM = "SDD";
	public static final String CODIGO_CESION_CREDITO = "CSC";
	public static final String CODIGO_APORTACION_TASAS = "ATJ";
	public static final String CODIGO_APORTACION_CERTIF_DEUDA = "ACD";
	public static final String CODIGO_ACLARACION_DEUDA = "ADD";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6817572151703651723L;

	@Id
    @Column(name = "DD_RPR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDDRequerimientoPrevioGenerator")
    @SequenceGenerator(name = "MSVDDRequerimientoPrevioGenerator", sequenceName = "S_DD_RPR_REQUERIMIENTO_PREVIO")
    private Long id;

    @Column(name = "DD_RPR_CODIGO")
    private String codigo;

    @Column(name = "DD_RPR_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_RPR_DESCRIPCION_LARGA")
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
