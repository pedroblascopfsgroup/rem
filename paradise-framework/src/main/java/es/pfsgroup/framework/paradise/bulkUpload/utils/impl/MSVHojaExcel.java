package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.util.StringUtils;

import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import jxl.Cell;
import jxl.CellType;
import jxl.DateCell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.WorkbookSettings;
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

/**
 * 
 * @author carlos
 *
 */
public class MSVHojaExcel {

	private String ruta;
	
	private boolean isOpen = false;
	
	private int filasReales = -1;
	
	private int columnasReales = -1;
	
	private Workbook libroExcel; 
	
	private File file;

	public String getRuta() {
		return ruta;
	}

	public void setRuta(String ruta) {
		this.ruta = ruta;
	}

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	/**
	 * devuelve el número de filas reales de una hoja excel.
	 * Se considera que una fila es real si alguna de sus celda no está vacía.
	 * @return 
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public Integer getNumeroFilas() throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}
		
		if (this.filasReales < 0){
			Sheet hoja = libroExcel.getSheet(0);
			this.filasReales = 0;
			for (int i= hoja.getRows() - 1; i>0; i--) {
				Cell[] fila = hoja.getRow(i);
				if (!this.filaVacia(fila)){
					this.filasReales = i + 1;
					break;
				}
			}
		}
		 
		return this.filasReales;
	}
	
	/**
	 * Devuelve el número de columns reales de una hoja excel.
	 * Se considera una columan real cuando la cabecera no está vacía.
	 * 
	 * @return Integer número de columnas
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public Integer getNumeroColumnas() throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}
		
		if (this.columnasReales < 0){
			this.columnasReales = 0;
			Sheet hoja = libroExcel.getSheet(0);
			Cell[] cabeceras = hoja.getRow(0);
			
			//Masivo propuesta precios: Si no se detecta la cabecera en fila0, prueba con fila7
			if(cabeceras.length == 0)
				cabeceras = hoja.getRow(7);

			//for (int i=cabeceras.length - 1; i>0; i--) {
			for (int i=cabeceras.length -1; i>=0; i--){
				Cell celda = cabeceras[i];
				if (celda != null && StringUtils.hasText(celda.getContents())){
					this.columnasReales = i + 1;
					break;
				}
			}
		}		
		return this.columnasReales;
		
	}

	/**
	 * Comprueba si una fila de una hoja excel está vacia.
	 * Para que una fila esté vacía todas sus celdas deben estar vacías.
	 * Una celda está vacía si su contenido es nulo o de tamaño cero.
	 * @param fila
	 * @return
	 */
	private boolean filaVacia(Cell[] fila) {
		for (int i=0; i<fila.length; i++) {
			Cell celda = fila[i];
			if (celda != null && StringUtils.hasText(celda.getContents())){
				return false;
			}
		}
		return true;
	}

