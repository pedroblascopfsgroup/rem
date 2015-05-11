package es.capgemini.pfs.zona.model;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.oficina.model.Oficina;

/**
 * Clase que representa a una zona.
 * @author aesteban
 *
 */
@Entity
@Table(name = "ZON_ZONIFICACION", schema = "${entity.schema}")
public class DDZona implements Dictionary, Auditable {

    private static final long serialVersionUID = 1687925201006608232L;

    @Id
    @Column(name = "ZON_ID")
    private Long id;

    @Column(name = "ZON_COD")
    private String codigo;

    @Column(name = "ZON_NUM_CENTRO")
    private String centro;

    @Column(name = "ZON_DESCRIPCION")
    private String descripcion;

    @Column(name = "ZON_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @ManyToOne
    @JoinColumn(name = "ZON_PID")
    private DDZona zonaPadre;

    @ManyToOne
    @JoinColumn(name = "NIV_ID")
    private Nivel nivel;

    @OneToOne
    @JoinColumn(name = "OFI_ID")
    private Oficina oficina;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ZON_PID", referencedColumnName = "ZON_ID")
    private Set<DDZona> zonasHijas;

    @OneToMany(mappedBy = "zona")
    private Set<Comite> comites;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

    /**
     * devuelve las oficinas asociadas a esta zona.
     * @return oficinas.
     */
    public List<Oficina> getOficinas() {
        List<Oficina> oficinas = new ArrayList<Oficina>();
        if (this.getOficina() != null) {
            oficinas.add(this.getOficina());
        }
        if (zonasHijas != null) {
            for (DDZona z : zonasHijas) {
                oficinas.addAll(z.getOficinas());
            }
        }
        return oficinas;
    }

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
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
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
     * @return the serialVersionUID
     */
    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    /**
     * @return the zonaPadre
     */
    public DDZona getZonaPadre() {
        return zonaPadre;
    }

    /**
     * @param zonaPadre the zonaPadre to set
     */
    public void setZonaPadre(DDZona zonaPadre) {
        this.zonaPadre = zonaPadre;
    }

    /**
     * @return the nivel
     */
    public Nivel getNivel() {
        return nivel;
    }

    /**
     * @param nivel the nivel to set
     */
    public void setNivel(Nivel nivel) {
        this.nivel = nivel;
    }

    /**
     * @return the oficina
     */
    public Oficina getOficina() {
        return oficina;
    }

    /**
     * @param oficina the oficina to set
     */
    public void setOficina(Oficina oficina) {
        this.oficina = oficina;
    }

    /**
     * @return the zonasHijas
     */
    public Set<DDZona> getZonasHijas() {
        return zonasHijas;
    }

    /**
     * @param zonasHijas the zonasHijas to set
     */
    public void setZonasHijas(Set<DDZona> zonasHijas) {
        this.zonasHijas = zonasHijas;
    }

    /**
     * @return the comites
     */
    public Set<Comite> getComites() {
        return comites;
    }

    /**
     * devuelve los comites ordenados por prioridad.
     * @return comites ordenados por prioridad
     */
    public TreeSet<Comite> getComitesPriorizados() {
        TreeSet<Comite> tComite = new TreeSet<Comite>(new Comparator<Comite>() {
            public int compare(Comite c1, Comite c2) {
                if (c1.getPrioridad() == null) { return 1; }
                if (c2.getPrioridad() == null) { return -1; }
                return c1.getPrioridad().compareTo(c2.getPrioridad());
            }
        });
        tComite.addAll(getComites());
        return tComite;
    }

    /**
     * @param comites the comites to set
     */
    public void setComites(Set<Comite> comites) {
        this.comites = comites;
    }

    /**
     * @return the centro
     */
    public String getCentro() {
        return centro;
    }

    /**
     * @param centro the centro to set
     */
    public void setCentro(String centro) {
        this.centro = centro;
    }

    /* (non-Javadoc)
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof DDZona)) return false;
        return getId().equals(((DDZona) obj).getId()) ? true : false;
    }

}
