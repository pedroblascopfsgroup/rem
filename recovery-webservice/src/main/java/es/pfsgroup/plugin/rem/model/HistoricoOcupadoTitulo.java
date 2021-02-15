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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;

@Entity
@Table(name = "ACT_HOT_HIST_OCUPADO_TITULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoOcupadoTitulo implements Serializable,Auditable {
	
    private static final long serialVersionUID = 1L;
    private static String COD_ALTA_ACTIVO = "Alta de activos";
    private static String COD_SIT_POS = "Situación posesoria y llaves";
    private static String COD_PATRIMONIO = "Pestaña de patrimonio como";
    private static String COD_OFERTA_ALQUILER = "Oferta de alquiler";
    private static String COD_CARGA_MASIVA = "Carga masiva";

    @Id
    @Column(name = "HOT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoGenerator")
    @SequenceGenerator(name = "ActivoGenerator", sequenceName = "S_ACT_HOT_HIST_OCUPADO_TITULO")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
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
	
	public static HistoricoOcupadoTitulo getHistoricoOcupadoTitulo(Activo activo, ActivoSituacionPosesoria posesoria, Usuario usuario, 
			String lugarModificacion, String valorConcreto) {
		HistoricoOcupadoTitulo obj = new HistoricoOcupadoTitulo();
		obj.setActivo(activo);
		obj.setConTitulo(posesoria.getConTitulo());
		obj.setOcupado(posesoria.getOcupado());
		obj.setUsuario(usuario);
		obj.setFechaHoraAlta(new Date());
		if(valorConcreto.equalsIgnoreCase(COD_SIT_POS) || valorConcreto.equalsIgnoreCase(COD_CARGA_MASIVA)) {
			obj.setLugarModificacion(lugarModificacion.concat(valorConcreto));
		}else {
			obj.setLugarModificacion(lugarModificacion);
		}
				return obj;
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
