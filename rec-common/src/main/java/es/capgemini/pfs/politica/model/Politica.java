package es.capgemini.pfs.politica.model;

import java.io.Serializable;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Clase que representa una política.
 * @author Andrés Esteban
*/
@Entity
@Table(name = "POL_POLITICA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Politica implements Auditable, Serializable {

    private static final long serialVersionUID = -8396258940802574504L;

    @Id
    @Column(name = "POL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PoliticaGenerator")
    @SequenceGenerator(name = "PoliticaGenerator", sequenceName = "S_POL_POLITICA")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "CMP_ID")
    private CicloMarcadoPolitica cicloMarcadoPolitica;

    @ManyToOne
    @JoinColumn(name = "TPL_ID")
    private DDTipoPolitica tipoPolitica;

    @ManyToOne
    @JoinColumn(name = "MOT_ID")
    private DDMotivo motivo;

    @ManyToOne
    @JoinColumn(name = "DD_ESP_ID")
    private DDEstadoPolitica estadoPolitica;

    @ManyToOne
    @JoinColumn(name = "DD_EPI_ID")
    private DDEstadoItinerarioPolitica estadoItinerarioPolitica;

    @Column(name = "POL_FECHA_VIGENCIA")
    private Date fechaVigencia;

    @Column(name = "POL_PROCESS_BPM")
    private Long processBpm;

    @ManyToOne
    @JoinColumn(name = "USU_ID")
    private Usuario usuarioCreacion;

    @ManyToOne
    @JoinColumn(name = "PEF_ID_GESTOR")
    private Perfil perfilGestor;

    @ManyToOne
    @JoinColumn(name = "PEF_ID_SUPER")
    private Perfil perfilSupervisor;

    @ManyToOne
    @JoinColumn(name = "ZON_ID_GESTOR")
    private DDZona zonaGestor;

    @ManyToOne
    @JoinColumn(name = "ZON_ID_SUPER")
    private DDZona zonaSupervisor;

    @Formula(value = "(select count(*) from OBJ_OBJETIVO o , ${master.schema}.DD_ESO_ESTADO_OBJETIVO eso "
            + " where o.pol_id = POL_ID and o.borrado = 0 and o.DD_ESO_ID = ESO.DD_ESO_ID and ESO.DD_ESO_CODIGO NOT IN ('"
            + DDEstadoObjetivo.ESTADO_BORRADO + "', '" + DDEstadoObjetivo.ESTADO_CANCELADO + "', '" + DDEstadoObjetivo.ESTADO_RECHAZADO + "'))")
    private Long cantidadObjetivos;

    @Formula(value = "(select count(*) from OBJ_OBJETIVO o, ${master.schema}.DD_ESC_ESTADO_CUMPLIMIENTO esc, ${master.schema}.DD_ESO_ESTADO_OBJETIVO eso "
            + " where o.pol_id = POL_ID and o.DD_ESC_ID = ESC.DD_ESC_ID "
            + " and ESC.DD_ESC_CODIGO = '"
            + DDEstadoCumplimiento.ESTADO_CUMPLIDO
            + "' and borrado = 0 and o.DD_ESO_ID = ESO.DD_ESO_ID and ESO.DD_ESO_CODIGO NOT IN ('"
            + DDEstadoObjetivo.ESTADO_BORRADO
            + "', '"
            + DDEstadoObjetivo.ESTADO_CANCELADO + "', '" + DDEstadoObjetivo.ESTADO_RECHAZADO + "'))")
    private Long cantidadObjetivosCumplidos;

    @Formula(value = "(select count(*) from OBJ_OBJETIVO o, ${master.schema}.DD_ESC_ESTADO_CUMPLIMIENTO esc, ${master.schema}.DD_ESO_ESTADO_OBJETIVO eso "
            + " where o.pol_id = POL_ID and o.DD_ESC_ID = ESC.DD_ESC_ID "
            + " and ESC.DD_ESC_CODIGO = '"
            + DDEstadoCumplimiento.ESTADO_INCUMPLIDO
            + "' and borrado = 0 and o.DD_ESO_ID = ESO.DD_ESO_ID and ESO.DD_ESO_CODIGO NOT IN ('"
            + DDEstadoObjetivo.ESTADO_BORRADO
            + "', '"
            + DDEstadoObjetivo.ESTADO_CANCELADO + "', '" + DDEstadoObjetivo.ESTADO_RECHAZADO + "'))")
    private Long cantidadObjetivosIncumplidos;

    @OneToMany(mappedBy = "politica")
    @JoinColumn(name = "POL_ID")
    @OrderBy("id ASC")
    private List<Objetivo> objetivos;
    
    @Transient
    private Comparator<Politica> estadoItinerarioComparator;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the tipoPolitica
     */
    public DDTipoPolitica getTipoPolitica() {
        return tipoPolitica;
    }

    /**
     * @param tipoPolitica the tipoPolitica to set
     */
    public void setTipoPolitica(DDTipoPolitica tipoPolitica) {
        this.tipoPolitica = tipoPolitica;
    }

    /**
     * @return the motivo
     */
    public DDMotivo getMotivo() {
        return motivo;
    }

    /**
     * @param motivo the motivo to set
     */
    public void setMotivo(DDMotivo motivo) {
        this.motivo = motivo;
    }

    /**
     * @return the estadoPolitica
     */
    public DDEstadoPolitica getEstadoPolitica() {
        return estadoPolitica;
    }

    /**
     * @param estadoPolitica the estadoPolitica to set
     */
    public void setEstadoPolitica(DDEstadoPolitica estadoPolitica) {
        this.estadoPolitica = estadoPolitica;
    }

    /**
     * @return the estadoItinerarioPolitica
     */
    public DDEstadoItinerarioPolitica getEstadoItinerarioPolitica() {
        return estadoItinerarioPolitica;
    }

    /**
     * @param estadoItinerarioPolitica the estadoItinerarioPolitica to set
     */
    public void setEstadoItinerarioPolitica(DDEstadoItinerarioPolitica estadoItinerarioPolitica) {
        this.estadoItinerarioPolitica = estadoItinerarioPolitica;
    }

    /**
     * @return the fechaVigencia
     */
    public Date getFechaVigencia() {
        return fechaVigencia;
    }

    /**
     * @param fechaVigencia the fechaVigencia to set
     */
    public void setFechaVigencia(Date fechaVigencia) {
        this.fechaVigencia = fechaVigencia;
    }

    /**
     * @return the processBpm
     */
    public Long getProcessBpm() {
        return processBpm;
    }

    /**
     * @param processBpm the processBpm to set
     */
    public void setProcessBpm(Long processBpm) {
        this.processBpm = processBpm;
    }

    /**
     * @return the usuario
     */
    public Usuario getUsuarioCreacion() {
        return usuarioCreacion;
    }

    /**
     * @param usuario the usuario to set
     */
    public void setUsuarioCreacion(Usuario usuario) {
        this.usuarioCreacion = usuario;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the cantidadObjetivos
     */
    public Long getCantidadObjetivos() {
        return cantidadObjetivos;
    }

    /**
     * @return the cantidadObjetivosCumplidos
     */
    public Long getCantidadObjetivosCumplidos() {
        return cantidadObjetivosCumplidos;
    }

    /**
     * @return the cantidadObjetivosIncumplidos
     */
    public Long getCantidadObjetivosIncumplidos() {
        return cantidadObjetivosIncumplidos;
    }

    /**
     * @return boolean
     */
    public Boolean getEsPropuesta() {
        return estadoPolitica.getCodigo().equals(DDEstadoPolitica.ESTADO_PROPUESTA);
    }

    /**
     * @return boolean
     */
    public Boolean getEsPropuestaSuperusuario() {
        return estadoPolitica.getCodigo().equals(DDEstadoPolitica.ESTADO_PROPUESTA)
                && estadoItinerarioPolitica.getCodigo().equals(DDEstadoItinerarioPolitica.ESTADO_VIGENTE);
    }

    /**
     * @return boolean
     */
    public Boolean getEsVigente() {
        return estadoPolitica.getCodigo().equals(DDEstadoPolitica.ESTADO_VIGENTE);
    }

    /**
     * @return the perfilGestor
     */
    public Perfil getPerfilGestor() {
        return perfilGestor;
    }

    /**
     * @param perfilGestor the perfilGestor to set
     */
    public void setPerfilGestor(Perfil perfilGestor) {
        this.perfilGestor = perfilGestor;
    }

    /**
     * @return the perfilSupervisor
     */
    public Perfil getPerfilSupervisor() {
        return perfilSupervisor;
    }

    /**
     * @param perfilSupervisor the perfilSupervisor to set
     */
    public void setPerfilSupervisor(Perfil perfilSupervisor) {
        this.perfilSupervisor = perfilSupervisor;
    }

    /**
     * @return the zonaGestor
     */
    public DDZona getZonaGestor() {
        return zonaGestor;
    }

    /**
     * @param zonaGestor the zonaGestor to set
     */
    public void setZonaGestor(DDZona zonaGestor) {
        this.zonaGestor = zonaGestor;
    }

    /**
     * @return the zonaSupervisor
     */
    public DDZona getZonaSupervisor() {
        return zonaSupervisor;
    }

    /**
     * @param zonaSupervisor the zonaSupervisor to set
     */
    public void setZonaSupervisor(DDZona zonaSupervisor) {
        this.zonaSupervisor = zonaSupervisor;
    }

    /**
     * @param cicloMarcadoPolitica the cicloMarcadoPolitica to set
     */
    public void setCicloMarcadoPolitica(CicloMarcadoPolitica cicloMarcadoPolitica) {
        this.cicloMarcadoPolitica = cicloMarcadoPolitica;
    }

    /**
     * @return the cicloMarcadoPolitica
     */
    public CicloMarcadoPolitica getCicloMarcadoPolitica() {
        return cicloMarcadoPolitica;
    }

    /**
     * @param objetivos the objetivos to set
     */
    public void setObjetivos(List<Objetivo> objetivos) {
        this.objetivos = objetivos;
    }

    /**
     * @return the objetivos
     */
    public List<Objetivo> getObjetivos() {
        return objetivos;
    }
    
    public Comparator<Politica> getEstadoItinerarioComparator() {
    	
    	if(estadoItinerarioComparator == null) {
    		estadoItinerarioComparator = new EstadoItinerarioComparator();
    	}

    	return estadoItinerarioComparator;
    }
    
    /**
     * Crea una copia de la política sin objetivos.
     * @return Politica
     */
    @Override
    public Politica clone() {
        Politica nuevaPolitica = new Politica();
        nuevaPolitica.setCicloMarcadoPolitica(this.getCicloMarcadoPolitica());
        nuevaPolitica.setEstadoItinerarioPolitica(this.getEstadoItinerarioPolitica());
        nuevaPolitica.setEstadoPolitica(this.getEstadoPolitica());
        nuevaPolitica.setFechaVigencia(this.getFechaVigencia());
        nuevaPolitica.setMotivo(this.getMotivo());
        nuevaPolitica.setPerfilGestor(this.getPerfilGestor());
        nuevaPolitica.setPerfilSupervisor(this.getPerfilSupervisor());
        nuevaPolitica.setTipoPolitica(this.getTipoPolitica());
        nuevaPolitica.setZonaGestor(this.getZonaGestor());
        nuevaPolitica.setZonaSupervisor(this.getZonaSupervisor());
        return nuevaPolitica;
    }
    
    private class EstadoItinerarioComparator implements Comparator<Politica> {

		@Override
		public int compare(Politica o1, Politica o2) {
			return o1.getEstadoItinerarioPolitica().getId().compareTo(o2.getEstadoItinerarioPolitica().getId());
		}    	
    }
}
