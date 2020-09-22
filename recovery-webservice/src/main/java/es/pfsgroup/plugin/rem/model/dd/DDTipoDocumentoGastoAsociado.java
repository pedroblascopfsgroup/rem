package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;


@Entity
@Table(name = "DD_TPG_TPO_DOC_GASTO_ASOC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocumentoGastoAsociado implements Auditable, Dictionary{

	
	@Id
	@Column(name = "DD_TPG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoGastoAsociado")
	@SequenceGenerator(name = "DDTipoDocumentoGastoAsociado", sequenceName = "S_DD_TPG_TPO_DOC_GASTO_ASOC")
	private Long id;
    
    @Column(name = "DD_TPG_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPG_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPG_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	
	@Override
	public Long getId() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getCodigo() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getDescripcion() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getDescripcionLarga() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		// TODO Auto-generated method stub
		
	}

}
