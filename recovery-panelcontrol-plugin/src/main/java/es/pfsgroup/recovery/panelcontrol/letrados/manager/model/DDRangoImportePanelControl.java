package es.pfsgroup.recovery.panelcontrol.letrados.manager.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import es.pfsgroup.recovery.panelcontrol.letrados.api.model.DDRangoImportePanelControlInfo;

@Entity
@Table(name = "DD_RPC_RANGO_IMPORTE_PC", schema = "${entity.schema}")
public class DDRangoImportePanelControl implements DDRangoImportePanelControlInfo{


    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "RPC_ID")
    private Long id;

    @Column(name = "RPC_CODIGO")
    private String codigo;

    @Column(name = "RPC_DESCRPCCION")
    private String descripcion;

    @Column(name = "RPC_VALOR_INICIAL")
    private Long valorInicial;

    @Column(name = "RPC_VALOR_FINAL")
    private Long valorFinal;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Override
    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    @Override
    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    @Override
	public Long getValorInicial() {
		return valorInicial;
	}

	public void setValorInicial(Long valorInicial) {
		this.valorInicial = valorInicial;
	}

    @Override
	public Long getValorFinal() {
		return valorFinal;
	}

	public void setValorFinal(Long valorFinal) {
		this.valorFinal = valorFinal;
	}

 
}
