package es.pfsgroup.plugin.recovery.coreextension.utils.jxl;

import java.io.File;
import java.io.IOException;
import java.util.List;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;
import es.pfsgroup.commons.utils.Checks;

public class HojaExcelMasivoSubastas extends HojaExcel {

	
	@SuppressWarnings("unused")
	private int filasReales;
	@SuppressWarnings("unused")
	private Workbook libroExcel; 
	

	public HojaExcelMasivoSubastas(){
		super();
		
	}
	
	/**
	 * Creamos un Excel desde cero, recibiendo la ruta completa del nombre de fichero,
	 * la lista con las cabeceras y los valores
	 * 
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @return booleano que indica si todo ha ido bien
	 */
	public boolean crearNuevoExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores) {
		return crearExcel(nombreFichero, cabeceras, valores, false, 5000);
		
	}

	/**
	 * Crear el excel generico
	 * 
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @param append
	 * @param maxFilasPagina paginado por número de filas
	 * @return booleano que indica si todo ha ido bien
	 */
	private boolean crearExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores, Boolean append, Integer maxFilasPagina) {
		boolean ok = true;
		boolean copiado = false;
		int hojaActual;
		int filaActual;
		
		//Si no se especifica, se limita el número de filas a 60.000, ya que es el valor máximo que permite la librería jxl
		if (Checks.esNulo(maxFilasPagina))
			maxFilasPagina = 60000;
		
		// Creamos un fichero temporal para copiar en caso de existir y trabajar sobre este en todos los casos
		String nombreFicheroTMP = nombreFichero + ".tmp.xls"; 
        File fileTMP = new File(nombreFicheroTMP);
               
        // Este ser� el fichero final, en el que se comprobar� que exista y luego se reemplazar�
        File fileFinal = new File(nombreFichero);
        
        try {
        	
        	// Se crea el fichero temporal en todos los casos ya que es aqu� donde se va a escribir
        	if (fileTMP.exists()) fileTMP.delete();
        	fileTMP.createNewFile();
        	
        	WritableWorkbook workbook = Workbook.createWorkbook(fileTMP);
        	hojaActual = 0;
        	WritableSheet sheet1 = workbook.createSheet("Hoja " + (hojaActual+1),hojaActual);

			//int filaAnt = 0;
			filaActual = 0;
			if (!fileFinal.exists()) {
			    fileFinal.createNewFile();
			} else {
				// Si tiene que a�adir al documento, se copiara el contenido de fileFinal a fileTMP
				if (append) {	
					Workbook target_workbook = Workbook.getWorkbook(fileFinal);
					workbook = Workbook.createWorkbook(fileTMP, target_workbook);

					this.libroExcel = target_workbook;
					this.setFile(fileFinal);		
					this.filasReales = -1;
					
					hojaActual= workbook.getSheets().length-1;
					sheet1 = workbook.getSheet(hojaActual);
					
					//filaAnt = getNumeroFilas()-1;
					filaActual=getNumeroFilas(hojaActual);
					cabeceras = getCabeceras(hojaActual);
					
					target_workbook.close();
					
					copiado = true;
				}
			} 
			if (fileTMP.canWrite()) {
				if (!copiado) {
					escribirCabeceras(sheet1, cabeceras);
					filaActual=1;
				}
				
			    for (int i = 0; i < valores.size(); i++) {
					if (((filaActual) % maxFilasPagina) == 0) {
						//Llegado el momento de paginar
						
						//Creamos una nueva hoja
						hojaActual++;
						workbook.createSheet("Hoja " + (hojaActual+1),hojaActual);
						sheet1 = workbook.getSheet(hojaActual);
						
						//Volvemos a escribir las cabeceras
						escribirCabeceras(sheet1, cabeceras);
						//Reiniciamos el contador de fila
						filaActual=1;
					}

			    	for (int j = 0; j < valores.get(i).size(); j++) {
						Label celda = new Label(j, filaActual, valores.get(i).get(j));
						sheet1.addCell(celda);
					}
					filaActual++;
				}
                workbook.write();
                workbook.close();
                
                // Hacemos que el fileTMP sea el fileFinal
                if (fileFinal.exists()) fileFinal.delete();
                fileTMP.renameTo(fileFinal);
                //Seteamos las propiedades
                this.setFile(fileFinal);
                this.setRuta(fileFinal.getAbsolutePath());
			}
		} catch (RowsExceededException e) {
			ok = false;
			e.printStackTrace();
		} catch (WriteException e) {
			ok = false;
			e.printStackTrace();
		} catch (IOException e) {
			ok = false;
			e.printStackTrace();
		} catch (BiffException e) {
			ok = false;
			e.printStackTrace();
		}
		return ok;
	}
	

	/**
	 * Escribe en la fila 0, las cabeceras con su correspondiente formato de celdas
	 * @param sheet1
	 * @param cabeceras
	 * @throws RowsExceededException
	 * @throws WriteException
	 */
	private void escribirCabeceras (WritableSheet sheet1, List<String> cabeceras) throws RowsExceededException, WriteException {
		// Pintamos las cabeceras de las columnas.
	    
	    WritableFont cellFontBold10 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
	    cellFontBold10.setColour(Colour.WHITE);
	    
	    WritableCellFormat cellFormatCabeceras = new WritableCellFormat(cellFontBold10);
	    cellFormatCabeceras.setFont(cellFontBold10);
	    cellFormatCabeceras.setAlignment(Alignment.CENTRE);
	    cellFormatCabeceras.setBackground(Colour.PLUM2);
	    cellFormatCabeceras.setBorder(Border.ALL, BorderLineStyle.THIN);
	    cellFormatCabeceras.setWrap(false);
	    for (int i = 0; i < cabeceras.size(); i++) {
	        Label column = new Label(i, 0, cabeceras.get(i), cellFormatCabeceras);
	        sheet1.setColumnView(column.getColumn(), cabeceras.get(i).length() + 3);	        
	        sheet1.addCell(column);
	    }
	}
		
}
