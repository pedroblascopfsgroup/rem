package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.*;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.io.Serializable;


/**
 * Modelo que gestiona la informacion adicional de una persona asociaca a BC Caixa
 *  
 * @author Jesus Jativa
 *
 */
@Entity
@Table(name = "IAP_INFO_ADC_PERSONA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class InfoAdicionalPersona implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

		
	@Id
    @Column(name = "IAP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "InfoAdicionalPersona")
    @SequenceGenerator(name = "InfoAdicionalPersona", sequenceName = "S_IAP_INFO_ADC_PERSONA")
    private Long id;

	@Column(name = "ID_PERSONA_HAYA")
	private String idPersonaHaya;

	@Column(name = "C4C_ID")
	private String idC4C;

	@ManyToOne
	@JoinColumn(name = "DD_CNO_ID")
	private DDCnOcupacional cnOcupacional;

	@ManyToOne
	@JoinColumn(name = "DD_ACE_ID")
	private DDCnae Cnae;

	@ManyToOne
	@JoinColumn(name = "DD_TSC_ID")
	private DDTipoSocioComercial tipoSocioComercial;

	@ManyToOne
	@JoinColumn(name = "DD_TRI_ID")
	private DDRolInterlocutor rolInterlocutor;

	@ManyToOne
	@JoinColumn(name = "DD_FOJ_ID")
	private DDFormaJuridica formaJuridica;

	@ManyToOne
	@JoinColumn(name = "DD_ECC_ID")
	private DDEstadoComunicacionC4C estadoComunicacionC4C;

	@Column(name = "IAP_MODIFICA_PBC")
	private Boolean modificaPBC;

	@Column(name = "IAP_PRP")
	private Boolean prp;
	
	@ManyToOne
	@JoinColumn(name = "DD_VIC_ID")
	private DDVinculoCaixa vinculoCaixa;


	@Embedded
	private Auditoria auditoria;


	@Version   
	private Long version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}

	public String getIdC4C() {
		return idC4C;
	}

	public void setIdC4C(String idC4C) {
		this.idC4C = idC4C;
	}

	public DDCnOcupacional getCnOcupacional() {
		return cnOcupacional;
	}

	public void setCnOcupacional(DDCnOcupacional cnOcupacional) {
		this.cnOcupacional = cnOcupacional;
	}

	public DDCnae getCnae() {
		return Cnae;
	}

	public void setCnae(DDCnae cnae) {
		Cnae = cnae;
	}

	public DDTipoSocioComercial getTipoSocioComercial() {
		return tipoSocioComercial;
	}

	public void setTipoSocioComercial(DDTipoSocioComercial tipoSocioComercial) {
		this.tipoSocioComercial = tipoSocioComercial;
	}

	public DDRolInterlocutor getRolInterlocutor() {
		return rolInterlocutor;
	}

	public void setRolInterlocutor(DDRolInterlocutor rolInterlocutor) {
		this.rolInterlocutor = rolInterlocutor;
	}

	public DDFormaJuridica getFormaJuridica() {
		return formaJuridica;
	}

	public void setFormaJuridica(DDFormaJuridica formaJuridica) {
		this.formaJuridica = formaJuridica;
	}

	public DDEstadoComunicacionC4C getEstadoComunicacionC4C() {
		return estadoComunicacionC4C;
	}

	public void setEstadoComunicacionC4C(DDEstadoComunicacionC4C estadoComunicacionC4C) {
		this.estadoComunicacionC4C = estadoComunicacionC4C;
	}

	public Boolean getModificaPBC() {
		return modificaPBC;
	}

	public void setModificaPBC(Boolean modificaPBC) {
		this.modificaPBC = modificaPBC;
	}

	public Boolean getPrp() {
		return prp;
	}

	public void setPrp(Boolean prp) {
		this.prp = prp;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public DDVinculoCaixa getVinculoCaixa() {
		return vinculoCaixa;
	}

	public void setVinculoCaixa(DDVinculoCaixa vinculoCaixa) {
		this.vinculoCaixa = vinculoCaixa;
	}

}
