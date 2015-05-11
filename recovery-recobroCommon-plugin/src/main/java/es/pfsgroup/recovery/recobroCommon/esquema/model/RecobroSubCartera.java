package es.pfsgroup.recovery.recobroCommon.esquema.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;

/**
 * Clase que implementa la forma de repartir una cartera de clientes en diferentes subcarteras
 * @author Diana
 *
 */

@Entity
@Table(name = "RCF_SCA_SUBCARTERA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroSubCartera implements Auditable, Serializable {
	 
	 private static final long serialVersionUID = -8792180099258250925L;

	 @Id
	 @Column(name = "RCF_SCA_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "SubcarteraGenerator")
	 @SequenceGenerator(name = "SubcarteraGenerator", sequenceName = "S_RCF_SCA_SUBCARTERA")
	 private Long id;
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_ESC_ID", nullable = false)
	 private RecobroCarteraEsquema carteraEsquema;
	 
	 @Column(name = "RCF_SCA_NOMBRE")
	 private String nombre;
	 
	 @Column(name = "RCF_SCA_PARTICION")
	 private Integer particion;

	 @ManyToOne
	 @JoinColumn(name = "RCF_DD_TPR_ID", nullable = true)
	 private RecobroDDTipoRepartoSubcartera tipoRepartoSubcartera;
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_ITV_ID", nullable = true)
	 private RecobroItinerarioMetasVolantes itinerarioMetasVolantes; 	 
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_MFA_ID", nullable = true)
	 private RecobroModeloFacturacion modeloFacturacion; 
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_POA_ID", nullable = true)
	 private RecobroPoliticaDeAcuerdos politicaAcuerdos; 

	 @ManyToOne
	 @JoinColumn(name = "RCF_MOR_ID", nullable = true)
	 private RecobroModeloDeRanking modeloDeRanking; 
	 
	 @OneToMany(cascade = CascadeType.ALL)
	 @JoinColumn(name="RCF_SCA_ID")
	 @Where(clause=Auditoria.UNDELETED_RESTICTION)
	 private List<RecobroSubcarteraAgencia> agencias;
	 
	 @OneToMany(cascade = CascadeType.ALL)
	 @JoinColumn(name="RCF_SCA_ID")
	 @Where(clause=Auditoria.UNDELETED_RESTICTION)
	 private List<RecobroSubcarteraRanking> ranking;
	 
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
	
	public RecobroCarteraEsquema getCarteraEsquema() {
		return carteraEsquema;
	}

	public void setCarteraEsquema(RecobroCarteraEsquema carteraEsquema) {
		this.carteraEsquema = carteraEsquema;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Integer getParticion() {
		return particion;
	}

	public void setParticion(Integer particion) {
		this.particion = particion;
	}

	public RecobroItinerarioMetasVolantes getItinerarioMetasVolantes() {
		return itinerarioMetasVolantes;
	}

	public void setItinerarioMetasVolantes(
			RecobroItinerarioMetasVolantes itinerarioMetasVolantes) {
		this.itinerarioMetasVolantes = itinerarioMetasVolantes;
	}

	public RecobroModeloFacturacion getModeloFacturacion() {
		return modeloFacturacion;
	}

	public void setModeloFacturacion(RecobroModeloFacturacion modeloFacturacion) {
		this.modeloFacturacion = modeloFacturacion;
	}

	public List<RecobroSubcarteraAgencia> getAgencias() {
		return agencias;
	}

	public void setAgencias(List<RecobroSubcarteraAgencia> agencias) {
		this.agencias = agencias;
	}

	public List<RecobroSubcarteraRanking> getRanking() {
		return ranking;
	}

	public void setRanking(List<RecobroSubcarteraRanking> ranking) {
		this.ranking = ranking;
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

	public RecobroDDTipoRepartoSubcartera getTipoRepartoSubcartera() {
		return tipoRepartoSubcartera;
	}

	public void setTipoRepartoSubcartera(RecobroDDTipoRepartoSubcartera tipoRepartoSubcartera) {
		this.tipoRepartoSubcartera = tipoRepartoSubcartera;
	}

	public RecobroPoliticaDeAcuerdos getPoliticaAcuerdos() {
		return politicaAcuerdos;
	}

	public void setPoliticaAcuerdos(RecobroPoliticaDeAcuerdos politicaAcuerdos) {
		this.politicaAcuerdos = politicaAcuerdos;
	}

	public RecobroModeloDeRanking getModeloDeRanking() {
		return modeloDeRanking;
	}

	public void setModeloDeRanking(RecobroModeloDeRanking modeloDeRanking) {
		this.modeloDeRanking = modeloDeRanking;
	}
	
	
}
