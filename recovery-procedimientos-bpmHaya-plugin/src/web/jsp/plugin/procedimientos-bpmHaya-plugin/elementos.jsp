var isDisable = true;
<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	isDisable = false;
</c:if>

<c:if test="${form.errorValidacion!=null}">
	var textError = '${form.errorValidacion}';
	if (textError.indexOf('<div id="permiteGuardar">')>0) {
		isDisable = false;
	}
</c:if>

var creaElemento = function(nombre,index,type,label,value,values){
	var name='values['+(index)+']';
	switch(type) {
		case 'textarea' :
			return app.crearTextArea(label, value, isDisable, null, name, {width:'440px'} );
			break;
		case 'text' :
			return app.creaText(name, label, value, {disabled:isDisable});
			break;
		case 'textproc':
			var text = app.creaProcedimientoText(name, label, value, {disabled:isDisable});
			return text;
			break;
		case 'number' :
		case 'currency':
			return app.creaNumber(name, label, value, {disabled:isDisable}); 
			break;
		case 'date' :
			value = value.replace(/(\d*)-(\d*)-(\d*)/,"$3/$2/$1");  //conversión de yyyy-MM-dd a dd/MM/yyyy
			return new Ext.ux.form.XDateField({fieldLabel:label, name:name, value:value,style:'margin:0px', disabled:isDisable});
			break;
		case 'combo' :
			return app.creaCombo({name:name, fieldLabel:label, value:value, data:values, width:'170', disabled:isDisable});
			break;
		case 'label' :
 			return { html:label, border:false};
			break;
		case 'htmleditor' :
			return new Ext.form.HtmlEditor({
				name: name
				,fieldLabel : label
				,hideLabel:true
				,width:550
				,maxLength:3500
				,height : 300
				,value:value
				,enableColors: false
		       	,enableAlignments: false
		       	,enableFont:false
		       	,enableFontSize:false
		       	,enableFormat:false
		       	,enableLinks:false
		       	,enableLists:false
		       	,enableSourceEdit:false	
		       	,readOnly:isDisable
			});
			break;
		case 'htmledit2' :
			return new Ext.form.HtmlEditor({
				name: name
				,fieldLabel : label
				,hideLabel:false
				,width:440
				,maxLength:3500
				,height : 300
				,value:value
				,enableColors: false
		       	,enableAlignments: false
		       	,enableFont:false
		       	,enableFontSize:false
		       	,enableFormat:false
		       	,enableLinks:false
		       	,enableLists:false
		       	,enableSourceEdit:false	
		       	,readOnly:isDisable
			});
			break;
		case 'htmllabel' :
			return new Ext.form.HtmlEditor({
				name: name
				,fieldLabel : label
				,hideLabel:true
				,width:550
				,maxLength:3500
				,height : 300
				,value:value
				,enableColors: false
		       	,enableAlignments: false
		       	,enableFont:false
		       	,enableFontSize:false
		       	,enableFormat:false
		       	,enableLinks:false
		       	,enableLists:false
		       	,enableSourceEdit:false	
		       	,readOnly: true
			});
			break;		
		case 'email' :
			var text = app.creaText(name, label, value, {disabled:isDisable});
			text.validator = function(v) {
				return /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(v)? true : '<s:message code="genericForm.validacionEmail" text="**Debe introducir un email con formato xxx@xxx.com" />';
      		}			
			return text;
			break;
	}
};

