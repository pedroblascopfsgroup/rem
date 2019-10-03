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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDJuntaComunidades;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Entity
@Table(name = "ACT_JCM_JUNTA_COM_PROPIETARIOS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoJuntaPropietarios implements Serializable, Auditable {

	private static final long serialVersionUID = 750359188915093506L;

	@Id
	@Column(name = "JCM_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoJuntaPropietariosGenerator")
	@SequenceGenerator(name = "ActivoJuntaPropietariosGenerator", sequenceName = "S_ACT_JCM_JUNTA_COM_PROPIETARIOS")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_JCP_ID")
	private DDJuntaComunidades junta;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_ACT_JUDIC_CON_PROMOCION")	
	private DDSinSiNo judicial;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_ACTUACIONES_CONTRA_MOROSOS")
	private DDSinSiNo morosos;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_COMUNIDAD")
	private ActivoProveedor comunidad;

	@Column(name = "JCM_CUOTA_EXTRA")
	private Double extra;

	@Column(name = "JCM_CUOTA_ORDINARIA")
	private Double ordinaria;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_DERRAMA_MAYOR_5000")
	private DDSinSiNo derrama;

	@Column(name = "JCM_FECHA_JUNTA")
	private Date fechaAltaJunta;

	@Column(name = "JCM_GUION_DE_VOTO")
	private String voto;

	@Column(name = "JCM_IMPORTE")
	private Double importe;

	@Column(name = "JCM_INDICACIONES")
	private String indicaciones;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_ITE")
	private DDSinSiNo ite;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_MODIFICACIONES_ESTATUTOS")
	private DDSinSiNo estatutos;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_MODIFICA_CUOTA")
	private DDSinSiNo cuota;

	@Column(name = "JCM_OTROS")
	private String otros;

	@Column(name = "JCM_PORCENTAJE_PARTICIPACION")
	private Double porcentaje;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_PROMOCION_ENTRE_20_50")
	private DDSinSiNo promo20a50;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_PROMOCION_MAYOR_50")
	private DDSinSiNo promoMayor50;

	@Column(name = "JCM_PROPUESTA")
	private String propuesta;

	@Column(name = "JCM_SUMINISTROS")
	private Double suministros;
	
    @OneToMany(mappedBy = "activoJuntaPropietario", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "JCM_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<ActivoAdjuntoJuntas> adjuntos;

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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDJuntaComunidades getJunta() {
		return junta;
	}

	public void setJunta(DDJuntaComunidades junta) {
		this.junta = junta;
	}

	public DDSinSiNo getJudicial() {
		return judicial;
	}

	public void setJudicial(DDSinSiNo judicial) {
		this.judicial = judicial;
	}

	public DDSinSiNo getMorosos() {
		return morosos;
	}

	public void setMorosos(DDSinSiNo morosos) {
		this.morosos = morosos;
	}

	public ActivoProveedor getComunidad() {
		return comunidad;
	}

	public void setComunidad(ActivoProveedor comunidad) {
		this.comunidad = comunidad;
	}

	public Double getExtra() {
		return extra;
	}

	public void setExtra(Double extra) {
		this.extra = extra;
	}

	public Double getOrdinaria() {
		return ordinaria;
	}

	public void setOrdinaria(Double ordinaria) {
		this.ordinaria = ordinaria;
	}

	public DDSinSiNo getDerrama() {
		return derrama;
	}

	public void setDerrama(DDSinSiNo derrama) {
		this.derrama = derrama;
	}

	public Date getFechaAltaJunta() {
		return fechaAltaJunta;
	}

	public void setFechaAltaJunta(Date fechaAltaJunta) {
		this.fechaAltaJunta = fechaAltaJunta;
	}

	public String getVoto() {
		return voto;
	}

	public void setVoto(String voto) {
		this.voto = voto;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public String getIndicaciones() {
		return indicaciones;
	}

	public void setIndicaciones(String indicaciones) {
		this.indicaciones = indicaciones;
	}

	public DDSinSiNo getIte() {
		return ite;
	}

	public void setIte(DDSinSiNo ite) {
		this.ite = ite;
	}

	public DDSinSiNo getEstatutos() {
		return estatutos;
	}

	public void setEstatutos(DDSinSiNo estatutos) {
		this.estatutos = estatutos;
	}

	public DDSinSiNo getCuota() {
		return cuota;
	}

	public void setCuota(DDSinSiNo cuota) {
		this.cuota = cuota;
	}

	public String getOtros() {
		return otros;
	}

	public void setOtros(String otros) {
		this.otros = otros;
	}

	public Double getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Double porcentaje) {
		this.porcentaje = porcentaje;
	}

	public DDSinSiNo getPromo20a50() {
		return promo20a50;
	}

	public void setPromo20a50(DDSinSiNo promo20a50) {
		this.promo20a50 = promo20a50;
	}

	public DDSinSiNo getPromoMayor50() {
		return promoMayor50;
	}

	public void setPromoMayor50(DDSinSiNo promoMayor50) {
		this.promoMayor50 = promoMayor50;
	}

	public String getPropuesta() {
		return propuesta;
	}

	public void setPropuesta(String propuesta) {
		this.propuesta = propuesta;
	}

	public Double getSuministros() {
		return suministros;
	}

	public void setSuministros(Double suministros) {
		this.suministros = suministros;
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
	
	public List<ActivoAdjuntoJuntas> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<ActivoAdjuntoJuntas> adjuntos) {
		this.adjuntos = adjuntos;
	}
    
	/**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public ActivoAdjuntoJuntas getAdjunto(Long id) {
        for (ActivoAdjuntoJuntas adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }
    
    /**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public ActivoAdjuntoJuntas getAdjuntoGD(Long idDocRestClient) {
    	for (ActivoAdjuntoJuntas adj : getAdjuntos()) {
    		if(!Checks.esNulo(adj.getDocumento_Rest()) && adj.getDocumento_Rest().equals(idDocRestClient)) { return adj; }
        }
        return null;
    }

}
