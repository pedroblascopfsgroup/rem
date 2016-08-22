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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "POP_PLANTILLAS_OPERACION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVPlantillaOperacion implements Serializable, Auditable {

	private static final long serialVersionUID = -3830798609542073564L;

	@Id
    @Column(name = "POP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVPlantillaOperacionGenerator")
    @SequenceGenerator(name = "MSVPlantillaOperacionGenerator", sequenceName = "S_POP_PLANTILLAS_OPERACION")
    private Long id;

    @Column(name = "POP_NOMBRE")
    private String nombre;
    
    @Column(name = "POP_DIRECTORIO")
    private String directorio;
    
    @ManyToOne
    @JoinColumn(name = "DD_OPM_ID")
    private MSVDDOperacionMasiva tipoOperacion;
    
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDirectorio() {
		return directorio;
	}

	public void setDirectorio(String directorio) {
		this.directorio = directorio;
	}

	public MSVDDOperacionMasiva getTipoOperacion() {
		return tipoOperacion;
	}

	public void setTipoOperacion(MSVDDOperacionMasiva tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
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
