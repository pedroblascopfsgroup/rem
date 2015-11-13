<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

app.format = {};

app.format.YES = '<s:message code="mensajes.si"/>';
app.format.NO = '<s:message code="mensajes.no"/>';
app.format.DECIMAL_SEPARATOR = '<s:message code="mensajes.separadorDecimal"/>'
app.format.THOUSANDS_SEPARATOR = '<s:message code="mensajes.separadorMiles"/>' 

app.format.formatNumber = function(pnumber,decimals){
    if (isNaN(pnumber)) { return 0};
    if (pnumber=='') { return 0};
    var snum = new String(pnumber);
    var sec = snum.split('.');
    var whole = parseFloat(sec[0]);
    var result = '';
    if(sec.length > 1){
        var dec = new String(sec[1]);
        dec = String(parseFloat(sec[1])/Math.pow(10,(dec.length - decimals)));
        dec = String(whole + Math.round(parseFloat(dec))/Math.pow(10,decimals));
        var dot = dec.indexOf('.');
        if(dot == -1){
            dec += '.'; 
            dot = dec.indexOf('.');
        }
        while(dec.length <= dot + decimals) { dec += '0'; }
        result = dec;
    } else{
        var dot;
        var dec = new String(whole);
        dec += '.';
        dot = dec.indexOf('.');        
        while(dec.length <= dot + decimals) { dec += '0'; }
        result = dec;
    }    
    return result;
};

app.format.moneyRendererNull = function(num){
	if (num==null || num=="") return "";
	else return app.format.moneyRenderer(num);
}

app.format.moneyRenderer = function(num){
	if (num==null){
		num=0;
	}
	if (num=="---"){
		return "";
	}
	if (isNaN(num)) {
		return '##ERROR: CAMPO NO NUMERICO##'
	}
	num = num.toString().replace(/\$|\,/g,'');
	sign = (num == (num = Math.abs(num)));
	num = Math.floor(num*100+0.50000000001);
	cents = num%100;
	num = Math.floor(num/100).toString();
	if(cents<10)
	cents = "0" + cents;
	for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) {
		num = num.substring(0,num.length-(4*i+3))+ app.format.THOUSANDS_SEPARATOR 
			+ num.substring(num.length-(4*i+3));
	}	
	return (((sign)?'':'-') +  num + app.format.DECIMAL_SEPARATOR + cents +' '+ app.EURO);

};

app.format.percentRenderer = function(pnumber){
	var result = app.format.formatNumber(pnumber,2);
	return String.format("{0} %",result);
};

app.format.percentRendererComa = function(pnumber){
	if(pnumber.indexOf("%") > -1)
    {
		pnumber = pnumber.replace("%",""); 
    }
	var result = app.format.formatNumber(pnumber,2);
	result = result.replace(".",",");
	return String.format("{0} %",result);
};

app.format.sqrMtsRenderer = function(pnumber){
	if(pnumber!=null && pnumber!="") {
		var result = app.format.formatNumber(pnumber,2);
		return String.format("{0} m<sup>2</sup>",result);
	}
	return null;
};

app.format.booleanToYesNoRenderer = function(elBoolean){
	if (elBoolean || elBoolean=='true'){
		return app.format.YES;
	}
	return app.format.NO;
};

app.format.booleanToTextRenderer = function(elBoolean,textoTrue,TextoFalse){
	if (elBoolean || elBoolean=='true'){
		return textoTrue;
	}
	return textoFalse;
};

app.format.ifNullRenderer = function(valor,valorSiNulo){
	if (valor!=null && valor!=''){
		return valor;
	}
	return valorSiNulo;
};

app.format.fileSizeRenderer = function(valor){
	if(valor==null || valor=='') return '';
	valor = parseInt(valor);
	if (valor>1024*1024) return app.format.formatNumber( valor/(1024*1024), 2) + "Mb";
	if (valor>1024) return app.format.formatNumber( valor/(1024), 2) + "Kb";
	return valor +"bytes"
};

app.format.dateRenderer=function(d){
		if (d==null || d==''){
			return '';
		}
		var dt = new Date(d);
		return dt.format('d/m/Y');
};

app.format.stripHTML=function(valor){
	return valor.replace(/&lt;[^> ]*&gt;/g," ");
return valor;

};

app.format.trueFalseRenderer=function(d){
	return "<img src='/${appProperties.appName}/css/"+d+".gif' />";
}

app.format.booleanFlagToYesNoRenderer = function(flag){

	if (flag === 1 || flag === "1"){
		return app.format.YES;
	} else if (flag === 0 || flag ==="0"){
		return app.format.NO;
	} else {	
		return "";
	}
};