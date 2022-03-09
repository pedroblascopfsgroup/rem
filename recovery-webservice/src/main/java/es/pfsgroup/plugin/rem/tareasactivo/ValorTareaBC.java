

package es.pfsgroup.plugin.rem.tareasactivo;


import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

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
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;


@Entity
@Table(name = "TEB_TAREA_BC_VALOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ValorTareaBC implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	/**
	 * 
	 */
	

	static class BloqueoScreening {
		private String motivoBloqueado;
		private String motivoDesbloqueado;
		private String observacionesBloqueado;
		private String observacionesDesbloqueado;
		private String comboResultado;
	}

	static class BloqueoScoring {
		private String motivoBloqueado;
		private String motivoDesbloqueado;
		private String observacionesBloqueado;
		private String observacionesDesbloqueado;
		private String comboResultado;
	}
	
	static class ElevarSancion {
		private String observacionesBC;
		private String comboResolucion;
	}
	
	
	@Id
	@Column(name = "TEB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ValorTareaBCGenerator")
	@SequenceGenerator(name = "ValorTareaBCGenerator", sequenceName = "S_TEB_TAREA_BC_VALOR")
	private Long id;
	      
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TEX_ID")
	private TareaExterna tareaExterna;
	 
	@Column(name = "TEB_NOMBRE")   
	private String campo;
	    
	@Column(name = "TEB_VALOR")   
	private String valor;
	      
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

	public TareaExterna getTareaExterna() {
		return tareaExterna;
	}

	public void setTareaExterna(TareaExterna tareaExterna) {
		this.tareaExterna = tareaExterna;
	}

	public String getCampo() {
		return campo;
	}

	public void setCampo(String campo) {
		this.campo = campo;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
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


	public static final List<String> getCampoByTarea(String codTarea){
		List<String> listaCampos = new ArrayList<String>();
		Field[] campos = null;
		if(ComercialUserAssigantionService.CODIGO_T017_BLOQUEOSCREENING.equals(codTarea)
			|| ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCREENING.equals(codTarea)
			|| ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCREENING.equals(codTarea)) {
			campos =  BloqueoScreening.class.getDeclaredFields();
		} else if(ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_ELEVAR_SANCION.equals(codTarea)) {
			campos =  ElevarSancion.class.getDeclaredFields();
		} else if (ComercialUserAssigantionService.CODIGO_T017_BLOQUEOSCORING.equals(codTarea)
				|| ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_BLOQUEOSCORING.equals(codTarea)
				|| ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_BLOQUEOSCORING.equals(codTarea)) {
			campos =  BloqueoScoring.class.getDeclaredFields();
		}
		
		if(campos !=null) {
			for (Field field : campos) {
				field.setAccessible(true);
				String nombre = field.getName();
				listaCampos.add(nombre);
			}
		}
		return listaCampos;
	}
}



