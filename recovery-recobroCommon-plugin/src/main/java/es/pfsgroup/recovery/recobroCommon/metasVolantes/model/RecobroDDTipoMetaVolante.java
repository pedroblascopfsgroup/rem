package es.pfsgroup.recovery.recobroCommon.metasVolantes.model;

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
 * Clase donde se mapean los tipos de metas volantes
 * @author Vanesa
 *
 */
@Entity
@Table(name = "RCF_DD_MET_META_VOLANTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroDDTipoMetaVolante implements Auditable, Dictionary{
	
	private static final long serialVersionUID = -4807464097772185758L;
	
	public static final String RCF_TIPO_META_INTENTO_CONTACTO = "SCO";
	public static final String RCF_TIPO_META_CONTACTO_UTIL = "CUT";
	public static final String RCF_TIPO_META_COMPROMISO_PAGO = "CPA";		
	public static final String RCF_TIPO_META_COBRO_PARCIAL = "CBP";
	public static final String RCF_TIPO_META_COBRO_TOTAL = "CBT";

	@Id
    @Column(name = "RCF_DD_MET_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TipoMetaVolanteGenerator")
	@SequenceGenerator(name = "TipoMetaVolanteGenerator", sequenceName = "S_RCF_DD_MET_META_VOLANTE")
    private Long id;

	@Column(name = "RCF_DD_MET_ORDEN")
    private Long orden;
	
    @Column(name = "RCF_DD_MET_CODIGO")
    private String codigo;

    @Column(name = "RCF_DD_MET_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "RCF_DD_MET_DES_LARGA")
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

	public Long getOrden() {
		return orden;
	}

	public void setOrden(Long orden) {
		this.orden = orden;
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

}
