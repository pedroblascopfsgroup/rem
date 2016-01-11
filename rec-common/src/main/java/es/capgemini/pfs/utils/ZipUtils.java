package es.capgemini.pfs.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;

@Component
public class ZipUtils {
	
    @Autowired
    private  Executor executor;
	
	/**
     * Busca por nombre de archivo si su extension es una de las que hay que comprimir en ZIP durante la descarga
     * @return Boolean
     */
    public Boolean esDescargaZip(String fileName) {
     
        //Separa nombre y extension de archivo en un vector de String(). Ej nombre: archivo1.ext1.ext2.ext3
        String[] fileExts = fileName.split("\\.");
        
        //Del vector de extensiones de un archivo, solo toma la ultima como referencia: .ext3
        //Si el nombre no tiene extensiones (o nombre vacio), retorna ".xxx" en lastFileExt
        String lastFileExt = new String();
        if (fileExts.length < 2){
            lastFileExt = ".".concat("xxx");
        } else {
            lastFileExt = ".".concat(fileExts[fileExts.length-1]);
        }
        
        //Convierte todo a minusculas
        //Busca coincidencias en el parametro de extenciones a comprimir, si existe la ultima extension del archivo: ext3
        //Si el parametro contiene "*.*" directamente retorna TRUE = Comprimir siempre
        //Si no existe el parametro zip por extensiones en PEN_PARAM_ENTIDAD, retorna siempre FALSE
        //Si el parametro es la palabra "disable", retorna siempre FALSE y no comprime nunca
        String extParam = getParamZipExtensiones().toLowerCase();
        lastFileExt = lastFileExt.toLowerCase();
        if (extParam.isEmpty() || extParam.equals("disable")){
            return false;
        } else {
            if (extParam.contains("*.*")){
                return true;
            } else {
                return extParam.toLowerCase().contains(lastFileExt);
            }
        }    
    }
    
    /**
     * Recupera la cadena de extensiones de archivos adjuntos que deben comprimirse en ZIP durante la descarga
     * @return String
     */    
    private String getParamZipExtensiones() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.ADJUNTOS_DESCARGA_ZIP_EXTENSIONES);
            return param.getValor();
        } catch (Exception e) {
            System.out.println("No esta parametrizado la compresion en zip de la descarga de archivos");
            return "";
        }
    }
	
	/**
     * Comprime un fichero en zip
     * @return FileItem
     * @author Josevi
     */   
	
	public FileItem zipFileItem (FileItem fi) {
	    
        //Es importante reutilizar el nombre del archivo temporal del FileItem de entrada, mas ext. zip
        String zipFileName = fi.getFile().getName().concat(".zip");
        File zipFile = new File(zipFileName);
        FileItem fo = new FileItem();
        
        try {
            //Verifica si ya estaba creado y lo elimina para crearlo vacio
            if (zipFile.exists()) {
               zipFile.delete();
               zipFile.createNewFile();
            }
            
            // Crea un buffer de 1024
            byte[] buffer = new byte[1024];
            FileInputStream fis = new FileInputStream(fi.getFile());
            FileOutputStream fos = new FileOutputStream(zipFileName);
            ZipOutputStream zos = new ZipOutputStream(fos);

            //Define el nivel de compresion a 0 (sin)
            zos.setLevel(getParamZipNivelCompresion());

            //Incluye el archivo de entrada dentro del zip
            zos.putNextEntry(new ZipEntry(fi.getFileName()));

            int length;
            while ((length = fis.read(buffer)) > 0) {
                zos.write(buffer, 0, length);
            }

            //Cierra las entradas al zip
            zos.closeEntry();
            //Cierra FileInputStream
            fis.close();
            //Cierra ZipOutputStream
            zos.close();

        }
        catch (IOException ioe) {
            System.out.println("Error creating zip file" + ioe);
        }

        fo.setFile(zipFile);
        fo.setFileName(fi.getFileName().concat(".zip"));
        fo.setLength(zipFile.length());
        fo.setContentType("application/zip");

        return fo;
        
    }
	
	/**
     * Recupera de parametros el nivel de compresion de los archivos ZIP, entero [0-9]. Min=0, Max=9.
     * @return int
     */    
    private int getParamZipNivelCompresion() {
        final int DEFAULT_LEVEL = 8;
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.ADJUNTOS_DESCARGA_ZIP_NIVEL_COMPRESION);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
        	System.out.println("getParamZipNivelCompresion: No esta parametrizado el nivel de compresion en zip de la descarga de archivos" + e);
        } 
        return DEFAULT_LEVEL;
    }

}
