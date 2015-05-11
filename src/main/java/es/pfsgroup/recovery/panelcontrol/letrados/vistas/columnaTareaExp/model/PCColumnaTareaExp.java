package es.pfsgroup.recovery.panelcontrol.letrados.vistas.columnaTareaExp.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;


@Entity
@Table(name = "PC_COT_COLUMNS_EXP_TAR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class PCColumnaTareaExp implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3730871494367533328L;
	
	@Id
	@Column(name="COL_ID")
	private Long id;
	
	@Column(name="HEADER")
	private String header;
	
	@Column(name="COL_INDEX")
	private Integer colIndex;
	
	@Column(name="DATAINDEX")	
	private String dataindex;
	
	@Column(name="WIDTH")
	private String width;
	
	@Column(name="ALIGN")
	private String align;
	
	@Column(name="SORTABLE")
	private Integer sortable;

	@Column(name="ORDEN")
	private String orden;
	
	@Column(name="FORMULARIO")
	private String formulario;
	
	@Column(name="HIDDEN")
	private Integer hidden;
	
	
	@Column(name="TYPE")
	private String type;
	
	@Column(name="FLOW_CLICK")
	private String flowClick ;
	
	@Column(name="TAR_PANEL")
	private String panelTareas;
	
	@Column(name="ETIQUETA")
	private String etiqueta;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getHeader() {
		return header;
	}

	public void setHeader(String header) {
		this.header = header;
	}

	public String getDataindex() {
		return dataindex;
	}

	public void setDataindex(String dataindex) {
		this.dataindex = dataindex;
	}

	public String getWidth() {
		return width;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public String getAlign() {
		return align;
	}

	public void setAlign(String align) {
		this.align = align;
	}

	public Integer getSortable() {
		return sortable;
	}

	public void setSortable(Integer sortable) {
		this.sortable = sortable;
	}

	public String getOrden() {
		return orden;
	}

	public void setOrden(String orden) {
		this.orden = orden;
	}

	public String getFormulario() {
		return formulario;
	}

	public void setFormulario(String formulario) {
		this.formulario = formulario;
	}

	public Integer getHidden() {
		return hidden;
	}

	public void setHidden(Integer hidden) {
		this.hidden = hidden;
	}

	public Integer getColIndex() {
		return colIndex;
	}

	public void setColIndex(Integer colIndex) {
		this.colIndex = colIndex;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setFlowClick(String flowClick) {
		this.flowClick = flowClick;
	}

	public String getFlowClick() {
		return flowClick;
	}

	public void setPanelTareas(String panelTareas) {
		this.panelTareas = panelTareas;
	}

	public String getPanelTareas() {
		return panelTareas;
	}
	
	public String getEtiqueta() {
		return etiqueta;
	}

	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}
	
}
