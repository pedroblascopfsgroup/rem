<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

app.validate = {};

app.validate.validateNumeric = function(valor,mascara){
    var strValidChars = mascara; 
    var strChar;
    var blnResult = true;

    if (valor.length == 0) return false;

    //  test strString consists of valid characters listed above
    for (i = 0; i < valor.length && blnResult == true; i++)
    {
      strChar = valor.charAt(i);
      if (mascara.indexOf(strChar) == -1)
      {
         blnResult = false;
      }
    }
    return blnResult;	
};

app.validate.validateInteger = function(valor){
	return app.validate.validateNumeric(valor,"0123456789");	
};

app.validate.validateDecimal = function(valor){
	return app.validate.validateNumeric(valor,"0123456789.,-");
};
