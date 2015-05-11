package es.pfsgroup.recovery.recobroCommon.esquema.model;

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

/**
 * Clase donde se mapean los posibles estados de un esquema
 * @author Diana
 *
 */
@Entity
@Table(name = "RCF_DD_EES_ESTADO_ESQUEMA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroDDEstadoEsquema implements Auditable, Dictionary{
	
	public static final String RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO  		  = "LBR";
	public static final String RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTELIBERAR = "PLB";
	public static final String RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTESIMULAR = "PTS";
	public static final String RCF_DD_EES_ESTADO_ESQUEMA_DEFINICION 	  = "DEF";
	public static final String RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO  		  = "SML";
	public static final String RCF_DD_EES_ESTADO_ESQUEMA_EXTINCION 		  = "EXG";
	public static final String RCF_DD_EES_ESTADO_ESQUEMA_DESACTIVADO 	  = "DSA";
	
	private static final long serialVersionUID = -4807464097772185758L;

	@Id
    @Column(name = "RCF_DD_EES_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EstadoEsquemaGenerator")
	@SequenceGenerator(name = "EstadoEsquemaGenerator", sequenceName = "S_RCF_DD_EES_ESTADO_ESQUEMA")
    private Long id;

    @Column(name = "RCF_DD_EES_CODIGO")
    private String codigo;

    @Column(name = "RCF_DD_EES_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "RCF_DD_EES_DESCRIPCION_LARGA")
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

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}
    
    

}
