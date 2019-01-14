package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GenerarFacturaVentaActivosApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoDataSource;
import es.pfsgroup.plugin.rem.model.DtoInfoActivoFacturaVenta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.service.GenerateJasperPdfServiceManager;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;

@Component
public class GenerarFacturaVentaActivosManager extends GenerateJasperPdfServiceManager implements GenerarFacturaVentaActivosApi {
	
	private static final String FACTURA_DIRECCION_CARTERA = "msg.factura.venta.dirrecion.cartera";
	private static final String FACTURA_LEY_IVA = "msg.factura.venta.articulo.ley.iva";
	private static final String FACTURA_REGISTRO_MERCANTIL = "msg.factura.venta.registro.mercantil";
	private static final String FACTURA_PORCENTAJE_PARTICIPACION = "msg.factura.venta.cien.porcentaje.finca";
	private static final String FACTURA_PORCENTAJE_PROPIETARIO_EN_ACTIVO= "msg.factura.venta.porcentaje.propietario.sobre.activo";
	private static final String FACTURA_MSG_DESGLOSE_ANEXOS = "msg.factura.venta.lote.desglose.anexos";
	private static final String FACTURA_VENTA_ACTIVO = "FacturaVentaActivo";
	private static final String FACTURA_VENTA_LOTE = "FacturaVentaLote";
	private static final String FACTURA_PROFORMA = "FACTURA PROFORMA";
	
	protected static final Log logger = LogFactory.getLog(GenerarFacturaVentaActivosManager.class);
	
	@Resource
    MessageService messageServices;
	
	@Override
	public File getFacturaVenta(ExpedienteComercial expediente) throws Exception {
		
		Boolean isFacturaActivo;
		
		if(!Checks.esNulo(expediente.getOferta().getAgrupacion()))
			isFacturaActivo = false;
		else
			isFacturaActivo = true;
		
		List<File> listaPdf = new ArrayList<File>(); 
		
		for(CompradorExpediente compradorExp : expediente.getCompradores()) {
			try {
				Map<String, Object> params = paramsHojaDatos(expediente, compradorExp, isFacturaActivo);
			
				File file = null;
				if(isFacturaActivo)
					file = this.getPDFFile(params, new ArrayList<Object>(), FACTURA_VENTA_ACTIVO);
				else 
					file = this.getPDFFile(params, this.dataSourceInfoRegistralPorActivo(expediente.getOferta().getActivosOferta()), FACTURA_VENTA_LOTE);
				
				listaPdf.add(file);
				
			} catch (Exception e) {
				logger.error(e.getMessage());
				throw new Exception(e);
			}
		}
		
		File salida = null;
		try {
			salida = File.createTempFile("facturaVenta", ".pdf");
			FileUtilsREM.concatenatePdfs(listaPdf, salida);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new Exception(e);
		}
		
		
		return salida;
	}

	@Override
	public Map<String, Object> paramsHojaDatos(ExpedienteComercial expediente, CompradorExpediente compradorExp, Boolean isFacturaActivo) throws Exception {
		
		Map<String, Object> mapaValores = new HashMap<String,Object>();
		Double porcentajeCompra = !Checks.esNulo(compradorExp.getPorcionCompra()) ? compradorExp.getPorcionCompra() : 0.0;
		try {
			mapaValores.put("numFactura", !Checks.esNulo(compradorExp.getNumFactura()) ? compradorExp.getNumFactura() : FACTURA_PROFORMA);
			mapaValores.put("fechaFactura", FileUtilsREM.stringify(compradorExp.getFechaFactura()));
			
			if(isFacturaActivo) {
				this.rellenarDatosGeneralesActivo(expediente, mapaValores);
				this.rellenarInfoRegistralActivo(expediente, mapaValores, porcentajeCompra);
			}
			else {
				this.rellenarDatosGeneralesLote(expediente, mapaValores);
				this.rellenarInfoRegistralLote(expediente, mapaValores);
			}
			
			this.rellenarDatosComprador(expediente, mapaValores,compradorExp.getPrimaryKey().getComprador());
			Double importeOferta = this.rellenarDatosFactura(expediente, mapaValores, porcentajeCompra);
			this.rellenarDatosFormaDePago(expediente,mapaValores, importeOferta, porcentajeCompra);
			this.rellenarMensajesConstantes(mapaValores,expediente.getCompradores().size()==1 && isFacturaActivo);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new Exception(e);
		}
		
		return mapaValores;
	}
	
	
	// ----------- Información para las facturas de Activos 
	
	private void rellenarDatosGeneralesActivo(ExpedienteComercial expediente, Map<String, Object> mapaValores) {
		
		Activo activo = expediente.getOferta().getActivoPrincipal();
		if(!Checks.esNulo(activo)) {
			mapaValores.put("numExpediente",!Checks.esNulo(activo.getNumInmovilizadoBnk()) ? String.valueOf(activo.getNumInmovilizadoBnk()) : "-");
			mapaValores.put("numActivo", !Checks.esNulo(activo.getNumActivoUvem()) ? String.valueOf(activo.getNumActivoUvem()) : "-");	
		}
	}
	
