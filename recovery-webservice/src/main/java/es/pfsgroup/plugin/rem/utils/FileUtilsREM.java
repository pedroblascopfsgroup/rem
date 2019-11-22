package es.pfsgroup.plugin.rem.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfCopy;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfSmartCopy;
import com.itextpdf.text.pdf.PdfWriter;

import es.pfsgroup.commons.utils.Checks;

public class FileUtilsREM {
	
	private FileUtilsREM() {
		throw new IllegalStateException("Utility class");
	}


	private static final  Log logger = LogFactory.getLog(FileUtilsREM.class);

	private static final String CODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

	public static String base64Encode(File file) throws IOException {
		byte[] bytes = read(file);
		return base64Encode(bytes);
	}

	private static String base64Encode(byte[] in){
		logger.debug("------------ Llamada a base64Encode-----------------");

		StringBuilder out = new StringBuilder((in.length * 4) / 3);
		int b;
		for (int i = 0; i < in.length; i += 3) {
			b = (in[i] & 0xFC) >> 2;
			out.append(CODES.charAt(b));
			b = (in[i] & 0x03) << 4;
			if (i + 1 < in.length) {
				b |= (in[i + 1] & 0xF0) >> 4;
				out.append(CODES.charAt(b));
				b = (in[i + 1] & 0x0F) << 2;
				if (i + 2 < in.length) {
					b |= (in[i + 2] & 0xC0) >> 6;
					out.append(CODES.charAt(b));
					b = in[i + 2] & 0x3F;
					out.append(CODES.charAt(b));
				} else {
					out.append(CODES.charAt(b));
					out.append('=');
				}
			} else {
				out.append(CODES.charAt(b));
				out.append("==");
			}
		}
		return out.toString();
	}

	public static byte[] read(File file) throws IOException {
		logger.debug("------------ Llamada a read-----------------");

		ByteArrayOutputStream ous = null;
		InputStream ios = null;
		try {
			byte[] buffer = new byte[4096];
			ous = new ByteArrayOutputStream();
			ios = new FileInputStream(file);
			int read = 0;
			while ((read = ios.read(buffer)) != -1) {
				ous.write(buffer, 0, read);
			}
		} finally {
			try {
				if (ous != null)
					ous.close();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
			}
			try {
				if (ios != null)
					ios.close();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
			}
		}
		return ous.toByteArray();
	}

	// Este método evita nulos hacia el PDF y formatea Fechas, Double...
	public static String stringify(Object obj){
		String cadena = "-";

		if (!Checks.esNulo(obj)) {

			if (obj instanceof Date) {
				DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
				cadena = dateFormat.format((Date) obj);

			} else if (obj instanceof Float || obj instanceof Double || obj instanceof BigDecimal) {
				DecimalFormat df = new DecimalFormat();
				DecimalFormatSymbols symbols = new DecimalFormatSymbols();
				symbols.setDecimalSeparator(','); // Simbolo de decimales
				symbols.setGroupingSeparator('.'); // Simbolo de miles
				df.setMaximumFractionDigits(2);
				df.setMinimumFractionDigits(2);
				df.setDecimalFormatSymbols(symbols);
				
				cadena = df.format(obj);
				if (cadena.equals(",00")) {
					cadena = "0,00";
				}

			} else if (obj instanceof Boolean) {
				if ((Boolean) obj) {
					cadena = "SI";
				} else {
					cadena = "NO";
				}
			} else {
				cadena = obj.toString();
			}
		}

		return cadena;

	}

	/**
	 * Merge multiple pdf into one pdf
	 * 
	 * @param list
	 *            of pdf input stream
	 * @param outputStream
	 *            output file output stream
	 * @throws DocumentException
	 * @throws IOException
	 */
	public static Document doMerge(List<byte[]> list, OutputStream outputStream) throws DocumentException, IOException {
		logger.debug("------------ Llamada a doMerge-----------------");

		Document document = new Document();
		PdfWriter writer = PdfWriter.getInstance(document, outputStream);
		document.open();
		PdfContentByte cb = writer.getDirectContent();

		for (byte[] in : list) {
			PdfReader reader = new PdfReader(in);
			for (int i = 1; i <= reader.getNumberOfPages(); i++) {
				document.newPage();
				// import the page from source pdf
				PdfImportedPage page = writer.getImportedPage(reader, i);
				// add the page to the destination pdf
				cb.addTemplate(page, 0, 0);
			}
		}

		outputStream.flush();
		document.close();
		outputStream.close();

		return document;
	}

	public static void concatenatePdfs(List<File> listOfPdfFiles, File outputFile)
			throws DocumentException, IOException {
		logger.debug("------------ Llamada a concatenatePdfs-----------------");

		Document document = new Document();
		FileOutputStream outputStream = new FileOutputStream(outputFile);
		PdfCopy copy = new PdfSmartCopy(document, outputStream);
		document.open();
		for (File inFile : listOfPdfFiles) {
			PdfReader reader = new PdfReader(inFile.getAbsolutePath());
			copy.addDocument(reader);
			reader.close();
		}
		document.close();
	}

}
