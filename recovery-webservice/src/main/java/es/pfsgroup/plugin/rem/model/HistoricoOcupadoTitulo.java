package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;

@Entity
@Table(name = "ACT_HOT_HIST_OCUPADO_TITULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoOcupadoTitulo implements Serializable,Auditable {
	
    
    public static String COD_ALTA_ACTIVO = "Alta de activos";
    public static String COD_SIT_POS = "Situación posesoria y llaves";
    public static String COD_PATRIMONIO = "Pestaña de patrimonio como ";
    public static String COD_OFERTA_ALQUILER = "Oferta de alquiler";
    public static String COD_CARGA_MASIVA = "Carga masiva ";
    public static String COD_OFERTA_VENTA = "Oferta de venta";
    public static final long serialVersionUID = 1L;
    
   

    @Id
    @Column(name = "HOT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoOcupadoTituloGenerator")
    @SequenceGenerator(name = "HistoricoOcupadoTituloGenerator", sequenceName = "S_ACT_HOT_HIST_OCUPADO_TITULO")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;

    @Column(name = "HOT_OCUPADO")
    private Integer ocupado;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "HOT_DD_TPA_ID")
    private DDTipoTituloActivoTPA conTitulo;
    
    @Column(name = "HOT_FECHA_HORA_ALTA")
    private Date fechaHoraAlta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "HOT_USUARIO_ALTA")
    private Usuario usuario;
    
    @Column(name = "HOT_LUGAR_MODIFICACION")
    private String lugarModificacion;
    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	private HistoricoOcupadoTitulo() {}
	public HistoricoOcupadoTitulo(Activo activo, ActivoSituacionPosesoria posesoria, Usuario usuario, 
			String lugarModificacion, String valorConcreto) {
		
		this.activo = activo;
		this.conTitulo = posesoria.getConTitulo();
		this.ocupado = posesoria.getOcupado();
		this.usuario = usuario;
		this.fechaHoraAlta = new Date();
		if((HistoricoOcupadoTitulo.COD_PATRIMONIO.equalsIgnoreCase(lugarModificacion) || HistoricoOcupadoTitulo.COD_CARGA_MASIVA.equalsIgnoreCase(lugarModificacion)) && valorConcreto!=null) {
			this.lugarModificacion = lugarModificacion.concat(valorConcreto);
		}else {
			this.lugarModificacion = lugarModificacion;
		}
				
	}
	

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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getOcupado() {
		return ocupado;
	}

	public void setOcupado(Integer ocupado) {
		this.ocupado = ocupado;
	}

	public DDTipoTituloActivoTPA getConTitulo() {
		return conTitulo;
	}

	public void setConTitulo(DDTipoTituloActivoTPA conTitulo) {
		this.conTitulo = conTitulo;
	}

	public Date getFechaHoraAlta() {
		return fechaHoraAlta;
	}

	public void setFechaHoraAlta(Date fechaHoraAlta) {
		this.fechaHoraAlta = fechaHoraAlta;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public String getLugarModificacion() {
		return lugarModificacion;
	}

	public void setLugarModificacion(String lugarModificacion) {
		this.lugarModificacion = lugarModificacion;
	}
	
    
    }
