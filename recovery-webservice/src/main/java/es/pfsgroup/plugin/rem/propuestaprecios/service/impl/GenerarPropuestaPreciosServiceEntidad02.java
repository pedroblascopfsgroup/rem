package es.pfsgroup.plugin.rem.propuestaprecios.service.impl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletContext;

import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.NumberFormat;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad02;
import es.pfsgroup.plugin.rem.propuestaprecios.service.GenerarPropuestaPreciosService;

@Component
public class GenerarPropuestaPreciosServiceEntidad02 implements GenerarPropuestaPreciosService {
	
	private Workbook libroExcel; 
	private WritableWorkbook libroEditable;
	private File file;
	
	protected static final Log logger = LogFactory.getLog(GenerarPropuestaPreciosServiceEntidad02.class);
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{GenerarPropuestaPreciosService.EXCEL_SAREB_CODIGO};
	}
	
	public GenerarPropuestaPreciosServiceEntidad02() {
		super();
	}
	
	@Override
	public File getFile() {
		return file;
	}

	@Override
	public void cargarPlantilla(ServletContext sc) {
		String ruta = sc.getRealPath("plantillas/plugin/propuestaprecios/ACTIVOS_PROPUESTA_PRECIOS_ENTIDAD02.xls");

		try {
			file = new File(ruta);
			WorkbookSettings workbookSettings = new WorkbookSettings();
			workbookSettings.setEncoding( "Cp1252" );
			workbookSettings.setSuppressWarnings(true);
			libroExcel = Workbook.getWorkbook( file, workbookSettings );
			
		} catch (BiffException e) {
			logger.error(e.getMessage());
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
	}

	@SuppressWarnings("hiding")
	@Override
	public <DtoGenerarPropuestaPreciosEntidad02> void rellenarPlantilla(String numPropuesta, String gestor, List<DtoGenerarPropuestaPreciosEntidad02> listDto) {
		try {
			this.file = new File(file.getAbsolutePath().replace("_ENTIDAD02",""));
			libroEditable = Workbook.createWorkbook(this.file, libroExcel);

			WritableSheet hojaDetalle = libroEditable.getSheet(0);
			
			//Relenamos las celdas sueltas de Id propuesta, y gestor
			Label valor = new Label(2,1,numPropuesta);
			hojaDetalle.addCell(valor);
			valor = new Label(2,2,gestor);
			hojaDetalle.addCell(valor);
			
			//Bucle para rellenar listado de activos
			int fila = 4;
			for(DtoGenerarPropuestaPreciosEntidad02 dto : listDto) {
			
				rellenarFilaExcelPropuestaPrecio(hojaDetalle, (es.pfsgroup.plugin.rem.propuestaprecios.dto.DtoGenerarPropuestaPreciosEntidad02) dto,fila);
				fila++;
			}
			
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
	private void rellenarFilaExcelPropuestaPrecio(WritableSheet hoja, DtoGenerarPropuestaPreciosEntidad02 dto, Integer fila) {
		
	//	Integer numFila = fila+1; //Numero fila real correspondiente a la hoja excel
		try {
			
	        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	        NumberFormat decimalNo = new NumberFormat("#.00"); 
	        WritableCellFormat numberFormat = new WritableCellFormat(decimalNo);

		
			hoja.addCell(new Label(0,fila,dto.getSociedadPropietaria()));
			hoja.addCell(new Label(1,fila,dto.getNumActivoRem()));
			hoja.addCell(new Label(2,fila,dto.getNumActivo()));
			hoja.addCell(new Label(3,fila,dto.getNumAgrupacionObraNueva()));
			hoja.addCell(new Label(4,fila,dto.getNombreAgrupacionObraNueva()));
			
			if(!Checks.esNulo(dto.getFechaInscripcion()))
				hoja.addCell(new Label(5,fila,sdf.format(dto.getFechaInscripcion())));
			if(!Checks.esNulo(dto.getFechaRevisionCargas()))
				hoja.addCell(new Label(6,fila,sdf.format(dto.getFechaRevisionCargas())));
			if(!Checks.esNulo(dto.getFechaTomaPosesion()))
				hoja.addCell(new Label(7,fila,sdf.format(dto.getFechaTomaPosesion())));
			
			hoja.addCell(new Label(8,fila,dto.getSituacionComercialDescripcion()));
			hoja.addCell(new Label(9,fila,dto.getTipoActivoDescripcion()));
			hoja.addCell(new Label(10,fila,dto.getSubtipoActivoDescripcion()));
			hoja.addCell(new Label(11,fila,dto.getProvincia()));
			hoja.addCell(new Label(12,fila,dto.getMunicipio()));
			hoja.addCell(new Label(13,fila,dto.getDireccion()));
			hoja.addCell(new Label(14,fila,!Checks.esNulo(dto.getNumAgrupacionObraNueva()) ? "Si" : "No"));
			hoja.addCell(new Label(15,fila,dto.getEspecificacionesDireccion()));
			hoja.addCell(new Label(16,fila,dto.getAscensor() ? "Si" : "No"));
			if(!Checks.esNulo(dto.getNumDormitorios()))
				hoja.addCell(new Label(17,fila,dto.getNumDormitorios().toString()));
			hoja.addCell(new Label(18,fila,dto.getRefCatastral()));
			hoja.addCell(new Label(19,fila,dto.getNumFincaRegistral()));
			hoja.addCell(new Label(20,fila,!Checks.esNulo(dto.getFechaPublicacion()) ? "Si" : "No"));
			//21 url publicacion
			if(!Checks.esNulo(dto.getFechaPublicacion()))
				hoja.addCell(new Label(22,fila,sdf.format(dto.getFechaPublicacion())));
			if(!Checks.esNulo(dto.getSuperficieTotal()) && dto.getSuperficieTotal() != 0.0)
				hoja.addCell(new Number(23,fila,dto.getSuperficieTotal(),numberFormat));
			if(!Checks.esNulo(dto.getSuperficieUtil()) && dto.getSuperficieUtil() != 0.0)
				hoja.addCell(new Number(24,fila,dto.getSuperficieUtil(),numberFormat));
			//25 Superficie depurada
			if(!Checks.esNulo(dto.getSuperficieTerraza()) && dto.getSuperficieTerraza() != 0.0)
				hoja.addCell(new Number(26,fila,dto.getSuperficieTerraza(),numberFormat));
			if(!Checks.esNulo(dto.getSuperficieParcela()) && dto.getSuperficieParcela() != 0.0)
				hoja.addCell(new Number(27,fila,dto.getSuperficieParcela(),numberFormat));
			
			if(!Checks.esNulo(dto.getAnoConstruccion()))
				hoja.addCell(new Label(28,fila,dto.getAnoConstruccion().toString()));
			hoja.addCell(new Label(29,fila,dto.getEstadoConstruccion()));
			hoja.addCell(new Label(30,fila,dto.getOcupado()));
			if(!Checks.esNulo(dto.getNumVisitas()))
				hoja.addCell(new Label(31,fila,dto.getNumVisitas().toString()));
			if(!Checks.esNulo(dto.getNumOfertas()))
				hoja.addCell(new Label(32,fila,dto.getNumOfertas().toString()));
			if(!Checks.esNulo(dto.getNumReservas()))
				hoja.addCell(new Label(33,fila,dto.getNumReservas().toString()));
			//34 numero ventas
			//35 incluido en eventos/campanyas
			if(!Checks.esNulo(dto.getValorPropuesto()) && dto.getValorPropuesto() != 0.0)
				hoja.addCell(new Number(36,fila,dto.getValorPropuesto(),numberFormat));
			//37 propuesto precio renta
			if(!Checks.esNulo(dto.getValorEstimadoVenta()) && dto.getValorEstimadoVenta() != 0.0)
				hoja.addCell(new Number(38,fila,dto.getValorEstimadoVenta(),numberFormat));
			if(!Checks.esNulo(dto.getValorTasacion()) && dto.getValorTasacion() != 0.0)
				hoja.addCell(new Number(39,fila,dto.getValorTasacion(),numberFormat));
			if(!Checks.esNulo(dto.getFechaTasacion()))
				hoja.addCell(new Label(40,fila,sdf.format(dto.getFechaTasacion())));
			
			Double precioMetro = getPrecioPropuestoPorMetroCuadrado(dto.getValorPropuesto(),dto.getSuperficieTotal());
			if(!Checks.esNulo(precioMetro) && precioMetro != 0.0)
				hoja.addCell(new Number(41,fila,precioMetro,numberFormat));

			//hoja.addCell(new Formula(42, fila, "IF(ISBLANK(AK"+numFila+"),\"\",IF(ISBLANK(AS"+numFila+"),\"\",ROUND(AK"+numFila+"-AS"+numFila+",2))"));//PrecioPropuesto - VNC(valor transferencia)
			
			if(!Checks.esNulo(dto.getValorLiquidativo()) && dto.getValorLiquidativo() != 0.0)
				hoja.addCell(new Number(43,fila,dto.getValorLiquidativo(),numberFormat));
			if(!Checks.esNulo(dto.getValorVnc()) && dto.getValorVnc() != 0.0)
				hoja.addCell(new Number(44,fila,dto.getValorVnc(),numberFormat));
			
		} catch (WriteException e) {
			logger.error(e.getMessage());
		}
		
	}

	private Double getPrecioPropuestoPorMetroCuadrado(Double precio, Double superficie) {
		Double precioMetro = 0.0;
		
		if(!Checks.esNulo(precio) && !Checks.esNulo(superficie) && superficie > 0.0)
			precioMetro = precio / superficie;
		
		return precioMetro;
	}
	
	@Override
	public void vaciarLibros() {
		this.file = null;
		this.libroEditable = null;
		this.libroExcel = null;
	}

}