	/**
	 * Devuelve el listado de columnas del excel
	 * Si el nombre de la columna es nulo devuelve un string vacío.
	 * Elimina los espacios en blanco al principio y final del nombre de la columna.
	 * @return lista de columnas
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public List<String> getCabeceras() 
			throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}
		Sheet hoja = libroExcel.getSheet(0);
		List<String> lista = new ArrayList<String>();
		int numColumnas = this.getNumeroColumnas();
		for (int i=0; i<numColumnas; i++) {
			String nombre = hoja.getCell(i, 0).getContents();
			if (nombre == null) nombre = "";
			lista.add(nombre.trim());
		}
		return lista;
	}

	public String crearExcelErrores(List<String> listaErrores) 
			throws IllegalArgumentException, IOException, RowsExceededException, WriteException {
		if (!isOpen) {
			abrir();
		}
		
		String nombreFicheroErrores = getNombreFicheroErrores();
		
		WritableWorkbook copy = Workbook.createWorkbook(new File(nombreFicheroErrores), libroExcel);
		
		
		WritableSheet hoja = copy.getSheet(0);
		int numColumnas = this.getNumeroColumnas();
		for (int i=0; i<listaErrores.size(); i++) {
			addTexto(hoja, numColumnas, i+1, listaErrores.get(i));
		}
		copy.write();
		copy.close();

		return nombreFicheroErrores;
	}
	
	public String crearExcelErroresMejorado(Map<String,List<Integer>> mapaErrores) throws IllegalArgumentException, IOException, RowsExceededException, WriteException {
		if(!isOpen){
			abrir();
		}
		
		String nombreFicheroErrores = getNombreFicheroErrores();
		
		WritableWorkbook copy = Workbook.createWorkbook(new File(nombreFicheroErrores), libroExcel);
		
		WritableSheet hoja = copy.getSheet(0);
		int numColumnas = this.getNumeroColumnas();
		int numErrores = mapaErrores.size();
		
		Iterator<String> it = mapaErrores.keySet().iterator();
		int columna = numColumnas;
		while(it.hasNext()){
			String error = (String) it.next();
			for(int i = 0; i < mapaErrores.get(error).size(); i++){
				addTexto(hoja, columna, mapaErrores.get(error).get(i), error);
			}
			if(!mapaErrores.get(error).isEmpty())
				columna++;
		}
		
		copy.write();
		copy.close();
		
		return nombreFicheroErrores;
	}

	public String dameCelda(int fila, int columna) 
			throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}
		String cellContent = null;
		Sheet hoja = libroExcel.getSheet(0);
		Cell cell = hoja.getCell(columna, fila);

		if (cell.getType() == CellType.DATE) 
		{ 
			DateCell dc = (DateCell) cell;
			DateFormat df = new SimpleDateFormat(FormatUtils.DDMMYYYY);
			cellContent = df.format(dc.getDate());
		} else {
			cellContent = cell.getContents();
		}
		
		return cellContent;
	}

	public void cerrar() {
		
		libroExcel = null;
		
		file = null;
		
		ruta = null;
		isOpen = false;
		
	}
	
	private void abrir() throws IllegalStateException, IOException {
		
		if ((ruta==null || (ruta.equals(""))) && (file==null)) {
			throw new IllegalStateException("El objeto MSVHojaExcel no tiene inicializada ni la ruta ni el file");
		}
		
		if (file==null) {
			file = new File(ruta);
		}
		
		try{
			WorkbookSettings workbookSettings = new WorkbookSettings();
			workbookSettings.setEncoding( "Cp1252" );
			libroExcel = Workbook.getWorkbook(file,workbookSettings);
			isOpen = true;
		} catch (BiffException e) {
			throw new IOException("Error al parsear el libro excel");
		}
	
	}
	
	private void addTexto(WritableSheet sheet, int column, int row, String s)
		      throws RowsExceededException, WriteException {
	    Label label;
	    label = new Label(column, row, s);
	    sheet.addCell(label);
	  }

	private String getNombreFicheroErrores() {
		String path;
		if (this.file != null){
			path = this.file.getAbsolutePath();
		}else if (!Checks.esNulo(this.ruta)){
			path = this.ruta;
		}else{
			throw new IllegalStateException("No se ha inicializado el File ni la Ruta");
		}
		
		String nombre = path.replace(".xls", "Err.xls").replace(".csv","Err.csv").replace(".tmp","Err.tmp"); 
		return nombre;
		
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
		return crearExcel(nombreFichero, cabeceras, valores, false);
//		boolean ok = true;
//		
//        File file = new File(nombreFichero);
//        try {
//			if (!file.exists()) {
//			    file.createNewFile();
//			}
//			if (file.canWrite()) {
//				WritableWorkbook workbook = Workbook.createWorkbook(file);
//			    WritableSheet sheet1 = workbook.createSheet("Hoja 1",0);
//
//			    // Pintamos las cabeceras de las columnas.
//			    WritableFont cellFontBold10 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
//			    WritableFont cellFontBold12 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD);
//
//			    WritableCellFormat cellFormatCabeceras = new WritableCellFormat(cellFontBold12);
//			    cellFormatCabeceras.setFont(cellFontBold10);
//			    cellFormatCabeceras.setAlignment(Alignment.CENTRE);
//			    cellFormatCabeceras.setBackground(Colour.PLUM2);
//			    cellFormatCabeceras.setBorder(Border.ALL, BorderLineStyle.THIN);
//			    cellFormatCabeceras.setWrap(false);
//			    for (int i = 0; i < cabeceras.size(); i++) {
//			        Label column = new Label(i, 0, cabeceras.get(i), cellFormatCabeceras);
//			        sheet1.addCell(column);
//			    }
//			    
//			    for (int i = 0; i < valores.size(); i++) {
//					for (int j = 0; j < valores.get(i).size(); j++) {
//						Label celda = new Label(j, i+1, valores.get(i).get(j));
//						sheet1.addCell(celda);
//					}
//				}
//                workbook.write();
//                workbook.close();
//			}
//		} catch (RowsExceededException e) {
//			ok = false;
//			e.printStackTrace();
//		} catch (WriteException e) {
//			ok = false;
//			e.printStackTrace();
//		} catch (IOException e) {
//			ok = false;
//			e.printStackTrace();
//		}
//		return ok;
		
	}

	/**
	 * Creamos un Excel desde cero o si se setea el parametro append=true añadimos el contenido al excel si existe, recibiendo la ruta completa del nombre de fichero,
	 * la lista con las cabeceras y los valores
	 * 
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @param append indica si se añade al fichero
	 * @return
	 */
	public boolean crearNuevoExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores, Boolean append) {
		return crearExcel(nombreFichero, cabeceras, valores, append);
	}
	
	/**
	 * Crear el excel generico
	 * 
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @param append
	 * @return
	 */
	private boolean crearExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores, Boolean append) {
		boolean ok = true;
		boolean copiado = false;
		
		// Creamos un fichero temporal para copiar en caso de existir y trabajar sobre este en todos los casos
		String nombreFicheroTMP = nombreFichero + ".tmp.xls"; 
        File fileTMP = new File(nombreFicheroTMP);
               
        // Este será el fichero final, en el que se comprobará que exista y luego se reemplazará
        File fileFinal = new File(nombreFichero);
        
        try {
        	
        	// Se crea el fichero temporal en todos los casos ya que es aquí donde se va a escribir
        	if (fileTMP.exists()) fileTMP.delete();
        	fileTMP.createNewFile();
        	
        	WritableWorkbook workbook = Workbook.createWorkbook(fileTMP);
        	WritableSheet sheet1 = workbook.createSheet("Hoja 1",0);
			
			int filaAnt = 0;
			if (!fileFinal.exists()) {
			    fileFinal.createNewFile();
			} else {
				// Si tiene que añadir al documento, se copiara el contenido de fileFinal a fileTMP
				if (append) {
					WorkbookSettings workbookSettings = new WorkbookSettings();
					workbookSettings.setEncoding( "Cp1252" );
					Workbook target_workbook = Workbook.getWorkbook(fileFinal,workbookSettings);
					workbook = Workbook.createWorkbook(fileTMP, target_workbook);
					
					sheet1 = workbook.getSheet(0);
					this.libroExcel = target_workbook;
					this.file = fileFinal;		
					this.filasReales = -1;
					filaAnt = getNumeroFilas()-1;
					
					target_workbook.close();
					
					copiado = true;
				}
			} 
			if (fileTMP.canWrite()) {
				if (!copiado) {
					// Pintamos las cabeceras de las columnas.
//					workbook = Workbook.createWorkbook(fileTMP);
//				    sheet1 = workbook.createSheet("Hoja 1",0);
				    
				    WritableFont cellFontBold10 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
				    WritableFont cellFontBold12 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD);

				    WritableCellFormat cellFormatCabeceras = new WritableCellFormat(cellFontBold12);
				    cellFormatCabeceras.setFont(cellFontBold10);
				    cellFormatCabeceras.setAlignment(Alignment.CENTRE);
				    cellFormatCabeceras.setBackground(Colour.PLUM2);
				    cellFormatCabeceras.setBorder(Border.ALL, BorderLineStyle.THIN);
				    cellFormatCabeceras.setWrap(false);
				    for (int i = 0; i < cabeceras.size(); i++) {
				        Label column = new Label(i, 0, cabeceras.get(i), cellFormatCabeceras);
				        sheet1.addCell(column);
				    }
				}
				
			    for (int i = 0; i < valores.size(); i++) {
					for (int j = 0; j < valores.get(i).size(); j++) {
						Label celda = new Label(j, i+filaAnt+1, valores.get(i).get(j));
						sheet1.addCell(celda);
					}
				}
                workbook.write();
                workbook.close();
                
                // Hacemos que el fileTMP sea el fileFinal
                if (fileFinal.exists()) fileFinal.delete();
                fileTMP.renameTo(fileFinal);
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
		
}