	private void rellenarInfoRegistralActivo(ExpedienteComercial expediente, Map<String, Object> mapaValores, Double porcentajeCompra) throws Exception {
		
		Activo activo = expediente.getOferta().getActivoPrincipal();
		String porcComprador = null;
		porcComprador = FileUtilsREM.stringify(porcentajeCompra);
		String[] datosParticipacionCompra = {porcComprador};
		
		mapaValores.put("participacionCompra",messageServices.getMessage(FACTURA_PORCENTAJE_PARTICIPACION,datosParticipacionCompra).concat(this.getInfoPropietarioSobreActivo(activo)).toUpperCase());
		mapaValores.put("fechaEscritura", !Checks.esNulo(expediente.getFechaVenta()) ? FileUtilsREM.stringify(expediente.getFechaVenta()) : "");
		mapaValores.put("direccionActivo", analyzeString(activo.getDireccion()).toUpperCase());
		
		mapaValores.put("infoRegistralActivo", this.getInfoRegistralActivo(activo));
	}
	
	
	// ----------- Información para las facturas de Lote
	
	private void rellenarDatosGeneralesLote(ExpedienteComercial expediente, Map<String, Object> mapaValores) {
		
		mapaValores.put("numLote", !Checks.esNulo(expediente.getOferta().getAgrupacion().getNumAgrupUvem()) ? expediente.getOferta().getAgrupacion().getNumAgrupUvem().toString() : "-");
	}
	
	private void rellenarInfoRegistralLote(ExpedienteComercial expediente, Map<String, Object> mapaValores) throws Exception {
		
		mapaValores.put("participacionCompra",messageServices.getMessage(FACTURA_MSG_DESGLOSE_ANEXOS).toUpperCase());
		mapaValores.put("fechaEscritura", !Checks.esNulo(expediente.getFechaVenta()) ? FileUtilsREM.stringify(expediente.getFechaVenta()) : "");
	}
	
	/**
	 * Recopila información registral por activo, para incluirlos en una lista.
	 * @param listaAof
	 * @return
	 * @throws Exception
	 */
	private List<Object> dataSourceInfoRegistralPorActivo(List<ActivoOferta> listaAof) throws Exception {
		
		DtoDataSource dtoDataSource = new DtoDataSource();

		List<Object> array = new ArrayList<Object>();
		for(ActivoOferta activoOferta : listaAof) {
			DtoInfoActivoFacturaVenta dto = new DtoInfoActivoFacturaVenta();
			Activo activo = activoOferta.getPrimaryKey().getActivo();
			
			dto.setDescPorcActivo(this.getInfoActivoPropietario(activo).toUpperCase());
			dto.setNumRefActivo(!Checks.esNulo(activo.getNumActivoUvem()) ? activo.getNumActivoUvem().toString() : "-");
			dto.setDireccionActivo(FileUtilsREM.stringify(activo.getDireccion()).toUpperCase());
			dto.setInfoRegistralActivo(this.getInfoRegistralActivo(activo));
			
			array.add(dto);
		}
		
		dtoDataSource.setListaActivo(array);
		List<Object> dataSource =  new ArrayList<Object>();
		dataSource.add(dtoDataSource);
		
		return dataSource;
	}
	
	private String getInfoActivoPropietario(Activo activo) throws Exception {
		StringBuilder infoActivoYPropietario = new StringBuilder();
		
		if(!Checks.esNulo(activo.getSubtipoActivo()))
			infoActivoYPropietario.append(activo.getSubtipoActivo().getDescripcion()+ " ");
		
		if(!Checks.esNulo(activo.getEstadoActivo()))
			infoActivoYPropietario.append(activo.getEstadoActivo().getDescripcion() + ". ");
		
		infoActivoYPropietario.append(this.getInfoPropietarioSobreActivo(activo));
		
		return infoActivoYPropietario.toString();
	}
	
	
	// ----------- Información común para las facturas de Activos o Lote
	
	private void rellenarDatosComprador(ExpedienteComercial expediente, Map<String, Object> mapaValores, Comprador comprador) {
		
		mapaValores.put("nombreComprador", comprador.getFullName().toUpperCase());
		mapaValores.put("direccionComprador", analyzeString(comprador.getDireccion()).toUpperCase());
		//Codigo postal y Localidad
		StringBuilder infoDomicilio = new StringBuilder();
		infoDomicilio.append(analyzeString(comprador.getCodigoPostal()));
		infoDomicilio.append(!Checks.esNulo(comprador.getLocalidad()) ? " "+comprador.getLocalidad().getDescripcion() : "");
		mapaValores.put("cpLocalidadComprador", infoDomicilio.toString().toUpperCase());
		
		mapaValores.put("provinciaComprador",!Checks.esNulo(comprador.getProvincia()) ? comprador.getProvincia().getDescripcion().toUpperCase() : "");
		
		mapaValores.put("cifComprador", analyzeString(comprador.getDocumento()).toUpperCase());
	}
	
