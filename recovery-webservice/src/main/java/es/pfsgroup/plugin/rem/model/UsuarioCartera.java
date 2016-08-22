package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;


/**
 * Modelo que gestiona la relación de usuarios con las carteras propietarias de los activos.
 *  
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "UCA_USUARIO_CARTERA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class UsuarioCartera implements Serializable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "UCA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "UsuarioCarteraGenerator")
    @SequenceGenerator(name = "UsuarioCarteraGenerator", sequenceName = "S_UCA_USUARIO_CARTERA")
    private Long id;

	@OneToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;
	
    @ManyToOne
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}
	

}
