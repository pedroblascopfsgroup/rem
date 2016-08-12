package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;


/**
 * Modelo que gestiona la informacion de una oferta
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "OFR_OFERTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Oferta implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "OFR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "OfertaGenerator")
    @SequenceGenerator(name = "OfertaGenerator", sequenceName = "S_OFR_OFERTA")
    private Long id;
	
    @Column(name = "OFR_WEBCOM_ID")
    private Long idWebCom;
	
    @Column(name = "OFR_NUM_OFERTA")
    private Long numOferta;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    private ActivoAgrupacion agrupacion;
	
	@Column(name="OFR_IMPORTE")
	private Double importeOferta;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EOF_ID")
	private DDEstadoOferta estadoOferta;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TOF_ID")
	private DDTipoOferta tipoOferta;      
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CLC_ID")
    private ClienteComercial cliente;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VIS_ID")
    private Visita visita;
    
    @Column(name = "VIS_FECHA_ACCION")
    private Date fechaAccion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario usuarioAccion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_PRESCRIPTOR")
	private ActivoProveedor prescriptor;
    
    @OneToMany(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TitularesAdicionalesOferta> titularesAdicionales;
    
    @OneToMany(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TextosOferta> textos;  

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
	
	public Long getIdWebCom() {
		return idWebCom;
	}

	public void setIdWebCom(Long idWebCom) {
		this.idWebCom = idWebCom;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public Double getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}

	public DDEstadoOferta getEstadoOferta() {
		return estadoOferta;
	}

	public void setEstadoOferta(DDEstadoOferta estadoOferta) {
		this.estadoOferta = estadoOferta;
	}

	public DDTipoOferta getTipoOferta() {
		return tipoOferta;
	}

	public void setTipoOferta(DDTipoOferta tipoOferta) {
		this.tipoOferta = tipoOferta;
	}

	public ClienteComercial getCliente() {
		return cliente;
	}

	public void setCliente(ClienteComercial cliente) {
		this.cliente = cliente;
	}

	public Visita getVisita() {
		return visita;
	}

	public void setVisita(Visita visita) {
		this.visita = visita;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Usuario getUsuarioAccion() {
		return usuarioAccion;
	}

	public void setUsuarioAccion(Usuario usuarioAccion) {
		this.usuarioAccion = usuarioAccion;
	}

	public ActivoProveedor getPrescriptor() {
		return prescriptor;
	}

	public void setPrescriptor(ActivoProveedor prescriptor) {
		this.prescriptor = prescriptor;
	}

	public List<TitularesAdicionalesOferta> getTitularesAdicionales() {
		return titularesAdicionales;
	}

	public void setTitularesAdicionales(
			List<TitularesAdicionalesOferta> titularesAdicionales) {
		this.titularesAdicionales = titularesAdicionales;
	}

	public List<TextosOferta> getTextos() {
		return textos;
	}

	public void setTextos(List<TextosOferta> textos) {
		this.textos = textos;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
    
    
    
    
   
}
