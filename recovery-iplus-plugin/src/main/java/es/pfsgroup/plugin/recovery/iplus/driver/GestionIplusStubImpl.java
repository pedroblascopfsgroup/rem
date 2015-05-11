package es.pfsgroup.plugin.recovery.iplus.driver;

import java.io.File;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.iplus.IplusDocDto;

@Component
public class GestionIplusStubImpl implements GestionIplus {

	@Autowired
	private ApiProxyFactory proxyFactory;

	public void almacenar(String idProcedi, int orden, String nombreFichero,
			File file) {

		System.out.println("[GestionIplusStubImpl.almacenar]: " + idProcedi +
				" - " + orden + " - " + nombreFichero + " - " + file.getName());
		
	}

	public List<IplusDocDto> listaDocumentos(String idProcedi) {

		System.out.println("[GestionIplusStubImpl.listaDocumentos]: " + idProcedi);
		
		String codigoTipoDoc1 = "DSCC";
		String codigoTipoProc1 = "HIPOTECARIO";
		File file1 = new File("/home/pedro/DocumentosPedro/pruebas.txt");
		String nombreFichero1 = "FICHERO 1";
		int numOrden1 = 3;
		
		String codigoTipoDoc2 = "DSCC";
		String codigoTipoProc2 = "HIPOTECARIO";
		String rutaFichero = "/home/pedro/test/áéíóúñÁÉÍÓÚÜÑçÇ.txt";
		rutaFichero = normalizar(rutaFichero);
		File file2 = new File(rutaFichero);
		String nombreFichero2 = "FICHERO 2";
		int numOrden2 = 3;
		
		List<IplusDocDto> listaResultado = new ArrayList<IplusDocDto>();
		
		IplusDocDto i1 = new IplusDocDto();
		i1.setCodigoTipoDoc(codigoTipoDoc1);
		i1.setCodigoTipoProc(codigoTipoProc1);
		i1.setFile(file1);
		i1.setIdProcedi(idProcedi);
		i1.setNombreFichero(nombreFichero1);
		i1.setNumOrden(numOrden1);
		i1.setUsuarioCrear("PBO");
		i1.setFechaCrear(new Date());
		listaResultado.add(i1);
		
		IplusDocDto i2 = new IplusDocDto();
		i2.setCodigoTipoDoc(codigoTipoDoc2);
		i2.setCodigoTipoProc(codigoTipoProc2);
		i2.setFile(file2);
		i2.setIdProcedi(idProcedi);
		i2.setNombreFichero(nombreFichero2);
		i2.setNumOrden(numOrden2);
		i2.setUsuarioCrear("PBO");
		i2.setFechaCrear(new Date());
		listaResultado.add(i2);

		return listaResultado;
	}

	@Override
	public FileItem abrirDocumento(String idProcedi, String nombre, String descripcion) {

		System.out.println("[GestionIplusStubImpl.abrirDocumento]: " + idProcedi+
				" - " + nombre + " - " + descripcion);
		
		FileItem fi = null;
		if ("FICHERO 1".equals(nombre)) {
			fi = new FileItem(new File("/home/pedro/DocumentosPedro/pruebas.txt"));
		} else if ("FICHERO 2".equals(nombre)) {
			fi = new FileItem(new File("/home/pedro/test/áéíóúñÁÉÍÓÚÜÑçÇ.txt"));
		}
		return fi;
	}

	@Override
	public void borrarDocumento(String idProcedi, String nombre, String descripcion) {

		System.out.println("[GestionIplusStubImpl.borrarDocumento]: " + idProcedi+
				" - " + nombre + " - " + descripcion);
		
	}

	@Override
	public void modificarDocumento(String idProcedi, int orden, String nombreFichero, IplusDocDto dto) {

		System.out.println("[GestionIplusStubImpl.modificarDocumento]: " + idProcedi+
				" - " + orden + " - " + nombreFichero);
		
	}

	public void setAppProperties(Properties appProperties) {
		System.out.println("[GestionIplusStubImpl.setAppProperties]");
	}

	/**
	 * Función que elimina acentos y caracteres especiales de
	 * una cadena de texto.
	 * @param input
	 * @return cadena de texto limpia de acentos y caracteres especiales.
	 */
	public static String normalizar(String input) {
		
		String aux = Normalizer.normalize(input, Normalizer.Form.NFD);
		String resultado = aux.replaceAll("[^\\x00-\\x7F]", "");
		return resultado;

	}
}