	private Double rellenarDatosFactura(ExpedienteComercial expediente, Map<String, Object> mapaValores, Double porcentajeCompra) throws Exception {
		DecimalFormat df = new DecimalFormat("#,##0.00");
		df.setDecimalFormatSymbols(new DecimalFormatSymbols(Locale.ITALY));
		
		String tipoImpuesto = !Checks.esNulo(expediente.getCondicionante().getTipoImpuesto()) ? expediente.getCondicionante().getTipoImpuesto().getDescripcion() : "-";
		Double iva = !Checks.esNulo(expediente.getCondicionante().getTipoAplicable()) ? expediente.getCondicionante().getTipoAplicable() : 0.0;
		Double importeOferta = !Checks.esNulo(expediente.getOferta().getImporteContraOferta()) ? 
									expediente.getOferta().getImporteContraOferta() : (!Checks.esNulo(expediente.getOferta().getImporteOferta()) ? 
											expediente.getOferta().getImporteOferta() : 0.0);
		importeOferta = importeOferta * (porcentajeCompra / 100);
		
		mapaValores.put("tipoImpuesto", tipoImpuesto + ":");
		mapaValores.put("iva", FileUtilsREM.stringify(iva)+" %");
		mapaValores.put("importeVenta", df.format(importeOferta)+" €");
		
		Double importeImpuestos = importeOferta * (iva / 100);
		mapaValores.put("importeImpuestos",df.format(importeImpuestos)+" €");
		mapaValores.put("totalFactura",df.format(importeOferta+importeImpuestos)+" €");
		
		return importeOferta;
	}
	
	private void rellenarDatosFormaDePago(ExpedienteComercial expediente, Map<String, Object> mapaValores, Double importeOferta, Double porcentajeCompra) throws Exception {
		DecimalFormat df = new DecimalFormat("#,##0.00");
		df.setDecimalFormatSymbols(new DecimalFormatSymbols(Locale.ITALY));
		
		Double importeReserva = !Checks.esNulo(expediente.getCondicionante()) ? (!Checks.esNulo(expediente.getCondicionante().getImporteReserva()) ? expediente.getCondicionante().getImporteReserva() : 0.0) : 0.0;
		importeReserva = importeReserva * (porcentajeCompra / 100);
		
		mapaValores.put("importeReserva",df.format(importeReserva)+" €");
		mapaValores.put("importeFirma", df.format(importeOferta-importeReserva)+" €");
	}
	
	private void rellenarMensajesConstantes(Map<String, Object> mapaValores, Boolean mostrartMsgIva) {
		
		mapaValores.put("msgDireccionCartera", messageServices.getMessage(FACTURA_DIRECCION_CARTERA));
		if(mostrartMsgIva)
			mapaValores.put("msgLeyIva", messageServices.getMessage(FACTURA_LEY_IVA));
		mapaValores.put("msgRegistroMercantil", messageServices.getMessage(FACTURA_REGISTRO_MERCANTIL));
	}
	
	private String getInfoRegistralActivo(Activo activo) {
		
		Boolean existeInfoRegistral = !Checks.esNulo(activo.getInfoRegistral()) && !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien()) 
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca()) && !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getLocalidad());
		StringBuilder infoRegistral = new StringBuilder();
		
		if(existeInfoRegistral) {
			infoRegistral.append("Finca Registral nº "+activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
			infoRegistral.append(" del Registro de la Propiedad nº "+activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro());
			infoRegistral.append(" de "+activo.getInfoRegistral().getInfoRegistralBien().getLocalidad().getDescripcion().toUpperCase());
		}
		
		return infoRegistral.toString();
	}

	private String getInfoPropietarioSobreActivo(Activo activo) throws Exception {
		String info = "";
		if(!Checks.estaVacio(activo.getPropietariosActivo())) {
			String porcPropietario = FileUtilsREM.stringify(activo.getPropietariosActivo().get(0).getPorcPropiedad());
			String nombrePropietario = activo.getPropietariosActivo().get(0).getPropietario().getFullName();
			String[] datosParticipacionPropietario = {porcPropietario,nombrePropietario};
		
			info = !Checks.esNulo(porcPropietario) ? messageServices.getMessage(FACTURA_PORCENTAJE_PROPIETARIO_EN_ACTIVO,datosParticipacionPropietario) : "";
		}
		
		return info.toUpperCase();
	}
	
	private String analyzeString(String s) {
		if(!Checks.esNulo(s))
			return s;
		else
			return "";
	}
}
