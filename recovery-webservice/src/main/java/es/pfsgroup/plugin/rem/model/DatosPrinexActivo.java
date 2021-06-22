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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;

/**
 * Modelo que gestiona ciertos datos prinex del activo
 * 
 * @author Adrián Molina
 */
@Entity
@Table(name = "DPA_DATOS_PRINEX_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DatosPrinexActivo implements Serializable, Auditable {


	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "DPA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DatosPrinexActivoGenerator")
    @SequenceGenerator(name = "DatosPrinexActivoGenerator", sequenceName = "S_DPA_DATOS_PRINEX_ACTIVO")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;

    @Column(name = "DPA_DISP_ADMINISTRATIVO")
	private Boolean dispAdministrativa;
    
	@Column(name = "DPA_DISP_TECNICO")
  	private Boolean dispTecnico;

	@Column(name = "DPA_MOTIVO_TECNICO")
  	private String motivoTecnico;
    
	@Column(name = "DPA_COSTE_ADQUISICION")
  	private Double costeAdquisicion;
    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}
	
	public Boolean getDispAdministrativa() {
		return dispAdministrativa;
	}

	public void setDispAdministrativa(Boolean dispAdministrativa) {
		this.dispAdministrativa = dispAdministrativa;
	}
	
	public Boolean getDispTecnico() {
		return dispTecnico;
	}

	public void setDispTecnico(Boolean dispTecnico) {
		this.dispTecnico = dispTecnico;
	}
	
	public String getMotivoTecnico() {
		return motivoTecnico;
	}

	public void setMotivoTecnico(String motivoTecnico) {
		this.motivoTecnico = motivoTecnico;
	}

	public Double getCosteAdquisicion() {
		return costeAdquisicion;
	}

	public void setCosteAdquisicion(Double costeAdquisicion) {
		this.costeAdquisicion = costeAdquisicion;
	}
	
	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	
}
