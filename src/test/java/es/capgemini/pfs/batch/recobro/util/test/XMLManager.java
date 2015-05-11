package es.capgemini.pfs.batch.recobro.util.test;

import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

import es.capgemini.pfs.batch.recobro.api.test.GenericConstantsTest.Genericas;

/**
 * Clase de utilidades para el tratamiento de xmls
 * @author Guillem
 *
 */
public class XMLManager {
	
	/**
	 * Parsea un XML y devuelve un objeto de tipo document
	 * @param filePath
	 * @return
	 */
	public Document parseXML(String filePath){
		Document doc = null;
		try{
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		    DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		    doc = dBuilder.parse(getXMLFile(this.getClass().getClassLoader().getResource(Genericas.EMPTY).getPath().toString()+filePath));
		}catch(Throwable e){
			System.out.println(Genericas.EXCEPTION_GENERIC_TEST_INIT_TEST_LOG);
			e.printStackTrace();
			return null;
		}
		return doc;
	}
	
	/**
	 * Obtiene el FileInputStream del fichero XML
	 * @param filePath
	 * @return
	 */
	private File getXMLFile(String filePath){
		File file = null;
		try {
			file = new File(filePath);	
		}catch(Throwable e){
			e.printStackTrace();
			return null;
		}
		return file;
	}
	
}
