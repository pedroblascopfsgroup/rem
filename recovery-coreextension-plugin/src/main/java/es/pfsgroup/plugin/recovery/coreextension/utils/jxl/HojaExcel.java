package es.pfsgroup.plugin.recovery.coreextension.utils.jxl;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.springframework.util.StringUtils;

import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;

import jxl.Cell;
import jxl.CellType;
import jxl.DateCell;
import jxl.Sheet;
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


public class HojaExcel {
	
	public final static String TIPO_EXCEL = "application/vnd.ms-excel";
	
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
	 * devuelve el n�mero de filas reales de una hoja excel.
	 * Se considera que una fila es real si alguna de sus celda no est� vac�a.
 	 *
	 * @return
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public Integer getNumeroFilas() throws IllegalArgumentException, IOException {
		return getNumeroFilas(0);
	}

	/**
	 * devuelve el n�mero de filas reales de una hoja excel.
	 * Se considera que una fila es real si alguna de sus celda no est� vac�a.
	 * 
	 * @param nHoja Número de hoja de la cual se quiere obtener el número de filas
	 * @return 
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public Integer getNumeroFilas(int nHoja) throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}
		
		if (this.filasReales < 0){
			Sheet hoja = libroExcel.getSheet(nHoja);
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
	 * Devuelve el n�mero de columns reales de una hoja excel.
	 * Se considera una columan real cuando la cabecera no est� vac�a.
	 * 
	 * @return Integer n�mero de columnas
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
			for (int i=cabeceras.length - 1; i>0; i--) {
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
	 * Comprueba si una fila de una hoja excel est� vacia.
	 * Para que una fila est� vac�a todas sus celdas deben estar vac�as.
	 * Una celda est� vac�a si su contenido es nulo o de tama�o cero.
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
	 * Si el nombre de la columna es nulo devuelve un string vac�o.
	 * Elimina los espacios en blanco al principio y final del nombre de la columna.
	 * @return lista de columnas
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public List<String> getCabeceras() 
			throws IllegalArgumentException, IOException {
		return getCabeceras(0);
	}
	/**
	 * Devuelve el listado de columnas del excel
	 * Si el nombre de la columna es nulo devuelve un string vac�o.
	 * Elimina los espacios en blanco al principio y final del nombre de la columna.
	 * @param nHoja Hoja de la cual se quieren obtener las cabeceras
	 * @return lista de columnas
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public List<String> getCabeceras(Integer nHoja) 
			throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}
		Sheet hoja = libroExcel.getSheet(nHoja);
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
			libroExcel = Workbook.getWorkbook(file);
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
		return crearExcel(nombreFichero, cabeceras, valores, false, null);
		
	}
	
	/**
	 * Creamos un Excel desde cero, recibiendo la ruta completa del nombre de fichero,
	 * la lista con las cabeceras y los valores
 	 *
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @param maxFilasPagina paginado por número de filas
	 * @return booleano que indica si todo ha ido bien
	 */
	public boolean crearNuevoExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores, Integer maxFilasPagina) {
		return crearExcel(nombreFichero, cabeceras, valores, false, maxFilasPagina);
	}

	/**
	 * Creamos un Excel desde cero o si se setea el parametro append=true a�adimos el contenido al excel si existe, recibiendo la ruta completa del nombre de fichero,
	 * la lista con las cabeceras y los valores
	 * 
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @param append indica si se a�ade al fichero
	 * @return booleano que indica si todo ha ido bien
	 */
	public boolean crearNuevoExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores, Boolean append) {
		return crearExcel(nombreFichero, cabeceras, valores, append, null);
	}
	
	/**
	 * Crear el excel generico
	 * 
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @param append indica si se a�ade al fichero
	 * @param maxFilasPagina paginado por número de filas
	 * @return booleano que indica si todo ha ido bien
	 */
	public boolean crearNuevoExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores, Boolean append, Integer maxFilasPagina) {
		return crearExcel(nombreFichero, cabeceras, valores, append, maxFilasPagina);
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
	    WritableFont cellFontBold12 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD);

	    WritableCellFormat cellFormatCabeceras = new WritableCellFormat(cellFontBold12);
	    cellFormatCabeceras.setFont(cellFontBold10);
	    cellFormatCabeceras.setAlignment(Alignment.CENTRE);
	    cellFormatCabeceras.setBackground(Colour.GRAY_25);
	    cellFormatCabeceras.setBorder(Border.ALL, BorderLineStyle.THIN);
	    cellFormatCabeceras.setWrap(false);
	    for (int i = 0; i < cabeceras.size(); i++) {
	        Label column = new Label(i, 0, cabeceras.get(i), cellFormatCabeceras);
	        sheet1.addCell(column);
	    }
	}
		
}
