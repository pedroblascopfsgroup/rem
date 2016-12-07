package es.pfsgroup.plugin.rem.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.springframework.ui.ModelMap;

public class FileUtilsREM {
	
	private final static String CODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
	@SuppressWarnings("unchecked")
	public static void sendFileBase64(HttpServletResponse response, File file, ModelMap model, String fileName) {		
		Map<String, Object> dataResponse = new HashMap<String, Object>();
		try {
			byte[] bytes = read(file);
			dataResponse.put("fileName", fileName);
			dataResponse.put("hojaPropuesta",base64Encode(bytes));
			model.put("data", dataResponse);
       	} catch (Exception e) { 
       		e.printStackTrace();
       	}
	}
	
	public static String base64Encode(File file) throws IOException{
		byte[] bytes = read(file);
		return base64Encode(bytes);
	}

    private static String base64Encode(byte[] in)       {
        StringBuilder out = new StringBuilder((in.length * 4) / 3);
        int b;
        for (int i = 0; i < in.length; i += 3)  {
            b = (in[i] & 0xFC) >> 2;
            out.append(CODES.charAt(b));
            b = (in[i] & 0x03) << 4;
            if (i + 1 < in.length)      {
                b |= (in[i + 1] & 0xF0) >> 4;
                out.append(CODES.charAt(b));
                b = (in[i + 1] & 0x0F) << 2;
                if (i + 2 < in.length)  {
                    b |= (in[i + 2] & 0xC0) >> 6;
                    out.append(CODES.charAt(b));
                    b = in[i + 2] & 0x3F;
                    out.append(CODES.charAt(b));
                } else  {
                    out.append(CODES.charAt(b));
                    out.append('=');
                }
            } else      {
                out.append(CODES.charAt(b));
                out.append("==");
            }
        }
        return out.toString();
    }

    
    public static byte[] read(File file) throws IOException {
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
	    }finally {
			try {
				if (ous != null)
					ous.close();
			} catch (IOException e) {
			}
			try {
				if (ios != null)
					ios.close();
			} catch (IOException e) {
			}
	    }
	    return ous.toByteArray();
	}

	//Este método evita nulos hacia el PDF y formatea Fechas, Double...
	public static String stringify (Object obj) {
		if (obj==null) return "-";
		if (obj instanceof Date) {
			DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
			return dateFormat.format((Date) obj).toString();
		}
		if (obj instanceof Double) {
			return new DecimalFormat("#.##").format(obj);
		}
		if (obj instanceof Boolean) {
			if ((Boolean) obj) {
				return "SI";
			} else {
				return "NO";
			}
		}
		return obj.toString();
	}
}
