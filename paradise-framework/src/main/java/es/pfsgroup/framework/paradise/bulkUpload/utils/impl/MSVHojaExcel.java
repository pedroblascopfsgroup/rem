package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
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

	private int posColumnaPrincipal = -1;

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
	 * Devuelve el numero de filas reales de la hoja excel Debe usarse en hojas
	 * excel que solo tienen 1 hoja y 1 fila de cabecera Se considera que una
	 * fila es real si alguna de sus celda no esta vacia.
	 * 
	 * @return
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public Integer getNumeroFilas() throws IllegalArgumentException, IOException {

		return this.getNumeroFilasByHoja(0, null);
	}

	/**
	 * Devuelve el numero de filas reales de la hoja excel indicada por
	 * parametro primeraFilaDatos indica la fila en la que comienzan los datos
	 * (para cabeceras de mas de 1 fila) Se considera que una fila es real si
	 * alguna de sus celda no esta vacia. Cuenta las filas reales de la primera
	 * columna OBLOGATORIA de la hoja excel
	 * 
	 * @param numHoja
	 *            (minimo 0)
	 * @param tipoMasivo
	 *            para obtener la posicion de la primera columna obligatoria
	 * @return
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public Integer getNumeroFilasByHoja(int numHoja, MSVDDOperacionMasiva tipoMasivo)
			throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}

		if (this.filasReales < 0) {

			this.setPrimeraColumnaObligatoriaByOperacion(tipoMasivo);

			Sheet hoja = libroExcel.getSheet(numHoja);
			this.filasReales = 0;
			this.filasReales = hoja.getColumn(this.posColumnaPrincipal).length;
		}

		return this.filasReales;
	}

	/**
	 * Devuelve el número de columns reales de una hoja excel. Se considera una
	 * columan real cuando la cabecera no está vacía.
	 * 
	 * @return Integer número de columnas
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public Integer getNumeroColumnas() throws IllegalArgumentException, IOException {

		return this.getNumeroColumnasByHojaAndFila(0, 0);
	}

	public Integer getNumeroColumnasByHojaAndFila(int numHoja, int numFila)
			throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}

		if (this.columnasReales < 0) {
			this.columnasReales = 0;
			Sheet hoja = libroExcel.getSheet(numHoja);
			this.columnasReales = hoja.getRow(numFila).length;
		}
		return this.columnasReales;
	}

	/**
	 * Devuelve el listado de columnas del excel Si el nombre de la columna es
	 * nulo devuelve un string vacío. Elimina los espacios en blanco al
	 * principio y final del nombre de la columna.
	 * 
	 * @return lista de columnas
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	public List<String> getCabeceras() throws IllegalArgumentException, IOException {
		if (!isOpen) {
			abrir();
		}
		Sheet hoja = libroExcel.getSheet(0);
		List<String> lista = new ArrayList<String>();
		int numColumnas = this.getNumeroColumnas();
		for (int i = 0; i < numColumnas; i++) {
			String nombre = hoja.getCell(i, 0).getContents();
			if (nombre == null)
				nombre = "";
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
		addTexto(hoja, numColumnas, 0, "Error");
		for (int i = 0; i < listaErrores.size(); i++) {
			addTexto(hoja, numColumnas, i + 1, listaErrores.get(i));
		}
		copy.write();
		copy.close();

		return nombreFicheroErrores;
	}
	
	public FileItem insertarErroresExcel(FileItem fileitem,Map<String, List<Integer>> mapaErrores, int numHoja,
			int numFilaCabeceras, int fila) throws IOException, RowsExceededException, WriteException, BiffException{
		
		WorkbookSettings workbookSettings = new WorkbookSettings();
		workbookSettings.setEncoding("Cp1252");
		workbookSettings.setSuppressWarnings(true);
		libroExcel = Workbook.getWorkbook(file, workbookSettings);
		
		Workbook excel=  Workbook.getWorkbook(fileitem.getFile());
		libroExcel=excel;
		
		WritableWorkbook copy = Workbook.createWorkbook(fileitem.getFile(),libroExcel);
		
		try {

			WritableSheet hoja = copy.getSheet(numHoja);
			int numColumnas = this.getNumeroColumnasByHojaAndFila(numHoja, numFilaCabeceras);

			int columna = numColumnas;
			if(mapaErrores.get("KO").size()==1){
				addTexto(hoja, columna, 0, "ERRORES");
				addTexto(hoja, columna, fila, "KO");
			}
			else{
				addTexto(hoja, columna, fila, "KO");
			}
			copy.write();
		} finally {
			copy.close();
		}
		
		return fileitem;
		
	}

	public String crearExcelErroresMejorado(Map<String, List<Integer>> mapaErrores)
			throws IllegalArgumentException, IOException, RowsExceededException, WriteException {

		return this.crearExcelErroresMejoradoByHojaAndFilaCabecera(mapaErrores, 0, 0);
	}

	public String crearExcelErroresMejoradoByHojaAndFilaCabecera(Map<String, List<Integer>> mapaErrores, int numHoja,
			int numFilaCabeceras) throws IllegalArgumentException, IOException, RowsExceededException, WriteException {
		if (!isOpen) {
			abrir();
		}

		String nombreFicheroErrores = getNombreFicheroErrores();

		WritableWorkbook copy = Workbook.createWorkbook(new File(nombreFicheroErrores), libroExcel);
		try {

			WritableSheet hoja = copy.getSheet(numHoja);
			int numColumnas = this.getNumeroColumnasByHojaAndFila(numHoja, numFilaCabeceras);

			Iterator<String> it = mapaErrores.keySet().iterator();
			int columna = numColumnas;
			while (it.hasNext()) {
				String error = (String) it.next();
				addTexto(hoja, columna, 0, "ERRORES");
				for (int i = 0; i < mapaErrores.get(error).size(); i++) {
					addTextoErrores(hoja, columna, mapaErrores.get(error).get(i), error);
				}
				if (!mapaErrores.get(error).isEmpty()) {
					// columna++;
				}
			}
			copy.write();
		} finally {
			copy.close();
		}
		

		return nombreFicheroErrores;
	}
	public String crearExcelErroresMejoradoByHojaAndFilaCabeceraConValores(Map<String, List<Integer>> mapaErrores, Map<String, List<String>> mapaValres, int numHoja,
			int numFilaCabeceras) throws IllegalArgumentException, IOException, RowsExceededException, WriteException {
		if (!isOpen) {
			abrir();
		}

		String nombreFicheroErrores = getNombreFicheroErrores();

		WritableWorkbook copy = Workbook.createWorkbook(new File(nombreFicheroErrores), libroExcel);
		try {

			WritableSheet hoja = copy.getSheet(numHoja);
			int numColumnas = this.getNumeroColumnasByHojaAndFila(numHoja, numFilaCabeceras);
			String nuevoValor =null;

			Iterator<String> it = mapaErrores.keySet().iterator();
			int columna = numColumnas;
			while (it.hasNext()) {
				String error = (String) it.next();
				addTexto(hoja, columna, 0, "ERRORES");
				for (int i = 0; i < mapaErrores.get(error).size(); i++) {
					if (!Checks.esNulo(mapaValres.get(error))) {
						if (!mapaValres.get(error).isEmpty()){
							if (!Checks.esNulo(mapaValres.get(error).get(i))) {
								nuevoValor  = mapaValres.get(error).get(i);
		
							}
						}
				 }
					else {
						nuevoValor = "";
					}
					if (!Checks.esNulo(mapaErrores.get(error).get(i)))
					addTextoErrores(hoja, columna, mapaErrores.get(error).get(i), error+""+nuevoValor);
				}
				if (!mapaErrores.get(error).isEmpty()) {
					// columna++;
				}
			}
			copy.write();
		} finally {
			copy.close();
		}
		

		return nombreFicheroErrores;
	}
	
	public String crearExcelResultadosByHojaAndFilaCabecera(Map<String, String> mapaResultados, int numHoja,
			int numFilaCabeceras) throws IllegalArgumentException, IOException, RowsExceededException, WriteException {
		if (!isOpen) {
			abrir();
		}

		String nombreFicheroResultados = getNombreFicheroResultados();

		WritableWorkbook copy = Workbook.createWorkbook(new File(nombreFicheroResultados), libroExcel);
		try {
			WritableSheet hoja = copy.getSheet(numHoja);
			int numColumnas = this.getNumeroColumnasByHojaAndFila(numHoja, numFilaCabeceras);
			Iterator<String> it = mapaResultados.keySet().iterator();
			int columna = numColumnas;
			int filas = 1;
			while (it.hasNext()) {
				String resultado = (String) it.next();
				addTexto(hoja, columna, filas, resultado);
				
				addTextoResultados(hoja, (columna + 1), filas,  mapaResultados.get(resultado));

				if (!mapaResultados.get(resultado).isEmpty()) {
					filas++;
				}
			}
			copy.write();
		} finally {
			copy.close();
		}
		

		return nombreFicheroResultados;
	}
	
	public String crearExcelResultado(ArrayList<ResultadoProcesarFila> resultados,int numHoja,
			int numFilaCabeceras)
			throws IllegalArgumentException, IOException, RowsExceededException, WriteException {

		return this.crearExcelProcesadoByHojaAndFilaCabecera(resultados, numHoja, numFilaCabeceras);
	}

	public String crearExcelProcesadoByHojaAndFilaCabecera(ArrayList<ResultadoProcesarFila> resultados, int numHoja,
			int numFilaCabeceras) throws IllegalArgumentException, IOException, RowsExceededException, WriteException {
		if (!isOpen) {
			abrir();
		}

		String nombreFicheroErrores = getNombreFicheroErrores();

		WritableWorkbook copy = Workbook.createWorkbook(new File(nombreFicheroErrores), libroExcel);
		try {

			WritableSheet hoja = copy.getSheet(numHoja);
			int numColumnas = this.getNumeroColumnasByHojaAndFila(numHoja, 0);
			int columna = numColumnas;
			addTexto(hoja, columna, numFilaCabeceras-1, "RESULTADO");
			addTexto(hoja, columna+1, numFilaCabeceras-1, "DESC. ERROR");
			if (resultados != null && resultados.size() > 0 && resultados.get(0).gethMap() != null
					&& resultados.get(0).gethMap().size() > 0) {
				int colnN =2;
				for (Map.Entry<String, String> entry : resultados.get(0).gethMap().entrySet()) {
					addTexto(hoja, columna+colnN, numFilaCabeceras-1, entry.getKey());
					colnN++;
				}

			}
			for(ResultadoProcesarFila resultado : resultados){
				if(resultado.isCorrecto()){
					addTexto(hoja, columna, resultado.getFila(), "OK");
					if(resultado.gethMap() != null && resultado.gethMap().size() > 0){
						int colnN =2;
						for (Map.Entry<String, String> entry : resultado.gethMap().entrySet()) {
							addTexto(hoja, columna+colnN, resultado.getFila(), entry.getValue());
							colnN++;
							
						}
					}
				}else{
					addTexto(hoja, columna, resultado.getFila(), "FALSE");
					addTextoErrores(hoja, columna+1, resultado.getFila(), resultado.getErrorDesc());
				}
				
			}

			
			copy.write();
		} finally {
			copy.close();
		}
		

		return nombreFicheroErrores;
	}

	public String dameCelda(int fila, int columna) throws IllegalArgumentException, IOException, ParseException {

		return dameCeldaByHoja(fila, columna, 0);
	}

	/**
	 * Devuelve la celda de la hoja y poisiciones indicadas por parametro
	 * 
	 * @param fila
	 * @param columna
	 * @param numHoja
	 * @return
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	public String dameCeldaByHoja(int fila, int columna, int numHoja)
			throws IllegalArgumentException, IOException, ParseException {
		if (!isOpen) {
			abrir();
		}
		String cellContent = null;
		Sheet hoja = libroExcel.getSheet(numHoja);
		Cell cell = hoja.getCell(columna, fila);

		if (cell.getType() == CellType.DATE) {
			DateCell dc = (DateCell) cell;
			DateFormat df = new SimpleDateFormat(FormatUtils.DDMMYYYY);
			cellContent = df.format(dc.getDate());
		} else {

			if (cell.getType() == CellType.NUMBER) {
				cellContent = getValidatedNumber(cell.getContents());
			} else {
				cellContent = cell.getContents();
			}
		}

		return cellContent;
	}

	public String getValidatedNumber(String cellValue) throws ParseException {
		DecimalFormat df = new DecimalFormat();
		DecimalFormatSymbols symbols = new DecimalFormatSymbols();

		// Comprobación si es formato español o inglés de separar miles y
		// decimales
		if (!Checks.esNulo(cellValue) && cellValue.length() > 3
				&& cellValue.substring(cellValue.length() - 3, cellValue.length() - 2).equals(".")) {
			symbols.setDecimalSeparator('.'); // Simbolo de decimales

			if (cellValue.contains(",")) {
				symbols.setGroupingSeparator(','); // Simbolo de miles
			}

		} else if (!Checks.esNulo(cellValue) && cellValue.length() > 3
				&& cellValue.substring(cellValue.length() - 3, cellValue.length() - 2).equals(",")) {

			symbols.setDecimalSeparator(','); // Simbolo de decimales

			if (cellValue.contains(".")) {

				symbols.setGroupingSeparator('.'); // Simbolo de miles
			}
		}

		symbols.setMinusSign('-'); // Simbolo numero negativo

		if (!Checks.esNulo(cellValue) && cellValue.contains("E"))
			symbols.setExponentSeparator("E"); // Simbolo numero exponencial

		if (!Checks.esNulo(cellValue) && cellValue.contains("%"))
			symbols.setPercent('%'); // Simbolo porcentaje

		df.setDecimalFormatSymbols(symbols);

		if (!Checks.esNulo(cellValue))
			return String.valueOf(df.parse(cellValue));
		else
			return null;
	}

	public void cerrar() {

		libroExcel = null;

		file = null;

		ruta = null;
		isOpen = false;

	}

	private void abrir() throws IllegalStateException, IOException {

		if ((ruta == null || (ruta.equals(""))) && (file == null)) {
			throw new IllegalStateException("El objeto MSVHojaExcel no tiene inicializada ni la ruta ni el file");
		}

		if (file == null) {
			file = new File(ruta);
		}

		try {
			WorkbookSettings workbookSettings = new WorkbookSettings();
			workbookSettings.setEncoding("Cp1252");
			workbookSettings.setSuppressWarnings(true);
			libroExcel = Workbook.getWorkbook(file, workbookSettings);
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

	private void addTextoErrores(WritableSheet sheet, int column, int row, String s)
			throws RowsExceededException, WriteException {
		Label label;
		Cell celdaErrores = sheet.getCell(column, row);
		if (!Checks.esNulo(celdaErrores)) {
			String erroresAnteriores = celdaErrores.getContents();
			label = new Label(column, row, erroresAnteriores + " - " + s);
			sheet.addCell(label);
		}
	}
	
	private void addTextoResultados(WritableSheet sheet, int column, int row, String s)
			throws RowsExceededException, WriteException {
		Label label;
		Cell celdaResultados = sheet.getCell(column, row);
		String erroresAnteriores = celdaResultados.getContents();
		label = new Label(column, row, erroresAnteriores + " - " + s);
		sheet.addCell(label);
	}

	private String getNombreFicheroErrores() {
		String path;
		if (this.file != null) {
			path = this.file.getAbsolutePath();
		} else if (!Checks.esNulo(this.ruta)) {
			path = this.ruta;
		} else {
			throw new IllegalStateException("No se ha inicializado el File ni la Ruta");
		}

		String nombre = path.replace(".xls", "Err.xls").replace(".csv", "Err.csv").replace(".tmp", "Err.tmp");
		return nombre;

	}
	
	private String getNombreFicheroResultados() {
		
		String path;
		if (this.file != null) {
			path = this.file.getAbsolutePath();
		} else if (!Checks.esNulo(this.ruta)) {
			path = this.ruta;
		} else {
			throw new IllegalStateException("No se ha inicializado el File ni la Ruta");
		}

		String nombre = path.replace(".xls", "Err.xls").replace(".csv", "Err.csv").replace(".tmp", "Err.tmp");
		return nombre;

	}

	/**
	 * Creamos un Excel desde cero, recibiendo la ruta completa del nombre de
	 * fichero, la lista con las cabeceras y los valores
	 * 
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @return booleano que indica si todo ha ido bien
	 */
	public boolean crearNuevoExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores) {
		return crearExcel(nombreFichero, cabeceras, valores, false);
		// boolean ok = true;
		//
		// File file = new File(nombreFichero);
		// try {
		// if (!file.exists()) {
		// file.createNewFile();
		// }
		// if (file.canWrite()) {
		// WritableWorkbook workbook = Workbook.createWorkbook(file);
		// WritableSheet sheet1 = workbook.createSheet("Hoja 1",0);
		//
		// // Pintamos las cabeceras de las columnas.
		// WritableFont cellFontBold10 = new WritableFont(WritableFont.ARIAL,
		// 10, WritableFont.BOLD);
		// WritableFont cellFontBold12 = new WritableFont(WritableFont.ARIAL,
		// 12, WritableFont.BOLD);
		//
		// WritableCellFormat cellFormatCabeceras = new
		// WritableCellFormat(cellFontBold12);
		// cellFormatCabeceras.setFont(cellFontBold10);
		// cellFormatCabeceras.setAlignment(Alignment.CENTRE);
		// cellFormatCabeceras.setBackground(Colour.PLUM2);
		// cellFormatCabeceras.setBorder(Border.ALL, BorderLineStyle.THIN);
		// cellFormatCabeceras.setWrap(false);
		// for (int i = 0; i < cabeceras.size(); i++) {
		// Label column = new Label(i, 0, cabeceras.get(i),
		// cellFormatCabeceras);
		// sheet1.addCell(column);
		// }
		//
		// for (int i = 0; i < valores.size(); i++) {
		// for (int j = 0; j < valores.get(i).size(); j++) {
		// Label celda = new Label(j, i+1, valores.get(i).get(j));
		// sheet1.addCell(celda);
		// }
		// }
		// workbook.write();
		// workbook.close();
		// }
		// } catch (RowsExceededException e) {
		// ok = false;
		// e.printStackTrace();
		// } catch (WriteException e) {
		// ok = false;
		// e.printStackTrace();
		// } catch (IOException e) {
		// ok = false;
		// e.printStackTrace();
		// }
		// return ok;

	}

	/**
	 * Creamos un Excel desde cero o si se setea el parametro append=true
	 * añadimos el contenido al excel si existe, recibiendo la ruta completa del
	 * nombre de fichero, la lista con las cabeceras y los valores
	 * 
	 * @param nombreFichero
	 * @param cabeceras
	 * @param valores
	 * @param append
	 *            indica si se añade al fichero
	 * @return
	 */
	public boolean crearNuevoExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores,
			Boolean append) {
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
	private boolean crearExcel(String nombreFichero, List<String> cabeceras, List<List<String>> valores,
			Boolean append) {
		boolean ok = true;
		boolean copiado = false;

		// Creamos un fichero temporal para copiar en caso de existir y trabajar
		// sobre este en todos los casos
		String nombreFicheroTMP = nombreFichero + ".tmp.xls";
		File fileTMP = new File(nombreFicheroTMP);

		// Este será el fichero final, en el que se comprobará que exista y
		// luego se reemplazará
		File fileFinal = new File(nombreFichero);

		try {

			// Se crea el fichero temporal en todos los casos ya que es aquí
			// donde se va a escribir
			if (fileTMP.exists())
				fileTMP.delete();
			fileTMP.createNewFile();

			WritableWorkbook workbook = Workbook.createWorkbook(fileTMP);
			WritableSheet sheet1 = workbook.createSheet("Hoja 1", 0);

			int filaAnt = 0;
			if (!fileFinal.exists()) {
				fileFinal.createNewFile();
			} else {
				// Si tiene que añadir al documento, se copiara el contenido de
				// fileFinal a fileTMP
				if (append) {
					WorkbookSettings workbookSettings = new WorkbookSettings();
					workbookSettings.setEncoding("Cp1252");
					workbookSettings.setSuppressWarnings(true);
					Workbook target_workbook = Workbook.getWorkbook(fileFinal, workbookSettings);
					workbook = Workbook.createWorkbook(fileTMP, target_workbook);

					sheet1 = workbook.getSheet(0);
					this.libroExcel = target_workbook;
					this.file = fileFinal;
					this.filasReales = -1;
					filaAnt = getNumeroFilas() - 1;

					target_workbook.close();

					copiado = true;
				}
			}
			if (fileTMP.canWrite()) {
				if (!copiado) {
					// Pintamos las cabeceras de las columnas.
					// workbook = Workbook.createWorkbook(fileTMP);
					// sheet1 = workbook.createSheet("Hoja 1",0);

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
						Label celda = new Label(j, i + filaAnt + 1, valores.get(i).get(j));
						sheet1.addCell(celda);
					}
				}
				workbook.write();
				workbook.close();

				// Hacemos que el fileTMP sea el fileFinal
				if (fileFinal.exists())
					fileFinal.delete();
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

	private void setPrimeraColumnaObligatoriaByOperacion(MSVDDOperacionMasiva tipoMasivo) {
		if (!Checks.esNulo(tipoMasivo)) {

			setPosColumnaByFormato(tipoMasivo.getValidacionFormato());
		} else
			this.posColumnaPrincipal = 0;
	}

	public void setPosColumnaByFormato(String validacionFormato) {
		if (this.posColumnaPrincipal < 0 && !Checks.esNulo(validacionFormato)) {
			String[] formato = validacionFormato.split(",");

			for (int i = 0; i < formato.length; i++) {
				if (formato[i].contains("*")) {
					this.posColumnaPrincipal = i;
					break;
				}
			}
		} else
			this.posColumnaPrincipal = 0;
	}

}
