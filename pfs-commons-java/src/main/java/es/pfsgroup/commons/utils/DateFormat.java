package es.pfsgroup.commons.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


public class DateFormat {
	
	public static final String DATE_FORMAT = "dd/MM/yyyy";
	
	public static final Date toDate(String s) throws ParseException{
		if (Checks.esNulo(s)){
			return null;
		}
		SimpleDateFormat frmt = new SimpleDateFormat(DATE_FORMAT);
		return frmt.parse(s);
	}
	
	public static final String toString(Date d){
		if (d == null){
			return null;
		}
		SimpleDateFormat frmt = new SimpleDateFormat(DATE_FORMAT);
		return frmt.format(d);
	}
	

}
