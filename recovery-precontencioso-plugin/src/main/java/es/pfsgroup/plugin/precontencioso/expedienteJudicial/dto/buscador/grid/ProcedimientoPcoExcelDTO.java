package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid;

import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;

/**
 * Clase para exportar los datos a excel. La visualización de campos tipo "Date"
 * ha sido sustituida por "String", ya que daba problemas al realizar la
 * conversión.
 * 
 * @author jlgauxachs
 *
 */
public class ProcedimientoPcoExcelDTO extends WebDto {

	private static final long serialVersionUID = 655397921693689581L;

	private String prcId;
	private String codigo;
	private String nombreProcedimiento;
	private String nombreExpediente;
	private String estadoExpediente;
	private Integer diasEnGestion;
	private String fechaEstado;
	private String tipoProcPropuesto;
	private String tipoPreparacion;
	private String fechaInicioPreparacion;
	private Integer diasEnPreparacion;
	private BigDecimal totalLiquidacion;
	private String fechaEnvioLetrado;
	private Boolean aceptadoLetrado;
	private Boolean todosDocumentos;
	private Boolean todasLiquidaciones;
	private Boolean todosBurofaxes;
	private Float importe;
	private DocumentoGridDTO documento;
	private LiquidacionGridDTO liquidacion;
	private BurofaxGridDTO burofax;
	
	public ProcedimientoPcoExcelDTO() {
		documento = new DocumentoGridDTO();
		liquidacion = new LiquidacionGridDTO();
		burofax = new BurofaxGridDTO();
	}

	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombreExpediente() {
		return nombreExpediente;
	}
	public void setNombreExpediente(String nombreExpediente) {
		this.nombreExpediente = nombreExpediente;
	}
	public String getEstadoExpediente() {
		return estadoExpediente;
	}
	public void setEstadoExpediente(String estadoExpediente) {
		this.estadoExpediente = estadoExpediente;
	}
	public Integer getDiasEnGestion() {
		return diasEnGestion;
	}
	public void setDiasEnGestion(Integer diasEnGestion) {
		this.diasEnGestion = diasEnGestion;
	}
	public String getFechaEstado() {
		return fechaEstado;
	}
	public void setFechaEstado(String fechaEstado) {
		this.fechaEstado = fechaEstado;
	}
	public String getTipoProcPropuesto() {
		return tipoProcPropuesto;
	}
	public void setTipoProcPropuesto(String tipoProcPropuesto) {
		this.tipoProcPropuesto = tipoProcPropuesto;
	}
	public String getTipoPreparacion() {
		return tipoPreparacion;
	}
	public void setTipoPreparacion(String tipoPreparacion) {
		this.tipoPreparacion = tipoPreparacion;
	}
	public String getFechaInicioPreparacion() {
		return fechaInicioPreparacion;
	}
	public void setFechaInicioPreparacion(String fechaInicioPreparacion) {
		this.fechaInicioPreparacion = fechaInicioPreparacion;
	}
	public Integer getDiasEnPreparacion() {
		return diasEnPreparacion;
	}
	public void setDiasEnPreparacion(Integer diasEnPreparacion) {
		this.diasEnPreparacion = diasEnPreparacion;
	}
	public BigDecimal getTotalLiquidacion() {
		return totalLiquidacion;
	}
	public void setTotalLiquidacion(BigDecimal totalLiquidacion) {
		this.totalLiquidacion = totalLiquidacion;
	}
	public String getFechaEnvioLetrado() {
		return fechaEnvioLetrado;
	}
	public void setFechaEnvioLetrado(String fechaEnvioLetrado) {
		this.fechaEnvioLetrado = fechaEnvioLetrado;
	}
	public Boolean getAceptadoLetrado() {
		return aceptadoLetrado;
	}
	public void setAceptadoLetrado(Boolean aceptadoLetrado) {
		this.aceptadoLetrado = aceptadoLetrado;
	}
	public Boolean getTodosDocumentos() {
		return todosDocumentos;
	}
	public void setTodosDocumentos(Boolean todosDocumentos) {
		this.todosDocumentos = todosDocumentos;
	}
	public Boolean getTodasLiquidaciones() {
		return todasLiquidaciones;
	}
	public void setTodasLiquidaciones(Boolean todasLiquidaciones) {
		this.todasLiquidaciones = todasLiquidaciones;
	}
	public DocumentoGridDTO getDocumento() {
		return documento;
	}
	public void setDocumento(DocumentoGridDTO documento) {
		this.documento = documento;
	}
	public LiquidacionGridDTO getLiquidacion() {
		return liquidacion;
	}
	public void setLiquidacion(LiquidacionGridDTO liquidacion) {
		this.liquidacion = liquidacion;
	}
	public BurofaxGridDTO getBurofax() {
		return burofax;
	}
	public void setBurofax(BurofaxGridDTO burofax) {
		this.burofax = burofax;
	}
	public String getPrcId() {
		return prcId;
	}
	public void setPrcId(String prcId) {
		this.prcId = prcId;
	}
	public Boolean getTodosBurofaxes() {
		return todosBurofaxes;
	}
	public void setTodosBurofaxes(Boolean todosBurofaxes) {
		this.todosBurofaxes = todosBurofaxes;
	}
	public String getNombreProcedimiento() {
		return nombreProcedimiento;
	}
	public void setNombreProcedimiento(String nombreProcedimiento) {
		this.nombreProcedimiento = nombreProcedimiento;
	}

	/**
	 * @return the importe
	 */
	public Float getImporte() {
		return importe;
	}

	/**
	 * @param importe the importe to set
	 */
	public void setImporte(Float importe) {
		this.importe = importe;
	}
}
