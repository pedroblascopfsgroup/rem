package es.pfsgroup.framework.paradise.bulkUpload.utils;

import java.io.File;

import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;


@SuppressWarnings("deprecation")
@Component
public class MSVExcelParser {

	public  MSVHojaExcel getExcel(String ruta) 
			throws IllegalArgumentException {
		if ("".equals(ruta) || ruta==null) {
			throw new IllegalArgumentException();
		}
		MSVHojaExcel hoja=new MSVHojaExcel();
		hoja.setRuta(ruta);
		return hoja;
	}

	public  MSVHojaExcel getExcel(File file) 
			throws IllegalArgumentException {
		if (file==null) {
			throw new IllegalArgumentException();
		}
		MSVHojaExcel hoja=new MSVHojaExcel();
		hoja.setFile(file);
		return hoja;
	}

}
