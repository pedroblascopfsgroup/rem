package es.pfsgroup.commons.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormatter {

	public static final Date toDate(String s,String format) {
		if (s == null){
			return null;
		}
		SimpleDateFormat frmt = new SimpleDateFormat(format);
		try {
			return frmt.parse(s);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
			
		}
	}
	
	public static final String toString(Date d,String format){
		if (d == null){
			return null;
		}
		SimpleDateFormat frmt = new SimpleDateFormat(format);
		return frmt.format(d);
	}
	
	
}
