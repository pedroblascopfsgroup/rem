package es.pfsgroup.plugin.recovery.coreextension.utils.jxl;

import java.io.File;
import java.io.IOException;
import java.util.List;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableCell;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;



public class HojaExcelInformeSubasta extends HojaExcel{
	
	@SuppressWarnings("unused")
	private int filasReales;
	@SuppressWarnings("unused")
	private Workbook libroExcel; 
	
	public HojaExcelInformeSubasta(){
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
		return crearExcel(nombreFichero, cabeceras, valores, false);
		
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
					Workbook target_workbook = Workbook.getWorkbook(fileFinal);
					workbook = Workbook.createWorkbook(fileTMP, target_workbook);
					
					sheet1 = workbook.getSheet(0);
					this.libroExcel = target_workbook;
					this.setFile(fileFinal);		
					this.filasReales = -1;
					filaAnt = getNumeroFilas()-1;
					
					target_workbook.close();
					
					copiado = true;
				}
			} 
			if (fileTMP.canWrite()) {
				if (!copiado) {
					// Pintamos las cabeceras de las columnas.
				    
				    WritableFont cellFontBold12 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, Colour.WHITE);

				    WritableCellFormat cellFormatCabeceras = new WritableCellFormat(cellFontBold12);
				    cellFormatCabeceras.setAlignment(Alignment.CENTRE);
				    cellFormatCabeceras.setBackground(Colour.BLUE);
				    cellFormatCabeceras.setBorder(Border.ALL, BorderLineStyle.THIN);
				    cellFormatCabeceras.setWrap(false);
				  
				    for (int i = 0; i < cabeceras.size(); i++) {
				        Label column = new Label(i, 0, cabeceras.get(i), cellFormatCabeceras);
				        sheet1.setColumnView(column.getColumn(), 30);
				        sheet1.addCell(column);
				    }
				    
				    
				}
				WritableFont cellFontBold10 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
			    for (int i = 0; i < valores.size(); i++) {
					for (int j = 0; j < valores.get(i).size(); j++) {
						String [] contenidoColor=new String[3];
						
						contenidoColor=valores.get(i).get(j).split(";");
						
						
						if(contenidoColor.length!=3){
							contenidoColor=new String[3];
							contenidoColor[0]=" ";
							contenidoColor[1]=" ";
							contenidoColor[2]=" ";
						}
						
						WritableCell celda=null;
						WritableCellFormat cellFormat=null;
						
						if(contenidoColor[2].equalsIgnoreCase("Number")){
							try{
								jxl.write.NumberFormat currency = new jxl.write.NumberFormat("#,###.00 \u20AC",jxl.write.NumberFormat.COMPLEX_FORMAT); 
								cellFormat = new WritableCellFormat(currency);
								celda=new jxl.write.Number(j, i+filaAnt+1,Double.parseDouble(contenidoColor[0]), cellFormat);
								
							}catch(Exception e){
								cellFormat=new WritableCellFormat();
								celda = new Label(j, i+filaAnt+1, contenidoColor[0]); 
							}
						}
						else{
							cellFormat=new WritableCellFormat();
							celda = new Label(j, i+filaAnt+1, contenidoColor[0]); 
							
						}
						
						Colour myColour=null;
						if(contenidoColor[1].equals("Blue")){
							myColour=Colour.BLUE;
							cellFormat.setFont(cellFontBold10);
							if(contenidoColor[0].equalsIgnoreCase("MENSAJES VALIDACION")){
								sheet1.mergeCells(0, i+2, 4, i+2);
								sheet1.mergeCells(0, i+3, 4, i+3);
								sheet1.mergeCells(0, i+4, 4, i+4);
								sheet1.mergeCells(0, i+5, 4, i+5);
								sheet1.mergeCells(0, i+6, 4, i+6);
								sheet1.mergeCells(0, i+7, 4, i+7);
							}
						}
						else if(contenidoColor[1].equals("Grey")){
							myColour=Colour.GRAY_25;
							cellFormat.setFont(cellFontBold10);
						}
						else if(contenidoColor[1].equals("Red")){
							myColour=Colour.RED;
							WritableFont cellFontError = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
							cellFontError.setColour(Colour.WHITE);
							cellFormat.setFont(cellFontError);
							cellFormat.setAlignment(Alignment.LEFT);
						
						}
						else{
							myColour=Colour.WHITE;
						}
						
						cellFormat.setBackground(myColour);
						celda.setCellFormat(cellFormat);
						sheet1.setColumnView(i, 30);
						sheet1.addCell(celda);
						
					}
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
		
}
