package es.pfsgroup.plugin.rem.propuestaprecios.service.impl;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosUnificada;
import es.pfsgroup.plugin.rem.propuestaprecios.service.GenerarPropuestaPreciosService;


@Component
public class GenerarPropuestaPreciosServiceUnficada implements GenerarPropuestaPreciosService {
	
	private Workbook libroExcel; 
	private WritableWorkbook libroEditable;
	private File file;
	
	protected static final Log logger = LogFactory.getLog(GenerarPropuestaPreciosServiceUnficada.class);
	
	@Autowired
    private ServletContext servletContext;
	
	@Override
	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{GenerarPropuestaPreciosService.DEFAULT_SERVICE_BEAN_KEY};
	}
	
	public GenerarPropuestaPreciosServiceUnficada() {
		super();
	}
	
	@Override
	public void cargarPlantilla(ServletContext sc) {
		String ruta = sc.getRealPath("plantillas/plugin/propuestaprecios/ACTIVOS_PROPUESTA_PRECIOS_UNIFICADA.xls");

		try {
		
			file = new File(ruta);
			WorkbookSettings workbookSettings = new WorkbookSettings();
			workbookSettings.setEncoding( "Cp1252" );
			workbookSettings.setSuppressWarnings(true);
			workbookSettings.setCellValidationDisabled(true);
			workbookSettings.setMergedCellChecking(false);
			libroExcel = Workbook.getWorkbook( file, workbookSettings );
			
		} catch (BiffException e) {
			logger.error(e.getMessage());
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
	}
	
	@Override
	public <DtoExcelPropuestaUnificada> void rellenarPlantilla(String numPropuesta, String gestor, List<DtoExcelPropuestaUnificada> listDto) {
		
		try {
			this.file = new File(file.getAbsolutePath().replace("_UNIFICADA",""));
			libroEditable = Workbook.createWorkbook(this.file, libroExcel);

			WritableSheet hoja = libroEditable.getSheet(0);
			
			//Relenamos las celdas sueltas de Id propuesta, y gestor
			Label valor = new Label(2,1,numPropuesta);
			hoja.addCell(valor);
			valor = new Label(2,2,gestor);
			hoja.addCell(valor);
			
			//Bucle para rellenar listado de activos
			int fila = 8;
			for(DtoExcelPropuestaUnificada dto : listDto) {
			
				rellenarFilaExcelPropuestaPrecio(hoja,(es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosUnificada) dto,fila);
				fila++;
			}
			
			libroEditable.write();
			libroEditable.close();
			libroExcel.close();
			
		} catch (IOException e) {
			logger.error(e.getMessage());
		} catch (RowsExceededException e) {
			logger.error(e.getMessage());
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
	}
	
	// TODO: Hacer como en los servicios de las Entidades, donde se usa Formula, Number para las celdas, y el formato de celdas en la plantilla para dichos valores
	private void rellenarFilaExcelPropuestaPrecio(WritableSheet hoja, DtoGenerarPropuestaPreciosUnificada dto, Integer fila) {
		
		try {
			
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	        DecimalFormat df = new DecimalFormat("#.##");
	        df.setDecimalSeparatorAlwaysShown(false);
		
			//Propietario
	        
			hoja.addCell(new Label(1,fila,dto.getSociedadPropietaria()));
			//Activo
			hoja.addCell(new Label(2,fila,dto.getOrigen()));
			if(!Checks.esNulo(dto.getFechaEntrada()))
				hoja.addCell(new Label(3,fila,sdf.format(dto.getFechaEntrada())));
				
			hoja.addCell(new Label(4,fila,dto.getNumActivo()));
			hoja.addCell(new Label(5,fila,dto.getNumActivoRem()));
			hoja.addCell(new Label(6,fila,dto.getRefCatastral()));
			hoja.addCell(new Label(7,fila,dto.getNumFincaRegistral()));
			hoja.addCell(new Label(8,fila,dto.getNumAgrupacionObraNueva()));
			hoja.addCell(new Label(9,fila,dto.getNumAgrupacionRestringida()));
			hoja.addCell(new Label(10,fila,dto.getTipoActivoDescripcion()));
			hoja.addCell(new Label(11,fila,dto.getSubtipoActivoDescripcion()));
			hoja.addCell(new Label(12,fila,dto.getDireccion()));
			hoja.addCell(new Label(13,fila,dto.getMunicipio()));
			hoja.addCell(new Label(14,fila,dto.getProvincia()));
			hoja.addCell(new Label(15,fila,dto.getCodigoPostal()));
			//16 Falta propuesta FORZADA/AUTOMATICA
			//Estados por dpts.
			hoja.addCell(new Label(17,fila,dto.getAscensor() ? "Si" : "No"));
			if(!Checks.esNulo(dto.getNumDormitorios()))
				hoja.addCell(new Label(18,fila,dto.getNumDormitorios().toString()));
			if(dto.getSuperficieTotal() > 0)
				hoja.addCell(new Label(19,fila,df.format((dto.getSuperficieTotal()))));
			if(!Checks.esNulo(dto.getAnoConstruccion()))
				hoja.addCell(new Label(20,fila,dto.getAnoConstruccion().toString()));
			hoja.addCell(new Label(21,fila,dto.getEstadoConstruccion()));
			hoja.addCell(new Label(22,fila,dto.getSituacionComercialDescripcion()));
			if(!Checks.esNulo(dto.getNumVisitas()))
				hoja.addCell(new Label(23,fila,dto.getNumVisitas().toString()));
			if(!Checks.esNulo(dto.getNumOfertas()))
				hoja.addCell(new Label(24,fila,dto.getNumOfertas().toString()));
			if(!Checks.esNulo(dto.getFechaInscripcion()))
				hoja.addCell(new Label(25,fila,sdf.format(dto.getFechaInscripcion())));
			if(!Checks.esNulo(dto.getFechaRevisionCargas()))
				hoja.addCell(new Label(26,fila,sdf.format(dto.getFechaRevisionCargas())));
			if(!Checks.esNulo(dto.getFechaTomaPosesion()))
				hoja.addCell(new Label(27,fila,sdf.format(dto.getFechaTomaPosesion())));
			hoja.addCell(new Label(28,fila,dto.getOcupado()));
			if(!Checks.esNulo(dto.getFechaPublicacion()))
				hoja.addCell(new Label(29,fila,sdf.format(dto.getFechaPublicacion())));
			//Valores
			if(!Checks.esNulo(dto.getValorEstimadoVenta()) && dto.getValorEstimadoVenta() > 0)
				hoja.addCell(new Label(30,fila,df.format(dto.getValorEstimadoVenta())));
			if(!Checks.esNulo(dto.getFechaEstimadoVenta()))
				hoja.addCell(new Label(31,fila,sdf.format(dto.getFechaEstimadoVenta())));

			if(!Checks.esNulo(dto.getFechaTasacion()))
				hoja.addCell(new Label(33,fila,sdf.format(dto.getFechaTasacion())));

			if(!Checks.esNulo(dto.getFechaFsv()))
				hoja.addCell(new Label(35,fila,sdf.format(dto.getFechaFsv())));
			if(!Checks.esNulo(dto.getMayorValoracion()) && dto.getMayorValoracion() != 0.0)
				hoja.addCell(new Label(40,fila,df.format(dto.getMayorValoracion())));
			//Precios actuales
			if(!Checks.esNulo(dto.getFechaVentaWeb()))
				hoja.addCell(new Label(42,fila,sdf.format(dto.getFechaVentaWeb())));
			if(!Checks.esNulo(dto.getValorRentaWeb()) && dto.getValorRentaWeb() > 0)
				hoja.addCell(new Label(43,fila,df.format(dto.getValorRentaWeb())));
			//Precios actuales y Precios propuestos
			if(!Checks.esNulo(dto.getValorPropuesto()) && dto.getValorPropuesto() > 0) {
				
				hoja.addCell(new Label(44,fila,df.format(dto.getValorPropuesto())));
				
				if(dto.getValorTasacion() > 0) {
					hoja.addCell(new Label(32,fila,df.format(dto.getValorTasacion())));
					Double resta = diferenciaEntreValores(dto.getValorPropuesto(),dto.getValorTasacion());				
					hoja.addCell(new Label(46,fila,df.format(resta)));
					hoja.addCell(new Label(47,fila,df.format(diferenciaEnPorcentaje(dto.getValorPropuesto(),dto.getValorTasacion()))+" %"));
				}
				if(dto.getValorFsv() > 0) {
					hoja.addCell(new Label(34,fila,df.format(dto.getValorFsv())));					
					hoja.addCell(new Label(48,fila,df.format(diferenciaEnPorcentaje(dto.getValorPropuesto(),dto.getValorFsv()))+" %"));
				}
				if(dto.getValorLiquidativo() > 0) {
					hoja.addCell(new Label(36,fila,df.format(dto.getValorLiquidativo())));
					if(!Checks.esNulo(dto.getFechaValorLiquidativo()))
						hoja.addCell(new Label(37,fila,sdf.format(dto.getFechaValorLiquidativo())));
				}
				if(dto.getValorVentaWeb() > 0) {
					hoja.addCell(new Label(41,fila,df.format(dto.getValorVentaWeb())));
					hoja.addCell(new Label(49,fila,df.format(diferenciaEnPorcentaje(dto.getValorPropuesto(),dto.getValorVentaWeb()))+" %"));
				}
				if(dto.getValorVnc() > 0) {
					hoja.addCell(new Label(38,fila,df.format(dto.getValorVnc())));
					Double resta = diferenciaEntreValores(dto.getValorPropuesto(),dto.getValorVnc());
					hoja.addCell(new Label(50,fila,df.format(resta)));
					hoja.addCell(new Label(51,fila,df.format(diferenciaEnPorcentaje(dto.getValorPropuesto(),dto.getValorVnc()))+" %"));
				}
				if(dto.getValorAdquisicion() > 0) {
					hoja.addCell(new Label(39,fila,df.format(dto.getValorAdquisicion())));
				}
				
			}
			
			
		} catch (RowsExceededException e) {
			logger.error(e.getMessage());
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
		
	}
	
	@Override
	public void vaciarLibros() {
		this.file = null;
		this.libroEditable = null;
		this.libroExcel = null;
	}
	
	private Double diferenciaEnPorcentaje(Double valorPropuesto, Double valor) {
		
		return ((valorPropuesto / valor ) * 100) - 100;
	}
	
	private Double diferenciaEntreValores(Double valorPropuesto, Double valor) {
		
		return valorPropuesto - valor;
	}
}
