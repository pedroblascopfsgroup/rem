package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model;

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
 * Clase que mapea el diccionario de datos de posibles estados de un proceso de facturacion
 * @author diana
 *
 */
@Entity
@Table(name = "RCF_DD_EPF_ESTADO_PROC_FAC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroDDEstadoProcesoFacturable implements Auditable, Dictionary {
	
	public static final String RCF_ESTADO_PROCESO_FACTURACION_LIBERADO = "LBR";
	public static final String RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE = "PTE";
	public static final String RCF_ESTADO_PROCESO_FACTURACION_PROCESADO = "PRC";
	public static final String RCF_ESTADO_PROCESO_FACTURACION_CANCELADO = "CNL";
	public static final String RCF_ESTADO_PROCESO_FACTURACION_CON_ERRORES = "PER";
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6395890999051487693L;

	@Id
    @Column(name = "RCF_DD_EPF_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoProcesoFacturableGenerator")
	@SequenceGenerator(name = "DDEstadoProcesoFacturableGenerator", sequenceName = "S_RCF_DD_EPF_ESTADO_PROC_FAC")
    private Long id;

    @Column(name = "RCF_DD_EPF_CODIGO")
    private String codigo;

    @Column(name = "RCF_DD_EPF_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "RCF_DD_EPF_DESCRIPCION_LARGA")
    private String descripcionLarga;

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

	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}
    
    

}
