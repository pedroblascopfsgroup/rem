package es.pfsgroup.plugin.rem.propuestaprecios.service.impl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;

import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.read.biff.BiffException;
import jxl.write.Blank;
import jxl.write.Formula;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.NumberFormat;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad01;
import es.pfsgroup.plugin.rem.propuestaprecios.service.GenerarPropuestaPreciosService;

@Component
public class GenerarPropuestaPreciosServiceEntidad01 implements GenerarPropuestaPreciosService {
	
	@Autowired
	private GenericABMDao genericDao;
	
	private Workbook libroExcel; 
	private WritableWorkbook libroEditable;
	private File file;
	
	protected static final Log logger = LogFactory.getLog(GenerarPropuestaPreciosServiceEntidad01.class);
	private static final String txtFechaSancion = "Fecha Sanción: ";
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{GenerarPropuestaPreciosService.EXCEL_CAJAMAR_CODIGO};
	}
	
	public GenerarPropuestaPreciosServiceEntidad01() {
		super();
	}
	
	@Override
	public File getFile() {
		return file;
	}

	@Override
	public void cargarPlantilla(ServletContext sc) {
		String ruta = sc.getRealPath("plantillas/plugin/propuestaprecios/ACTIVOS_PROPUESTA_PRECIOS_ENTIDAD01.xls");

		try {
			file = new File(ruta);
			WorkbookSettings workbookSettings = new WorkbookSettings();
			//workbookSettings.setEncoding( "Cp1252" );
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

	@SuppressWarnings("hiding")
	@Override
	public <DtoGenerarPropuestaPreciosEntidad01> void rellenarPlantilla(String numPropuesta, String gestor, List<DtoGenerarPropuestaPreciosEntidad01> listDto) {
		try {
			this.file = new File(file.getAbsolutePath().replace("_ENTIDAD01",""));
			libroEditable = Workbook.createWorkbook(this.file, libroExcel);

			WritableSheet hojaDetalle = libroEditable.getSheet(1);
			
			//Relenamos las celdas sueltas de Id propuesta, y gestor
			Label valor = new Label(2,1,numPropuesta);
			hojaDetalle.addCell(valor);
			valor = new Label(2,2,gestor);
			hojaDetalle.addCell(valor);
			
			//Bucle para rellenar listado de activos
			int fila = 6;
			for(DtoGenerarPropuestaPreciosEntidad01 dto : listDto) {
			
				rellenarFilaExcelPropuestaPrecio(hojaDetalle, (es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad01) dto,fila);
				fila++;
			}
			
			//Rellenamos la primera hoja RESUMEN
			PropuestaPrecio propuesta = genericDao.get(PropuestaPrecio.class, genericDao.createFilter(FilterType.EQUALS, "numPropuesta",Long.parseLong(numPropuesta)));
			this.rellenarPrimeraHojaResumen(libroEditable.getSheet(0), fila, propuesta.getFechaSancion());
			
			libroEditable.write();
			libroEditable.close();
			libroExcel.close();
			
		} catch (IOException e) {
			logger.error(e.getMessage());
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
		
	}
	
	/**
	 * Rellena las filas con los datos del dto
	 * @param hoja
	 * @param dto
	 * @param fila
	 */
	private void rellenarFilaExcelPropuestaPrecio(WritableSheet hoja, DtoGenerarPropuestaPreciosEntidad01 dto, Integer fila) {
		
		Integer numFila = fila+1; //Numero fila real correspondiente a la hoja excel
		try {
			
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	        NumberFormat decimalNo = new NumberFormat("#.00"); 
	        WritableCellFormat numberFormat = new WritableCellFormat(decimalNo);

		
			hoja.addCell(new Label(1,fila,dto.getSociedadPropietaria()));
			hoja.addCell(new Label(2,fila,dto.getNumAgrupacionObraNueva()));
			hoja.addCell(new Label(3,fila,dto.getNombreAgrupacionObraNueva()));
			hoja.addCell(new Label(4,fila,dto.getNumAgrupacionRestringida()));
			hoja.addCell(new Label(5,fila,dto.getNumActivo()));
			hoja.addCell(new Label(6,fila,dto.getNumActivoUvem()));
			hoja.addCell(new Label(7,fila,dto.getNumActivoRem()));
			hoja.addCell(new Label(8,fila,dto.getNumAgrupacionRestringida()));
			hoja.addCell(new Label(9,fila,dto.getDireccion()));
			hoja.addCell(new Label(10,fila,dto.getMunicipio()));
			hoja.addCell(new Label(11,fila,dto.getProvincia()));
			hoja.addCell(new Label(12,fila,dto.getCodigoPostal()));
			hoja.addCell(new Label(13,fila,dto.getTipoActivoDescripcion()));
			hoja.addCell(new Label(14,fila,!Checks.esNulo(dto.getNumAgrupacionObraNueva()) ? "Si" : "No"));
			hoja.addCell(new Label(15,fila,dto.getSituacionComercialDescripcion()));
			hoja.addCell(new Label(16,fila,dto.getSituacionComercialDescripcion()));
			hoja.addCell(new Label(17,fila,dto.getOrigen()));
			
			if(!Checks.esNulo(dto.getFechaInscripcion()))
				hoja.addCell(new Label(18,fila,sdf.format(dto.getFechaInscripcion())));
			if(!Checks.esNulo(dto.getFechaRevisionCargas()))
				hoja.addCell(new Label(19,fila,sdf.format(dto.getFechaRevisionCargas())));
			if(!Checks.esNulo(dto.getFechaTomaPosesion()))
				hoja.addCell(new Label(20,fila,sdf.format(dto.getFechaTomaPosesion())));
			// 21 Disponible administrativo
			// 22 Disponible técnico
			hoja.addCell(new Label(23,fila,!Checks.esNulo(dto.getFechaPublicacion()) ? "Si" : "No"));
			if(!Checks.esNulo(dto.getFechaPublicacion()))
				hoja.addCell(new Label(24,fila,sdf.format(dto.getFechaPublicacion())));
			
			hoja.addCell(new Label(25,fila,dto.getOcupado()));
			if(!Checks.esNulo(dto.getNumVisitas()))
				hoja.addCell(new Label(26,fila,dto.getNumVisitas().toString()));
			if(!Checks.esNulo(dto.getNumOfertas()))
				hoja.addCell(new Label(27,fila,dto.getNumOfertas().toString()));
			// 28 Número ventas
			if(!Checks.esNulo(dto.getValorFsv()) && dto.getValorFsv() != 0.0)
				hoja.addCell(new Number(29,fila,dto.getValorFsv(),numberFormat));
			if(!Checks.esNulo(dto.getFechaFsv()))
				hoja.addCell(new Label(30,fila,sdf.format(dto.getFechaFsv())));
			if(!Checks.esNulo(dto.getValorEstimadoVenta()) && dto.getValorEstimadoVenta() != 0.0)
				hoja.addCell(new Number(31,fila,dto.getValorEstimadoVenta(),numberFormat));
			if(!Checks.esNulo(dto.getFechaEstimadoVenta()))
				hoja.addCell(new Label(32,fila,sdf.format(dto.getFechaEstimadoVenta())));
			if(!Checks.esNulo(dto.getValorVnc()) && dto.getValorVnc() != 0.0)
				hoja.addCell(new Number(33,fila,dto.getValorVnc(),numberFormat));
			if(!Checks.esNulo(dto.getValorAdquisicion()) && dto.getValorAdquisicion() != 0.0)
				hoja.addCell(new Number(34,fila,dto.getValorAdquisicion(),numberFormat));
			if(!Checks.esNulo(dto.getValorTasacion()) && dto.getValorTasacion() != 0.0)
				hoja.addCell(new Number(35,fila,dto.getValorTasacion(),numberFormat));
			if(!Checks.esNulo(dto.getFechaTasacion()))
				hoja.addCell(new Label(36,fila,sdf.format(dto.getFechaTasacion())));
			// 37 Histórico ventas
			// 38 Fecha histórico ventas
			if(!Checks.esNulo(dto.getPrecioAutorizado()) && dto.getPrecioAutorizado() != 0.0)
				hoja.addCell(new Number(39,fila,dto.getPrecioAutorizado(),numberFormat));
			if(!Checks.esNulo(dto.getFechaAutorizado()))
				hoja.addCell(new Label(40,fila,sdf.format(dto.getFechaAutorizado())));
			if(!Checks.esNulo(dto.getValorVentaWeb()) && dto.getValorVentaWeb() != 0.0)
				hoja.addCell(new Number(41,fila,dto.getValorVentaWeb(),numberFormat));
			if(!Checks.esNulo(dto.getFechaVentaWeb()))
				hoja.addCell(new Label(42,fila,sdf.format(dto.getFechaVentaWeb())));
			if(!Checks.esNulo(dto.getPrecioEventoAutorizado()) && dto.getPrecioEventoAutorizado() != 0.0)
				hoja.addCell(new Number(43,fila,dto.getPrecioEventoAutorizado(),numberFormat));
			if(!Checks.esNulo(dto.getFechaInicioEventoAutorizado()))
				hoja.addCell(new Label(44,fila,sdf.format(dto.getFechaInicioEventoAutorizado())));
			if(!Checks.esNulo(dto.getFechaFinEventoAutorizado()))
				hoja.addCell(new Label(45,fila,sdf.format(dto.getFechaFinEventoAutorizado())));
			if(!Checks.esNulo(dto.getPrecioEventoWeb()) && dto.getPrecioEventoWeb() != 0.0)
				hoja.addCell(new Number(46,fila,dto.getPrecioEventoWeb(),numberFormat));
			if(!Checks.esNulo(dto.getFechaInicioEventoWeb()))
				hoja.addCell(new Label(47,fila,sdf.format(dto.getFechaInicioEventoWeb())));
			if(!Checks.esNulo(dto.getFechaFinEventoWeb()))
				hoja.addCell(new Label(48,fila,sdf.format(dto.getFechaFinEventoWeb())));
			// 49 Denominación campanya/evento
			if(!Checks.esNulo(dto.getValorRentaWeb()) && dto.getValorRentaWeb() != 0.0)
				hoja.addCell(new Number(50,fila,dto.getValorRentaWeb(),numberFormat));
			if(!Checks.esNulo(dto.getValorPropuesto()) && dto.getValorPropuesto() != 0.0)
				hoja.addCell(new Number(51,fila,dto.getValorPropuesto(),numberFormat));
			// 52 Motivo precio
			
			hoja.addCell(new Formula(53, fila, "IF(ISBLANK(AZ"+numFila+"),\"\",IF(ISBLANK(AH"+numFila+"),\"\",ROUND(AZ"+numFila+"-AH"+numFila+",2))"));//(IMPACTO) Propuesto - VNC
			hoja.addCell(new Formula(54, fila, "IF(ISBLANK(AJ"+numFila+"),\"\", IF(ISBLANK(AZ"+numFila+"), \"\", ROUND(IF(AJ"+numFila+"-1<>0, ((AZ"+numFila+"/AJ"+numFila+"-1)*-1), \"\"), 2)))")); //Porcentaje Tas/Propuesto
			hoja.addCell(new Formula(55, fila, "IF(ISBLANK(AD"+numFila+"),\"\", IF(ISBLANK(AZ"+numFila+"), \"\", ROUND(IF(AD"+numFila+"-1<>0, ((AZ"+numFila+"/AD"+numFila+"-1)*-1), \"\"), 2)))")); //Porcentaje Valor Haya/Propuesto
			hoja.addCell(new Formula(56, fila, "IF(ISBLANK(AP"+numFila+"),\"\", IF(ISBLANK(AZ"+numFila+"), \"\", ROUND(IF(AP"+numFila+"-1<>0, ((AZ"+numFila+"/AP"+numFila+"-1)*-1), \"\"), 2)))")); //Porcentaje Valor actual web/Propuesto
	
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
		
	}
	
	/**
	 * Agrega formula a la Hoja Resumen del informe
	 * @param hoja
	 * @param fila
	 */
	private void rellenarPrimeraHojaResumen(WritableSheet hoja, Integer fila, Date fechaSancion) {

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			//Settear celdas mergeadas restantes a Blank, para evitar warnings en el log
			this.formateoCeldasMergeadas(hoja);
			
			//----------------------------------------------------------------------------------------------------------------------
			// Número de activos totales
			hoja.addCell(new Formula(1,5,"COUNTA(DETALLE!F7:DETALLE!F"+fila+")",hoja.getCell(1, 5).getCellFormat()));
			// Valor tasación
			hoja.addCell(new Formula(2,5,"SUM(DETALLE!AJ7:DETALLE!AJ"+fila+")",hoja.getCell(2, 5).getCellFormat()));			
			// VNC
			hoja.addCell(new Formula(3,5,"SUM(DETALLE!AH7:DETALLE!AH"+fila+")",hoja.getCell(3, 5).getCellFormat()));
			// Precio autorizado
			hoja.addCell(new Formula(4,5,"SUM(DETALLE!AN7:DETALLE!AN"+fila+")",hoja.getCell(4, 5).getCellFormat()));
			// Precio propuesto
			hoja.addCell(new Formula(5,5,"SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")",hoja.getCell(5, 5).getCellFormat()));
			// IMPACTO
			hoja.addCell(new Formula(6,5,"SUM(DETALLE!BB7:DETALLE!BB"+fila+")",hoja.getCell(6, 5).getCellFormat()));
			// Precio autorizado
			hoja.addCell(new Formula(7,5,"SUM(DETALLE!BF7:DETALLE!BF"+fila+")",hoja.getCell(7, 5).getCellFormat()));
			// IMPACTO ????
			
			
			//----------------------------------------------------------------------------------------------------------------------
			//Descuento - Tasacion
			hoja.addCell(new Formula(9, 5, "IF(SUM(DETALLE!AJ7:DETALLE!AJ"+fila+")=0,\"\", IF(SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")=0, \"\", ROUND(IF(SUM(DETALLE!AJ7:DETALLE!AJ"+fila+")-1<>0, (((SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")/SUM(DETALLE!AJ7:DETALLE!AJ"+fila+"))-1)*-1), \"\"), 2)))"
					,hoja.getCell(9, 5).getCellFormat()));
			hoja.addCell(new Formula(10, 5, "IF(SUM(DETALLE!BF7:DETALLE!BF"+fila+")=0,\"\", IF(SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")=0, \"\", ROUND(IF(SUM(DETALLE!BF7:DETALLE!BF"+fila+")-1<>0, (((SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")/SUM(DETALLE!BF7:DETALLE!BF"+fila+"))-1)*-1), \"\"), 2)))"
					,hoja.getCell(10, 5).getCellFormat()));
			
			//Descuento - Valor haya
			hoja.addCell(new Formula(11, 5, "IF(SUM(DETALLE!AD7:DETALLE!AD"+fila+")=0,\"\", IF(SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")=0, \"\", ROUND(IF(SUM(DETALLE!AD7:DETALLE!AD"+fila+")-1<>0, (((SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")/SUM(DETALLE!AD7:DETALLE!AD"+fila+"))-1)*-1), \"\"), 2)))"
					,hoja.getCell(11, 5).getCellFormat()));
			hoja.addCell(new Formula(12, 5, "IF(SUM(DETALLE!BJ7:DETALLE!BJ"+fila+")=0,\"\", IF(SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")=0, \"\", ROUND(IF(SUM(DETALLE!BJ7:DETALLE!BJ"+fila+")-1<>0, (((SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")/SUM(DETALLE!BJ7:DETALLE!BJ"+fila+"))-1)*-1), \"\"), 2)))"
					,hoja.getCell(12, 5).getCellFormat()));
			
			//Descuento - Valor haya
			hoja.addCell(new Formula(13, 5, "IF(SUM(DETALLE!AP7:DETALLE!AP"+fila+")=0,\"\", IF(SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")=0, \"\", ROUND(IF(SUM(DETALLE!AP7:DETALLE!AP"+fila+")-1<>0, (((SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")/SUM(DETALLE!AP7:DETALLE!AP"+fila+"))-1)*-1), \"\"), 2)))"
					,hoja.getCell(13, 5).getCellFormat()));
			hoja.addCell(new Formula(14, 5, "IF(SUM(DETALLE!BM7:DETALLE!BM"+fila+")=0,\"\", IF(SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")=0, \"\", ROUND(IF(SUM(DETALLE!BM7:DETALLE!BM"+fila+")-1<>0, (((SUM(DETALLE!AZ7:DETALLE!AZ"+fila+")/SUM(DETALLE!BM7:DETALLE!BM"+fila+"))-1)*-1), \"\"), 2)))"
					,hoja.getCell(14, 5).getCellFormat()));
			
			//----------------------------------------------------------------------------------------------------------------------
			//Fecha Sanción		txtFechaSancion
			if(!Checks.esNulo(fechaSancion))
				hoja.addCell(new Label(1,8,txtFechaSancion.concat(sdf.format(fechaSancion)),hoja.getCell(1, 8).getCellFormat()));
						
		} catch (RowsExceededException e) {
			logger.error(e.getMessage());
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
	}
	
	private void formateoCeldasMergeadas(WritableSheet hoja) {

		//(hoja, colIni, colFin, rowIni, rowFin)
		this.setBlankToCells(hoja, 1, 14, 1, null); 	// Rango B2-02
		this.setBlankToCells(hoja, 1, null, 2, 4);		// Rango B3-B5
		this.setBlankToCells(hoja, 2, null, 2, 4);		// Rango C3-C5
		this.setBlankToCells(hoja, 3, null, 2, 4);		// Rango D3-D5
		this.setBlankToCells(hoja, 4, null, 2, 4);		// Rango E3-E5
		this.setBlankToCells(hoja, 5, 6, 2, null);		// Rango F3-G3
		this.setBlankToCells(hoja, 5, null, 3, 4);		// Rango F4-F5
		this.setBlankToCells(hoja, 6, null, 3, 4);		// Rango G4-G5
		this.setBlankToCells(hoja, 7, 8, 2, null);		// Rango H3-I3
		this.setBlankToCells(hoja, 7, null, 3, 4);		// Rango H4-H5
		this.setBlankToCells(hoja, 8, null, 3, 4);		// Rango I4-I5
		this.setBlankToCells(hoja, 9, 14, 2, null);		// Rango J3-03
		this.setBlankToCells(hoja, 9, 10, 3, null);		// Rango J4-K4
		this.setBlankToCells(hoja, 11, 12, 3, null);	// Rango L4-M4
		this.setBlankToCells(hoja, 13, 14, 3, null);	// Rango N4-O4
	}
	
	/**
	 * Settea las celdas en blanco en los rangos indicados
	 * @param hoja - Hoja excel
	 * @param colIni - Columna inicio
	 * @param colFin - Columna fin
	 * @param rowIni - Fila inicio
	 * @param rowFin - Fila fin
	 */
	private void setBlankToCells(WritableSheet hoja, Integer colIni, Integer colFin, Integer rowIni, Integer rowFin) {
		
		WritableCellFormat formato = new WritableCellFormat(hoja.getCell(colIni, rowIni).getCellFormat());
		
		try {
			
			if(!Checks.esNulo(colFin)) {
				for(int col = colIni+1; col <= colFin; col++) 
					hoja.addCell(new Blank(col,rowIni));
			}
			
			if(!Checks.esNulo(rowFin)) {
				for(int row = rowIni+1; row <= rowFin; row++) 
					hoja.addCell(new Blank(colIni,row));
			}
			
			hoja.getWritableCell(colIni, rowIni).setCellFormat(formato);
		
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

}
