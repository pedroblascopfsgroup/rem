package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;


/**
 * Modelo que gestiona las reglas de publicación automática de los activos sin preciar.
 */
@Entity
@Table(name = "ACT_RPA_REGLAS_PUBLICA_AUTO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoReglasPublicacionAutomatica implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;


    @Id
    @Column(name = "RPA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoReglasPublicacionAutomaticaGenerator")
    @SequenceGenerator(name = "ActivoReglasPublicacionAutomaticaGenerator", sequenceName = "S_ACT_RPA_REGLAS_PUBLICA_AUTO")
    private Long id;

    @Column(name = "RPA_INCLUIDO_AGR_ASISTIDA")
	private int incluidoAgrupacionAsistida; 
    
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPA_ID")
	private DDTipoActivo tipoActivo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAC_ID")
    private DDSubtipoActivo subtipoActivo;

	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;



    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public int getIncluidoAgrupacionAsistida() {
		return incluidoAgrupacionAsistida;
	}

	public void setIncluidoAgrupacionAsistida(int incluidoAgrupacionAsistida) {
		this.incluidoAgrupacionAsistida = incluidoAgrupacionAsistida;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}	
}