package es.pfsgroup.framework.paradise.bulkUpload.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;

/**
 * Clase que modela el diccionario de tipos de resoluci�n.
 * Una resoluci�n tiene asociada un tipo de juicio.
 * @author manuel
 *
 */
@Entity
@Table(name = "DD_TR_TIPOS_RESOLUCION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class MSVDDTipoResolucion implements Serializable, Auditable{

	private static final long serialVersionUID = -3027099880437327403L;
	
	@Id
    @Column(name = "DD_TR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDDTipoResolucionGenerator")
    @SequenceGenerator(name = "MSVDDTipoResolucionGenerator", sequenceName = "S_DD_TR_TIPOS_RESOLUCION")
    private Long id;

    @Column(name = "DD_TR_CODIGO")
    private String codigo;

    @Column(name = "DD_TR_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TR_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @ManyToOne
    @JoinColumn(name = "DD_TJ_ID")
    private MSVDDTipoJuicio tipoJuicio;
    
    @ManyToOne
    @JoinColumn(name = "BPM_DD_TAC_ID")
    private RecoveryBPMfwkDDTipoAccion tipoAccion;

	@Column(name = "DD_TR_AYUDA")
    private String ayuda;

	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    
    @Column(name = "DD_TR_CATEGORIZAR")
    private boolean categorizar;

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

    public MSVDDTipoJuicio getTipoJuicio() {
		return tipoJuicio;
	}

	public void setTipoJuicio(MSVDDTipoJuicio tipoJuicio) {
		this.tipoJuicio = tipoJuicio;
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

	public String getAyuda() {
		return ayuda;
	}

	public void setAyuda(String ayuda) {
		this.ayuda = ayuda;
	}
    
    public RecoveryBPMfwkDDTipoAccion getTipoAccion() {
		return tipoAccion;
	}

	public void setTipoAccion(RecoveryBPMfwkDDTipoAccion tipoAccion) {
		this.tipoAccion = tipoAccion;
	}	
	
	public boolean getCategorizar() {
		return categorizar;
	}

	public void setCategorizar(boolean categorizar) {
		this.categorizar = categorizar;
	}
    
}
